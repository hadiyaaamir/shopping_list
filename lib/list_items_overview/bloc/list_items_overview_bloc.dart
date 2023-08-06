import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_list/list_items_overview/model/model.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

part 'list_items_overview_event.dart';
part 'list_items_overview_state.dart';

class ListItemsOverviewBloc
    extends Bloc<ListItemsOverviewEvent, ListItemsOverviewState> {
  ListItemsOverviewBloc({
    required ShoppingListRepository shoppingListRepository,
    required this.shoppingList,
  })  : _shoppingListRepository = shoppingListRepository,
        super(const ListItemsOverviewState()) {
    on<ListItemsOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<ListItemsOverviewCompletionToggled>(_onListItemCompletionToggled);
    on<ListItemsOverviewDeleted>(_onListItemDeleted);
    on<ListItemsOverviewUndoDelete>(_onUndoDelete);
    on<ListItemsOverviewFilterChanged>(_onFilterChanged);
    on<ListItemsOverviewToggleAll>(_onToggleAll);
    on<ListItemsOverviewClearCompleted>(_onClearCompleted);
    on<ListItemsOverviewListUsersEdited>(_onListUsersEdited);
  }

  final ShoppingListRepository _shoppingListRepository;
  final ShoppingList shoppingList;

  Future<void> _onSubscriptionRequested(
    ListItemsOverviewSubscriptionRequested event,
    Emitter<ListItemsOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => ListItemsOverviewStatus.loading));

    await emit.forEach<List<ShoppingListItem>>(
      _shoppingListRepository.getShoppingList(listId: shoppingList.id),
      onData: (listItems) => state.copyWith(
        status: () => ListItemsOverviewStatus.success,
        listItems: () => listItems,
        listUsers: () => shoppingList.users,
      ),
      onError: (_, __) => state.copyWith(
        status: () => ListItemsOverviewStatus.failure,
      ),
    );
  }

  Future<void> _onListItemCompletionToggled(
    ListItemsOverviewCompletionToggled event,
    Emitter<ListItemsOverviewState> emit,
  ) async {
    final newItem = event.listItem.copyWith(isCompleted: event.isCompleted);
    await _shoppingListRepository.saveListItem(newItem);
  }

  Future<void> _onListItemDeleted(
    ListItemsOverviewDeleted event,
    Emitter<ListItemsOverviewState> emit,
  ) async {
    emit(
      state.copyWith(
        lastDeletedItem: () => event.listItem,
        status: () => ListItemsOverviewStatus.loading,
      ),
    );

    try {
      await _shoppingListRepository.deleteListItem(event.listItem.id);

      await _shoppingListRepository.shoppingListSetTotal(
          listId: shoppingList.id, value: state.listItems.length);

      emit(state.copyWith(status: () => ListItemsOverviewStatus.success));
    } catch (_) {
      emit(state.copyWith(status: () => ListItemsOverviewStatus.failure));
    }
  }

  Future<void> _onUndoDelete(
    ListItemsOverviewUndoDelete event,
    Emitter<ListItemsOverviewState> emit,
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
    ListItemsOverviewFilterChanged event,
    Emitter<ListItemsOverviewState> emit,
  ) async {
    emit(state.copyWith(filter: () => event.filter));
  }

  Future<void> _onToggleAll(
    ListItemsOverviewToggleAll event,
    Emitter<ListItemsOverviewState> emit,
  ) async {
    final areAllCompleted =
        state.listItems.every((listItem) => listItem.isCompleted);
    await _shoppingListRepository.toggleCompleteAllItems(
        isCompleted: !areAllCompleted, listId: shoppingList.id);
  }

  Future<void> _onClearCompleted(
    ListItemsOverviewClearCompleted event,
    Emitter<ListItemsOverviewState> emit,
  ) async {
    await _shoppingListRepository.clearCompletedItems(listId: shoppingList.id);
  }

  void _onListUsersEdited(
    ListItemsOverviewListUsersEdited event,
    Emitter<ListItemsOverviewState> emit,
  ) {
    emit(state.copyWith(
        listUsers: () => event.listUsers,
        status: () => ListItemsOverviewStatus.success));
  }
}
