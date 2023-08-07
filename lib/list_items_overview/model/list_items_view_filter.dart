import 'package:shopping_list_repository/shopping_list_repository.dart';

enum ListItemsViewFilter { all, activeOnly, completedOnly }

extension ListItemsViewFilterX on ListItemsViewFilter {
  bool apply(ShoppingListItem listItem) {
    switch (this) {
      case ListItemsViewFilter.all:
        return true;
      case ListItemsViewFilter.activeOnly:
        return !listItem.isCompleted;
      case ListItemsViewFilter.completedOnly:
        return listItem.isCompleted;
    }
  }

  String get text {
    switch (this) {
      case ListItemsViewFilter.all:
        return 'All';
      case ListItemsViewFilter.activeOnly:
        return 'Pending';
      case ListItemsViewFilter.completedOnly:
        return 'Purchased';
    }
  }

  Iterable<ShoppingListItem> applyAll(Iterable<ShoppingListItem> items) {
    return items.where(apply);
  }
}
