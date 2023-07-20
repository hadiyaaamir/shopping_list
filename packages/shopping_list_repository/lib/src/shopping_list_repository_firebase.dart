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

  Future<void> shoppingListIncrementCompleted(
      {int value = 1, required String listId}) async {
    await shoppingListCollection.doc(listId).get().then((snapshot) {
      if (snapshot.data() != null) {
        saveShoppingList(
          snapshot.data()!.copyWith(
              completedItems: snapshot.data()!.completedItems + value),
        );
      }
    });
  }

  Future<void> shoppingListDecrementCompleted(
      {int value = 1, required String listId}) async {
    await shoppingListCollection.doc(listId).get().then((snapshot) {
      if (snapshot.data() != null) {
        saveShoppingList(
          snapshot.data()!.copyWith(
              completedItems: snapshot.data()!.completedItems - value),
        );
      }
    });
  }

  Future<void> shoppingListIncrementActive(
      {int value = 1, required String listId}) async {
    await shoppingListCollection.doc(listId).get().then((snapshot) {
      if (snapshot.data() != null) {
        saveShoppingList(
          snapshot
              .data()!
              .copyWith(activeItems: snapshot.data()!.activeItems + value),
        );
      }
    });
  }

  Future<void> shoppingListDecrementActive(
      {int value = 1, required String listId}) async {
    await shoppingListCollection.doc(listId).get().then((snapshot) {
      if (snapshot.data() != null) {
        saveShoppingList(
          snapshot
              .data()!
              .copyWith(activeItems: snapshot.data()!.activeItems - value),
        );
      }
    });
  }

  @override
  Future<void> shoppingListSetActive(
      {required int value, required String listId}) async {
    await shoppingListCollection.doc(listId).get().then((snapshot) {
      if (snapshot.data() != null) {
        saveShoppingList(
          snapshot.data()!.copyWith(activeItems: value),
        );
      }
    });
  }

  @override
  Future<void> shoppingListSetCompleted(
      {required int value, required String listId}) async {
    await shoppingListCollection.doc(listId).get().then((snapshot) {
      if (snapshot.data() != null) {
        saveShoppingList(
          snapshot.data()!.copyWith(completedItems: value),
        );
      }
    });
  }
}
