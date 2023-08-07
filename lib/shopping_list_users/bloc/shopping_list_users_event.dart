part of 'shopping_list_users_bloc.dart';

sealed class ShoppingListUsersEvent extends Equatable {
  const ShoppingListUsersEvent();

  @override
  List<Object> get props => [];
}

final class ShoppingListUsersGetUsersDetails extends ShoppingListUsersEvent {
  const ShoppingListUsersGetUsersDetails();
}

final class ShoppingListUsersIdentifierChanged extends ShoppingListUsersEvent {
  const ShoppingListUsersIdentifierChanged({required this.identifier});

  final String identifier;

  @override
  List<Object> get props => [identifier];
}

final class ShoppingListUsersRoleChanged extends ShoppingListUsersEvent {
  const ShoppingListUsersRoleChanged({required this.userRole});

  final ShoppingListUserRoles userRole;

  @override
  List<Object> get props => [userRole];
}

final class ShoppingListUsersAdded extends ShoppingListUsersEvent {
  const ShoppingListUsersAdded({required this.onSuccess});
  final void Function() onSuccess;

  @override
  List<Object> get props => [];
}

class ShoppingListUsersEdited extends ShoppingListUsersEvent {
  const ShoppingListUsersEdited(
      {required this.editedUser, required this.onSuccess});

  final ShoppingListUser editedUser;
  final void Function() onSuccess;

  @override
  List<Object> get props => [editedUser];
}

class ShoppingListUsersDeleted extends ShoppingListUsersEvent {
  const ShoppingListUsersDeleted(
      {required this.userId, required this.onSuccess});

  final String userId;
  final void Function() onSuccess;

  @override
  List<Object> get props => [userId];
}
