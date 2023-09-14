import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_list/shopping_list/model/model.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

part 'shopping_list_event.dart';
part 'shopping_list_state.dart';

class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  ShoppingListBloc({
    required ShoppingListRepository shoppingListRepository,
    required this.shoppingList,
  })  : _shoppingListRepository = shoppingListRepository,
        super(const ShoppingListState()) {
    on<ShoppingListSubscriptionRequested>(_onSubscriptionRequested);
    on<ShoppingListCompletionToggled>(_onListItemCompletionToggled);
    on<ShoppingListDeleted>(_onListItemDeleted);
    on<ShoppingListUndoDelete>(_onUndoDelete);
    on<ShoppingListFilterChanged>(_onFilterChanged);
    on<ShoppingListToggleAll>(_onToggleAll);
    on<ShoppingListClearCompleted>(_onClearCompleted);
    on<ShoppingListListUsersEdited>(_onListUsersEdited);
  }

  final ShoppingListRepository _shoppingListRepository;
  final ShoppingList shoppingList;

  Future<void> _onSubscriptionRequested(
    ShoppingListSubscriptionRequested event,
    Emitter<ShoppingListState> emit,
  ) async {
    emit(state.copyWith(status: () => ShoppingListStatus.loading));

    await emit.forEach<List<ShoppingListItem>>(
      _shoppingListRepository.getShoppingListItems(listId: shoppingList.id),
      onData: (listItems) => state.copyWith(
        status: () => ShoppingListStatus.success,
        listItems: () => listItems,
        listUsers: () => shoppingList.users,
      ),
      onError: (_, __) => state.copyWith(
        status: () => ShoppingListStatus.failure,
      ),
    );
  }

  Future<void> _onListItemCompletionToggled(
    ShoppingListCompletionToggled event,
    Emitter<ShoppingListState> emit,
  ) async {
    final newItem = event.listItem.copyWith(isCompleted: event.isCompleted);
    await _shoppingListRepository.saveListItem(newItem);
  }

  Future<void> _onListItemDeleted(
    ShoppingListDeleted event,
    Emitter<ShoppingListState> emit,
  ) async {
    emit(
      state.copyWith(
        lastDeletedItem: () => event.listItem,
        status: () => ShoppingListStatus.loading,
      ),
    );

    try {
      await _shoppingListRepository.deleteListItem(event.listItem.id);

      await _shoppingListRepository.shoppingListSetTotal(
          listId: shoppingList.id, value: state.listItems.length);

      emit(state.copyWith(status: () => ShoppingListStatus.success));
    } catch (_) {
      emit(state.copyWith(status: () => ShoppingListStatus.failure));
    }
  }

  Future<void> _onUndoDelete(
    ShoppingListUndoDelete event,
    Emitter<ShoppingListState> emit,
  ) async {
    if (state.lastDeletedItem != null) {
      final deletedItem = state.lastDeletedItem!;
      emit(state.copyWith(lastDeletedItem: () => null));
      await _shoppingListRepository.saveListItem(deletedItem);

      await _shoppingListRepository.shoppingListSetTotal(
          listId: shoppingList.id, value: state.listItems.length);
    }
  }

  Future<void> _onFilterChanged(
    ShoppingListFilterChanged event,
    Emitter<ShoppingListState> emit,
  ) async {
    emit(state.copyWith(filter: () => event.filter));
  }

  Future<void> _onToggleAll(
    ShoppingListToggleAll event,
    Emitter<ShoppingListState> emit,
  ) async {
    final areAllCompleted =
        state.listItems.every((listItem) => listItem.isCompleted);
    await _shoppingListRepository.toggleCompleteAllItems(
        isCompleted: !areAllCompleted, listId: shoppingList.id);
  }

  Future<void> _onClearCompleted(
    ShoppingListClearCompleted event,
    Emitter<ShoppingListState> emit,
  ) async {
    await _shoppingListRepository.clearCompletedItems(listId: shoppingList.id);
  }

  void _onListUsersEdited(
    ShoppingListListUsersEdited event,
    Emitter<ShoppingListState> emit,
  ) {
    emit(state.copyWith(
        listUsers: () => event.listUsers,
        status: () => ShoppingListStatus.success));
  }
}
