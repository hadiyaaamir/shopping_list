part of 'shopping_list_repository.dart';

class ShoppingListRepositoryFirebase extends ShoppingListRepository {
  final listItemCollection =
      FirebaseFirestore.instance.collection("ListItems").withConverter(
            fromFirestore: (snapshot, _) =>
                ShoppingListItem.fromJson(snapshot.data()!),
            toFirestore: (value, _) => value.toJson(),
          );

  final shoppingListCollection = FirebaseFirestore.instance
      .collection("ShoppingLists")
      .withConverter(
        fromFirestore: (snapshot, _) => ShoppingList.fromJson(snapshot.data()!),
        toFirestore: (value, _) => value.toJson(),
      );

  Stream<List<ShoppingList>> getAllLists({required String userId}) {
    return shoppingListCollection
        .orderBy('dateCreated', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data())
          .where((shoppingList) =>
              shoppingList.userId == userId ||
              shoppingList.users.any((user) => user.id == userId))
          .toList();
    });
  }

  @override
  Stream<List<ShoppingListItem>> getShoppingList({required String listId}) {
    return listItemCollection
        .where('listId', isEqualTo: listId)
        .orderBy('isCompleted')
        .orderBy('dateCreated', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) => e.data()).toList());
  }

  @override
  Future<void> saveListItem(ShoppingListItem listItem) async {
    await listItemCollection.doc(listItem.id).set(listItem);
  }

  @override
  Future<void> saveShoppingList(ShoppingList shoppingList) async {
    await shoppingListCollection.doc(shoppingList.id).set(shoppingList);
  }

  Future<void> addUserToList(
      {required String listId, required ListUser user}) async {
    final shoppingList = await shoppingListCollection.doc(listId).get();
    if (shoppingList.exists) {
      final List<ListUser> updatedListUsers = [
        ...shoppingList.data()!.users,
        user
      ];
      if (shoppingList
          .data()!
          .users
          .any((existingUser) => existingUser.id == user.id)) {
        throw UserAlreadyExistsException('User already exists in the list.');
      }
      await saveShoppingList(
          shoppingList.data()!.copyWith(users: updatedListUsers));
    }
  }

  Future<void> editShoppingListUser(
      {required String listId, required ListUser editedUser}) async {
    final shoppingList = await shoppingListCollection.doc(listId).get();
    if (shoppingList.exists) {
      final List<ListUser> updatedListUsers = shoppingList
          .data()!
          .users
          .map((user) => user.id == editedUser.id ? editedUser : user)
          .toList();

      await saveShoppingList(
        shoppingList.data()!.copyWith(users: updatedListUsers),
      );
    }
  }

  Future<void> deleteShoppingListUser(
      {required String listId, required String userId}) async {
    final shoppingList = await shoppingListCollection.doc(listId).get();
    if (shoppingList.exists) {
      final List<ListUser> updatedListUsers = shoppingList
          .data()!
          .users
          .where((user) => user.id != userId)
          .toList();

      await saveShoppingList(
        shoppingList.data()!.copyWith(users: updatedListUsers),
      );
    }
  }

  @override
  Future<void> deleteListItem(String id) async {
    final todoFirestore = await listItemCollection.doc(id).get();

    todoFirestore.exists
        ? await listItemCollection.doc(id).delete()
        : throw TodoNotFoundException();
  }

  @override
  Future<void> deleteShoppingList(String id) async {
    final todoListFirestore = await shoppingListCollection.doc(id).get();

    todoListFirestore.exists
        ? await shoppingListCollection.doc(id).delete()
        : throw TodoListNotFoundException();
  }

  @override
  Future<int> clearCompletedItems({required String listId}) {
    final batch = FirebaseFirestore.instance.batch();
    return listItemCollection
        .where('listId', isEqualTo: listId)
        .where('isCompleted', isEqualTo: true)
        .get()
        .then(
      (querySnapshot) {
        for (final document in querySnapshot.docs) {
          batch.delete(document.reference);
        }
        batch.commit();
        return querySnapshot.docs.length;
      },
    );
  }

  @override
  Future<int> toggleCompleteAllItems(
      {required bool isCompleted, required String listId}) async {
    final batch = FirebaseFirestore.instance.batch();
    return listItemCollection.where('listId', isEqualTo: listId).get().then(
      (querySnapshot) {
        for (final document in querySnapshot.docs) {
          final toggledTodo =
              document.data().copyWith(isCompleted: isCompleted);
          batch.update(document.reference, toggledTodo.toJson());
        }
        batch.commit();
        return querySnapshot.docs.length;
      },
    );
  }

  Future<void> shoppingListIncrementTotal(
      {int value = 1, required String listId}) async {
    await shoppingListCollection.doc(listId).get().then((snapshot) {
      if (snapshot.data() != null) {
        saveShoppingList(
          snapshot
              .data()!
              .copyWith(totalItems: snapshot.data()!.totalItems + value),
        );
      }
    });
  }

  @override
  Future<void> shoppingListSetTotal(
      {required int value, required String listId}) async {
    await shoppingListCollection.doc(listId).get().then((snapshot) {
      if (snapshot.data() != null) {
        saveShoppingList(
          snapshot.data()!.copyWith(totalItems: value),
        );
      }
    });
  }
}

class UserAlreadyExistsException implements Exception {
  final String message;

  UserAlreadyExistsException(this.message);
}
