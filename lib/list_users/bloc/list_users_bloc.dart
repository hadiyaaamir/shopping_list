import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

part 'list_users_event.dart';
part 'list_users_state.dart';

class ListUsersBloc extends Bloc<ListUsersEvent, ListUsersState> {
  ListUsersBloc({
    required ShoppingListRepository shoppingListRepository,
    required this.shoppingList,
  })  : _shoppingListRepository = shoppingListRepository,
        super(const ListUsersState()) {
    on<ListUsersSubscriptionRequested>(_onSubscriptionRequested);
  }

  final ShoppingListRepository _shoppingListRepository;
  final ShoppingList shoppingList;

  FutureOr<void> _onSubscriptionRequested(
    ListUsersSubscriptionRequested event,
    Emitter<ListUsersState> emit,
  ) async {
    emit(state.copyWith(status: () => ListUsersStatus.loading));

    await emit.forEach<List<ListUser>>(
        _shoppingListRepository.getUsersForList(listId: shoppingList.id),
        onData: (users) => state.copyWith(
              status: () => ListUsersStatus.success,
              users: () => users,
            ),
        onError: (e, __) {
          print(e);
          return state.copyWith(
            status: () => ListUsersStatus.failure,
          );
        });
  }
}
