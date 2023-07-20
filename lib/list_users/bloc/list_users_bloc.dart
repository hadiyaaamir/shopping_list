import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_list/list_users/list_users.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'list_users_event.dart';
part 'list_users_state.dart';

class ListUsersBloc extends Bloc<ListUsersEvent, ListUsersState> {
  ListUsersBloc({
    required UserRepository userRepository,
    required this.shoppingList,
  })  : _userRepository = userRepository,
        super(const ListUsersState()) {
    on<ListUsersGetUsersDetails>(_onGetUserDetails);
  }

  final UserRepository _userRepository;
  final ShoppingList shoppingList;

  FutureOr<void> _onGetUserDetails(
    ListUsersGetUsersDetails event,
    Emitter<ListUsersState> emit,
  ) async {
    emit(state.copyWith(status: () => ListUsersStatus.loading));

    try {
      final List<ListUser> listUsers = shoppingList.users;

      final List<String> userIds = listUsers.map((user) => user.id).toList();
      final List<User> users = await _userRepository.getUsersById(userIds);

      final List<RoleUser> roleUsers = listUsers.map((listUser) {
        final user = users.firstWhere((user) => user.id == listUser.id);
        return RoleUser(user: user, listUser: listUser);
      }).toList();

      emit(
        state.copyWith(
          status: () => ListUsersStatus.success,
          users: () => roleUsers,
        ),
      );
    } catch (error) {
      emit(state.copyWith(status: () => ListUsersStatus.failure));
    }
  }
}
