import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

part 'shopping_list_event.dart';
part 'shopping_list_state.dart';

class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  ShoppingListBloc({
    required ShoppingListRepository shoppingListRepository,
    required String userId,
  })  : _shoppingListRepository = shoppingListRepository,
        _userId = userId,
        super(const ShoppingListState()) {
    on<ShoppingListSubscriptionRequested>(_onSubscriptionRequested);
    on<ShoppingListAdded>(_onListAdded);
    on<ShoppingListTitleChanged>(_onTitleChanged);
    on<ShoppingListDeleted>(_onListDeleted);
    on<ShoppingListUndoDelete>(_onUndoDelete);
  }

  final ShoppingListRepository _shoppingListRepository;
  final String _userId;

  Future<void> _onSubscriptionRequested(
    ShoppingListSubscriptionRequested event,
    Emitter<ShoppingListState> emit,
  ) async {
    emit(state.copyWith(status: () => ShoppingListStatus.loading));

    await emit.forEach<List<ShoppingList>>(
      _shoppingListRepository.getAllLists(userId: _userId),
      onData: (shoppingLists) => state.copyWith(
        status: () => ShoppingListStatus.success,
        shoppingLists: () => shoppingLists,
      ),
      onError: (_, __) => state.copyWith(
        status: () => ShoppingListStatus.failure,
      ),
    );
  }

  Future<void> _onListAdded(
    ShoppingListAdded event,
    Emitter<ShoppingListState> emit,
  ) async {
    emit(state.copyWith(status: () => ShoppingListStatus.loading));

    final todoList = (event.todoList ?? ShoppingList(userId: _userId))
        .copyWith(title: state.title.value);

    try {
      await _shoppingListRepository.saveShoppingList(todoList);
      emit(state.copyWith(
          status: () => ShoppingListStatus.success,
          title: const StringInput.pure()));
    } catch (e) {
      emit(state.copyWith(
          status: () => ShoppingListStatus.failure,
          title: const StringInput.pure()));
    }
  }

  Future<void> _onTitleChanged(
    ShoppingListTitleChanged event,
    Emitter<ShoppingListState> emit,
  ) async {
    final title = StringInput.dirty(value: event.title, allowEmpty: true);
    emit(
      state.copyWith(title: title),
    );
  }

  Future<void> _onListDeleted(
    ShoppingListDeleted event,
    Emitter<ShoppingListState> emit,
  ) async {
    emit(
      state.copyWith(
        lastDeletedList: () => event.shoppingList,
        status: () => ShoppingListStatus.loading,
      ),
    );
    try {
      await _shoppingListRepository.deleteShoppingList(event.shoppingList.id);
      emit(state.copyWith(status: () => ShoppingListStatus.success));
    } catch (e) {
      emit(state.copyWith(status: () => ShoppingListStatus.failure));
    }
  }

  Future<void> _onUndoDelete(
    ShoppingListUndoDelete event,
    Emitter<ShoppingListState> emit,
  ) async {
    if (state.lastDeletedList != null) {
      final deletedTodoList = state.lastDeletedList!;
      emit(state.copyWith(lastDeletedList: () => null));
      await _shoppingListRepository.saveShoppingList(deletedTodoList);
    }
  }
}
