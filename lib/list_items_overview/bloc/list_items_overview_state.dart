part of 'list_items_overview_bloc.dart';

enum ListItemsOverviewStatus { initial, loading, success, failure }

final class ListItemsOverviewState extends Equatable {
  const ListItemsOverviewState({
    this.status = ListItemsOverviewStatus.initial,
    this.listItems = const [],
    this.filter = ListItemsViewFilter.all,
    this.lastDeletedItem,
    this.listUsers = const [],
  });

  final ListItemsOverviewStatus status;
  final List<ShoppingListItem> listItems;
  final ListItemsViewFilter filter;
  final ShoppingListItem? lastDeletedItem;
  final List<ListUser> listUsers;

  ListItemsOverviewState copyWith({
    ListItemsOverviewStatus Function()? status,
    List<ShoppingListItem> Function()? listItems,
    ListItemsViewFilter Function()? filter,
    ShoppingListItem? Function()? lastDeletedItem,
    List<ListUser> Function()? listUsers,
  }) {
    return ListItemsOverviewState(
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
