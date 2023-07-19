part of 'shopping_list_items_bloc.dart';

sealed class ShoppingListItemsEvent extends Equatable {
  const ShoppingListItemsEvent();

  @override
  List<Object> get props => [];
}

final class ShoppingListItemsSubscriptionRequested
    extends ShoppingListItemsEvent {
  const ShoppingListItemsSubscriptionRequested();
}

final class ShoppingListItemsCompletionToggled extends ShoppingListItemsEvent {
  const ShoppingListItemsCompletionToggled({
    required this.listItem,
    required this.isCompleted,
  });

  final ShoppingListItem listItem;
  final bool isCompleted;

  @override
  List<Object> get props => [listItem, isCompleted];
}

final class ShoppingListItemsDeleted extends ShoppingListItemsEvent {
  const ShoppingListItemsDeleted({required this.listItem});

  final ShoppingListItem listItem;

  @override
  List<Object> get props => [listItem];
}

final class ShoppingListItemsUndoDelete extends ShoppingListItemsEvent {
  const ShoppingListItemsUndoDelete();
}

final class ShoppingListItemsFilterChanged extends ShoppingListItemsEvent {
  const ShoppingListItemsFilterChanged({required this.filter});

  final ShoppingListItemsFilter filter;

  @override
  List<Object> get props => [filter];
}

final class ShoppingListItemsToggleAll extends ShoppingListItemsEvent {
  const ShoppingListItemsToggleAll();
}

final class ShoppingListItemsClearCompleted extends ShoppingListItemsEvent {
  const ShoppingListItemsClearCompleted();
}
