part of 'shopping_list_items_bloc.dart';

enum ShoppingListItemsStatus { initial, loading, success, failure }

final class ShoppingListItemsState extends Equatable {
  const ShoppingListItemsState({
    this.status = ShoppingListItemsStatus.initial,
    this.listItems = const [],
    this.filter = ShoppingListItemsFilter.all,
    this.lastDeletedItem,
  });

  final ShoppingListItemsStatus status;
  final List<ShoppingListItem> listItems;
  final ShoppingListItemsFilter filter;
  final ShoppingListItem? lastDeletedItem;

  ShoppingListItemsState copyWith({
    ShoppingListItemsStatus Function()? status,
    List<ShoppingListItem> Function()? listItems,
    ShoppingListItemsFilter Function()? filter,
    ShoppingListItem? Function()? lastDeletedItem,
  }) {
    return ShoppingListItemsState(
      status: status != null ? status() : this.status,
      listItems: listItems != null ? listItems() : this.listItems,
      filter: filter != null ? filter() : this.filter,
      lastDeletedItem:
          lastDeletedItem != null ? lastDeletedItem() : this.lastDeletedItem,
    );
  }

  Iterable<ShoppingListItem> get filteredTodos => filter.applyAll(listItems);

  @override
  List<Object?> get props => [status, listItems, lastDeletedItem, filter];
}
