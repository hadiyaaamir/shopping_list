part of 'list_users_bloc.dart';

enum ListUsersStatus { initial, loading, success, failure }

final class ListUsersState extends Equatable {
  const ListUsersState({
    this.status = ListUsersStatus.initial,
    this.users = const [],
  });

  final ListUsersStatus status;
  final List<ListUser> users;

  ListUsersState copyWith({
    ListUsersStatus Function()? status,
    List<ListUser> Function()? users,
  }) {
    return ListUsersState(
      status: status != null ? status() : this.status,
      users: users != null ? users() : this.users,
    );
  }

  @override
  List<Object> get props => [status, users];
}
