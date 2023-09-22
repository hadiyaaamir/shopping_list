part of 'model.dart';

enum ParentListFilter { all, accepted, invitations }

extension ParentListFilterX on ParentListFilter {
  bool apply(ShoppingList shoppingList, String userId) {
    switch (this) {
      case ParentListFilter.all:
        return true;
      case ParentListFilter.accepted:
        return shoppingList.users.any(
          (user) => user.id == userId && user.acceptedInvitation,
        );
      case ParentListFilter.invitations:
        return shoppingList.users.any(
          (user) => user.id == userId && !user.acceptedInvitation,
        );
    }
  }

  String get text {
    switch (this) {
      case ParentListFilter.all:
        return 'All';
      case ParentListFilter.accepted:
        return 'My Lists';
      case ParentListFilter.invitations:
        return 'Invitations';
    }
  }

  Iterable<ShoppingList> applyAll(
    Iterable<ShoppingList> shoppingList,
    String userId,
  ) {
    return shoppingList.where((list) => apply(list, userId));
  }
}
