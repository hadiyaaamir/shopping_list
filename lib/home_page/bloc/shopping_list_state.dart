part of 'shopping_list_bloc.dart';

enum ShoppingListStatus { initial, loading, success, failure }

final class ShoppingListState extends Equatable {
  const ShoppingListState({
    this.status = ShoppingListStatus.initial,
    this.shoppingLists = const [],
    this.title = const StringInput.pure(allowEmpty: true),
    this.icon = Icons.shopping_cart,
    this.lastDeletedList,
  });

  final ShoppingListStatus status;
  final List<ShoppingList> shoppingLists;
  final StringInput title;
  final IconData icon;
  final ShoppingList? lastDeletedList;

  ShoppingListState copyWith({
    ShoppingListStatus Function()? status,
    List<ShoppingList> Function()? shoppingLists,
    StringInput? title,
    IconData? icon,
    ShoppingList? Function()? lastDeletedList,
  }) {
    return ShoppingListState(
      status: status != null ? status() : this.status,
      shoppingLists:
          shoppingLists != null ? shoppingLists() : this.shoppingLists,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      lastDeletedList:
          lastDeletedList != null ? lastDeletedList() : this.lastDeletedList,
    );
  }

  @override
  List<Object?> get props =>
      [status, shoppingLists, title, icon, lastDeletedList];
}
