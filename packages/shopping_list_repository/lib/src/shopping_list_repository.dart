import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/model.dart';

part 'shopping_list_repository_firebase.dart';

abstract class ShoppingListRepository {
  const ShoppingListRepository();

  Stream<List<ShoppingList>> getAllLists({required String userId});
  Stream<List<ShoppingListItem>> getShoppingList({required String listId});

  Future<void> saveShoppingList(ShoppingList shoppingList);
  Future<void> saveListItem(ShoppingListItem listItem);

  Future<void> deleteShoppingList(String id);
  Future<void> deleteListItem(String id);

  Future<int> clearCompletedItems({required String listId});
  Future<int> toggleCompleteAllItems(
      {required bool isCompleted, required String listId});

  Future<void> shoppingListIncrementCompleted(
      {int value = 1, required String listId});
  Future<void> shoppingListDecrementCompleted(
      {int value = 1, required String listId});
  Future<void> shoppingListSetCompleted(
      {required int value, required String listId});

  Future<void> shoppingListIncrementActive(
      {int value = 1, required String listId});
  Future<void> shoppingListDecrementActive(
      {int value = 1, required String listId});
  Future<void> shoppingListSetActive(
      {required int value, required String listId});
}

class TodoNotFoundException implements Exception {}

class TodoListNotFoundException implements Exception {}
