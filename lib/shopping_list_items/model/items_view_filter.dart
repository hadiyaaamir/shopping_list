import 'package:shopping_list_repository/shopping_list_repository.dart';

enum ShoppingListItemsFilter { all, activeOnly, completedOnly }

extension ShoppingListItemsFilterX on ShoppingListItemsFilter {
  bool apply(ShoppingListItem item) {
    switch (this) {
      case ShoppingListItemsFilter.all:
        return true;
      case ShoppingListItemsFilter.activeOnly:
        return !item.isCompleted;
      case ShoppingListItemsFilter.completedOnly:
        return item.isCompleted;
    }
  }

  String get text {
    switch (this) {
      case ShoppingListItemsFilter.all:
        return 'All';
      case ShoppingListItemsFilter.activeOnly:
        return 'Active';
      case ShoppingListItemsFilter.completedOnly:
        return 'Completed';
    }
  }

  Iterable<ShoppingListItem> applyAll(Iterable<ShoppingListItem> items) {
    return items.where(apply);
  }
}
