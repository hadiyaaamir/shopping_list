part of 'shopping_list_bloc.dart';

sealed class ShoppingListEvent extends Equatable {
  const ShoppingListEvent();

  @override
  List<Object> get props => [];
}

final class ShoppingListSubscriptionRequested extends ShoppingListEvent {
  const ShoppingListSubscriptionRequested();
}

final class ShoppingListTitleChanged extends ShoppingListEvent {
  const ShoppingListTitleChanged({required this.title});

  final String title;

  @override
  List<Object> get props => [title];
}

final class ShoppingListIconChanged extends ShoppingListEvent {
  const ShoppingListIconChanged({required this.icon});

  final IconData icon;

  @override
  List<Object> get props => [icon];
}

final class ShoppingListAdded extends ShoppingListEvent {
  const ShoppingListAdded({this.shoppingList});

  final ShoppingList? shoppingList;
}

final class ShoppingListDeleted extends ShoppingListEvent {
  const ShoppingListDeleted({required this.shoppingList});

  final ShoppingList shoppingList;

  @override
  List<Object> get props => [shoppingList];
}

final class ShoppingListUndoDelete extends ShoppingListEvent {
  const ShoppingListUndoDelete();
}
