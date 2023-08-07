import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:shopping_list/shopping_list_users/shopping_list_users.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'shopping_list_users_event.dart';
part 'shopping_list_users_state.dart';

class ShoppingListUsersBloc
    extends Bloc<ShoppingListUsersEvent, ListUsersState> {
  ShoppingListUsersBloc({
    required UserRepository userRepository,
    required ShoppingListRepository shoppingListRepository,
    required this.shoppingList,
    required this.listUsers,
  })  : _userRepository = userRepository,
        _shoppingListRepository = shoppingListRepository,
        super(const ListUsersState()) {
    on<ShoppingListUsersGetUsersDetails>(_onGetUserDetails);
    on<ShoppingListUsersIdentifierChanged>(_onUserIdentifierChanged);
    on<ShoppingListUsersRoleChanged>(_onUserRoleChanged);
    on<ShoppingListUsersAdded>(_onUserAdded);
    on<ShoppingListUsersDeleted>(_onUserDeleted);
    on<ShoppingListUsersEdited>(_onUserEdited);
  }

  final UserRepository _userRepository;
  final ShoppingListRepository _shoppingListRepository;
  final ShoppingList shoppingList;
  final List<ShoppingListUser> listUsers;

  bool isAddingOrRetrieving = true;

  Future<void> _onGetUserDetails(
    ShoppingListUsersGetUsersDetails event,
    Emitter<ListUsersState> emit,
  ) async {
    emit(state.copyWith(status: () => ListUsersStatus.loading));

    isAddingOrRetrieving = true;

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
    ShoppingListUsersIdentifierChanged event,
    Emitter<ListUsersState> emit,
  ) async {
    final identifier =
        StringInput.dirty(value: event.identifier, allowEmpty: true);
    emit(state.copyWith(userIdentifier: identifier));
  }

  Future<void> _onUserRoleChanged(
    ShoppingListUsersRoleChanged event,
    Emitter<ListUsersState> emit,
  ) async {
    emit(state.copyWith(userRole: event.userRole));
  }

  Future<void> _onUserAdded(
    ShoppingListUsersAdded event,
    Emitter<ListUsersState> emit,
  ) async {
    isAddingOrRetrieving = true;
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
        final ShoppingListUser listUser =
            ShoppingListUser(id: user.id, role: state.userRole);
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
            userRole: ShoppingListUserRoles.editor,
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

  Future<void> _onUserDeleted(
    ShoppingListUsersDeleted event,
    Emitter<ListUsersState> emit,
  ) async {
    // emit(state.copyWith(status: () => ListUsersStatus.loading));
    isAddingOrRetrieving = false;
    try {
      await _shoppingListRepository.deleteShoppingListUser(
        listId: shoppingList.id,
        userId: event.userId,
      );

      List<RoleUser> updatedUserList = state.users
          .where((roleUser) => roleUser.listUser.id != event.userId)
          .toList();

      emit(
        state.copyWith(
          status: () => ListUsersStatus.success,
          users: () => updatedUserList,
          userIdentifier: const StringInput.pure(),
          userRole: ShoppingListUserRoles.editor,
        ),
      );
      event.onSuccess();
    } catch (e) {
      emit(state.copyWith(status: () => ListUsersStatus.failure));
    }
  }

  Future<void> _onUserEdited(
    ShoppingListUsersEdited event,
    Emitter<ListUsersState> emit,
  ) async {
    // emit(state.copyWith(status: () => ListUsersStatus.loading));
    isAddingOrRetrieving = false;
    try {
      await _shoppingListRepository.editShoppingListUser(
        listId: shoppingList.id,
        editedUser: event.editedUser,
      );

      List<RoleUser> updatedUserList = state.users.map((roleUser) {
        return roleUser.listUser.id == event.editedUser.id
            ? roleUser.copyWith(listUser: event.editedUser)
            : roleUser;
      }).toList();

      emit(
        state.copyWith(
          status: () => ListUsersStatus.success,
          users: () => updatedUserList,
          userIdentifier: const StringInput.pure(),
          userRole: ShoppingListUserRoles.editor,
        ),
      );
      event.onSuccess();
    } catch (e) {
      emit(state.copyWith(status: () => ListUsersStatus.failure));
    }
  }
}
