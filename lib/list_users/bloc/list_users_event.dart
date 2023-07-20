part of 'list_users_bloc.dart';

sealed class ListUsersEvent extends Equatable {
  const ListUsersEvent();

  @override
  List<Object> get props => [];
}

final class ListUsersSubscriptionRequested extends ListUsersEvent {
  const ListUsersSubscriptionRequested();
}
