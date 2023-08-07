part of 'shopping_list_bloc.dart';

sealed class ShoppingListEvent extends Equatable {
  const ShoppingListEvent();

  @override
  List<Object> get props => [];
}

final class ShoppingListSubscriptionRequested extends ShoppingListEvent {
  const ShoppingListSubscriptionRequested();
}

final class ShoppingListCompletionToggled extends ShoppingListEvent {
  const ShoppingListCompletionToggled({
    required this.listItem,
    required this.isCompleted,
  });

  final ShoppingListItem listItem;
  final bool isCompleted;

  @override
  List<Object> get props => [listItem, isCompleted];
}

final class ShoppingListDeleted extends ShoppingListEvent {
  const ShoppingListDeleted({required this.listItem});

  final ShoppingListItem listItem;

  @override
  List<Object> get props => [listItem];
}

final class ShoppingListUndoDelete extends ShoppingListEvent {
  const ShoppingListUndoDelete();
}

final class ShoppingListFilterChanged extends ShoppingListEvent {
  const ShoppingListFilterChanged({required this.filter});

  final ShoppingListFilter filter;

  @override
  List<Object> get props => [filter];
}

final class ShoppingListToggleAll extends ShoppingListEvent {
  const ShoppingListToggleAll();
}

final class ShoppingListClearCompleted extends ShoppingListEvent {
  const ShoppingListClearCompleted();
}

final class ShoppingListListUsersEdited extends ShoppingListEvent {
  const ShoppingListListUsersEdited({required this.listUsers});

  final List<ShoppingListUser> listUsers;

  @override
  List<Object> get props => [listUsers];
}
