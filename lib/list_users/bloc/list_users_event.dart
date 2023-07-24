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
