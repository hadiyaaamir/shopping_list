import 'package:shopping_list_repository/shopping_list_repository.dart';

enum ShoppingListFilter { all, activeOnly, completedOnly }

extension ShoppingListFilterX on ShoppingListFilter {
  bool apply(ShoppingListItem listItem) {
    switch (this) {
      case ShoppingListFilter.all:
        return true;
      case ShoppingListFilter.activeOnly:
        return !listItem.isCompleted;
      case ShoppingListFilter.completedOnly:
        return listItem.isCompleted;
    }
  }

  String get text {
    switch (this) {
      case ShoppingListFilter.all:
        return 'All';
      case ShoppingListFilter.activeOnly:
        return 'Pending';
      case ShoppingListFilter.completedOnly:
        return 'Acquired';
    }
  }

  Iterable<ShoppingListItem> applyAll(Iterable<ShoppingListItem> items) {
    return items.where(apply);
  }
}
