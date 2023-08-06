import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/model.dart';

part 'shopping_list_repository_firebase.dart';

abstract class ShoppingListRepository {
  const ShoppingListRepository();

  Stream<List<ShoppingList>> getAllLists({required String userId});
  Stream<List<ShoppingListItem>> getShoppingList({required String listId});

  Future<void> saveShoppingList(ShoppingList shoppingList);
  Future<void> saveListItem(ShoppingListItem listItem);

  Future<void> addUserToList({required String listId, required ListUser user});
  Future<void> editShoppingListUser(
      {required String listId, required ListUser editedUser});
  Future<void> deleteShoppingListUser(
      {required String listId, required String userId});

  Future<void> deleteShoppingList(String id);
  Future<void> deleteListItem(String id);

  Future<int> clearCompletedItems({required String listId});
  Future<int> toggleCompleteAllItems(
      {required bool isCompleted, required String listId});

  Future<void> shoppingListIncrementTotal(
      {int value = 1, required String listId});
  Future<void> shoppingListSetTotal(
      {required int value, required String listId});
}

class TodoNotFoundException implements Exception {}

class TodoListNotFoundException implements Exception {}
