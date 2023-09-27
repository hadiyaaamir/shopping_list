part of 'parent_list_bloc.dart';

enum ParentListStatus { initial, loading, success, failure }

final class ParentListState extends Equatable {
  const ParentListState({
    this.status = ParentListStatus.initial,
    this.shoppingLists = const [],
    this.filter = ParentListFilter.accepted,
    this.title = const StringInput.pure(allowEmpty: true),
    this.icon = Icons.shopping_cart,
    this.lastDeletedList,
  });

  final ParentListStatus status;
  final List<ShoppingList> shoppingLists;
  final ParentListFilter filter;
  final StringInput title;
  final IconData icon;
  final ShoppingList? lastDeletedList;

  ParentListState copyWith({
    ParentListStatus Function()? status,
    List<ShoppingList> Function()? shoppingLists,
    ParentListFilter Function()? filter,
    StringInput? title,
    IconData? icon,
    ShoppingList? Function()? lastDeletedList,
  }) {
    return ParentListState(
      status: status != null ? status() : this.status,
      shoppingLists:
          shoppingLists != null ? shoppingLists() : this.shoppingLists,
      filter: filter != null ? filter() : this.filter,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      lastDeletedList:
          lastDeletedList != null ? lastDeletedList() : this.lastDeletedList,
    );
  }

  Iterable<ShoppingList> filteredLists(String userId) =>
      filter.applyAll(shoppingLists, userId);

  @override
  List<Object?> get props =>
      [status, shoppingLists, title, icon, lastDeletedList, filter];
}
