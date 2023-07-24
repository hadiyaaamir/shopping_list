import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:shopping_list/list_users/list_users.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'list_users_event.dart';
part 'list_users_state.dart';

class ListUsersBloc extends Bloc<ListUsersEvent, ListUsersState> {
  ListUsersBloc({
    required UserRepository userRepository,
    required ShoppingListRepository shoppingListRepository,
    required this.shoppingList,
    required this.listUsers,
  })  : _userRepository = userRepository,
        _shoppingListRepository = shoppingListRepository,
        super(const ListUsersState()) {
    on<ListUsersGetUsersDetails>(_onGetUserDetails);
    on<ListUsersIdentifierChanged>(_onUserIdentifierChanged);
    on<ListUsersRoleChanged>(_onUserRoleChanged);
    on<ListUsersAdded>(_onUserAdded);
  }

  final UserRepository _userRepository;
  final ShoppingListRepository _shoppingListRepository;
  final ShoppingList shoppingList;
  final List<ListUser> listUsers;

  Future<void> _onGetUserDetails(
    ListUsersGetUsersDetails event,
    Emitter<ListUsersState> emit,
  ) async {
    emit(state.copyWith(status: () => ListUsersStatus.loading));

    try {
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

  Future<void> _onUserIdentifierChanged(
    ListUsersIdentifierChanged event,
    Emitter<ListUsersState> emit,
  ) async {
    final identifier =
        StringInput.dirty(value: event.identifier, allowEmpty: true);
    emit(state.copyWith(userIdentifier: identifier));
  }

  Future<void> _onUserRoleChanged(
    ListUsersRoleChanged event,
    Emitter<ListUsersState> emit,
  ) async {
    emit(state.copyWith(userRole: event.userRole));
  }

  Future<void> _onUserAdded(
    ListUsersAdded event,
    Emitter<ListUsersState> emit,
  ) async {
    emit(state.copyWith(status: () => ListUsersStatus.loading));

    try {
      final String listId = shoppingList.id;

      final User? user = await _userRepository.getUserByIdentifier(
          identifier: state.userIdentifier.value);

      if (user == null) {
        emit(
          state.copyWith(
            status: () => ListUsersStatus.failure,
            errorMessage: 'User does not exist',
          ),
        );
      } else {
        final ListUser listUser = ListUser(id: user.id, role: state.userRole);
        final RoleUser roleUser = RoleUser(user: user, listUser: listUser);

        await _shoppingListRepository.addUserToList(
          listId: listId,
          user: listUser,
        );

        emit(
          state.copyWith(
            status: () => ListUsersStatus.success,
            users: () => [...state.users, roleUser],
            userIdentifier: const StringInput.pure(),
            userRole: ListUserRoles.editor,
          ),
        );

        event.onSuccess();
      }
    } on UserAlreadyExistsException catch (e) {
      emit(
        state.copyWith(
          status: () => ListUsersStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: () => ListUsersStatus.failure));
    }
  }
}
