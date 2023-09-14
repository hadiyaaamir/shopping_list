part of 'shopping_list_bloc.dart';

enum ShoppingListStatus { initial, loading, success, failure }

final class ShoppingListState extends Equatable {
  const ShoppingListState({
    this.status = ShoppingListStatus.initial,
    this.listItems = const [],
    this.filter = ShoppingListFilter.all,
    this.lastDeletedItem,
    this.listUsers = const [],
  });

  final ShoppingListStatus status;
  final List<ShoppingListItem> listItems;
  final ShoppingListFilter filter;
  final ShoppingListItem? lastDeletedItem;
  final List<ShoppingListUser> listUsers;

  ShoppingListState copyWith({
    ShoppingListStatus Function()? status,
    List<ShoppingListItem> Function()? listItems,
    ShoppingListFilter Function()? filter,
    ShoppingListItem? Function()? lastDeletedItem,
    List<ShoppingListUser> Function()? listUsers,
  }) {
    return ShoppingListState(
      status: status != null ? status() : this.status,
      listItems: listItems != null ? listItems() : this.listItems,
      filter: filter != null ? filter() : this.filter,
      lastDeletedItem:
          lastDeletedItem != null ? lastDeletedItem() : this.lastDeletedItem,
      listUsers: listUsers != null ? listUsers() : this.listUsers,
    );
  }

  Iterable<ShoppingListItem> get filteredItems => filter.applyAll(listItems);

  @override
  List<Object?> get props =>
      [status, listItems, lastDeletedItem, filter, listUsers];
}
