part of 'list_users_bloc.dart';

enum ListUsersStatus { initial, loading, success, failure }

final class ListUsersState extends Equatable {
  const ListUsersState({
    this.status = ListUsersStatus.initial,
    this.users = const [],
    this.userIdentifier = const StringInput.pure(),
    this.userRole = ListUserRoles.editor,
    this.errorMessage,
  });

  final ListUsersStatus status;
  final List<RoleUser> users;

  final StringInput userIdentifier;
  final ListUserRoles userRole;
  final String? errorMessage;

  ListUsersState copyWith({
    ListUsersStatus Function()? status,
    List<RoleUser> Function()? users,
    StringInput? userIdentifier,
    ListUserRoles? userRole,
    String? errorMessage,
  }) {
    return ListUsersState(
      status: status != null ? status() : this.status,
      users: users != null ? users() : this.users,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      userRole: userRole ?? this.userRole,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, users, userIdentifier, userRole, errorMessage];
}