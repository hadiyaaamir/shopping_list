part of 'list_users_bloc.dart';

sealed class ListUsersEvent extends Equatable {
  const ListUsersEvent();

  @override
  List<Object> get props => [];
}

final class ListUsersGetUsersDetails extends ListUsersEvent {
  const ListUsersGetUsersDetails();
}

final class ListUsersIdentifierChanged extends ListUsersEvent {
  const ListUsersIdentifierChanged({required this.identifier});

  final String identifier;

  @override
  List<Object> get props => [identifier];
}

final class ListUsersRoleChanged extends ListUsersEvent {
  const ListUsersRoleChanged({required this.userRole});

  final ListUserRoles userRole;

  @override
  List<Object> get props => [userRole];
}

final class ListUsersAdded extends ListUsersEvent {
  const ListUsersAdded({required this.onSuccess});
  final void Function() onSuccess;

  @override
  List<Object> get props => [];
}

class ListUsersEdited extends ListUsersEvent {
  const ListUsersEdited({required this.editedUser, required this.onSuccess});

  final ListUser editedUser;
  final void Function() onSuccess;

  @override
  List<Object> get props => [editedUser];
}

class ListUsersDeleted extends ListUsersEvent {
  const ListUsersDeleted({required this.userId, required this.onSuccess});

  final String userId;
  final void Function() onSuccess;

  @override
  List<Object> get props => [userId];
}
