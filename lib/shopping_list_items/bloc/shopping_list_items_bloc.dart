import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_list/shopping_list_items/model/model.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

part 'shopping_list_items_event.dart';
part 'shopping_list_items_state.dart';

class ShoppingListItemsBloc
    extends Bloc<ShoppingListItemsEvent, ShoppingListItemsState> {
  ShoppingListItemsBloc({
    required ShoppingListRepository shoppingListRepository,
    required this.shoppingList,
  })  : _shoppingListRepository = shoppingListRepository,
        super(const ShoppingListItemsState()) {
    on<ShoppingListItemsSubscriptionRequested>(_onSubscriptionRequested);
    on<ShoppingListItemsCompletionToggled>(_onListItemCompletionToggled);
    on<ShoppingListItemsDeleted>(_onListItemDeleted);
    on<ShoppingListItemsUndoDelete>(_onUndoDelete);
    on<ShoppingListItemsFilterChanged>(_onFilterChanged);
    on<ShoppingListItemsToggleAll>(_onToggleAll);
    on<ShoppingListItemsClearCompleted>(_onClearCompleted);
  }

  final ShoppingListRepository _shoppingListRepository;
  final ShoppingList shoppingList;

  Future<void> _onSubscriptionRequested(
    ShoppingListItemsSubscriptionRequested event,
    Emitter<ShoppingListItemsState> emit,
  ) async {
    emit(state.copyWith(status: () => ShoppingListItemsStatus.loading));

    await emit.forEach<List<ShoppingListItem>>(
      _shoppingListRepository.getShoppingList(listId: shoppingList.id),
      onData: (items) => state.copyWith(
        status: () => ShoppingListItemsStatus.success,
        listItems: () => items,
      ),
      onError: (_, __) => state.copyWith(
        status: () => ShoppingListItemsStatus.failure,
      ),
    );
  }

  Future<void> _onListItemCompletionToggled(
    ShoppingListItemsCompletionToggled event,
    Emitter<ShoppingListItemsState> emit,
  ) async {
    final newListItem = event.listItem.copyWith(isCompleted: event.isCompleted);
    await _shoppingListRepository.saveListItem(newListItem);

    if (event.isCompleted) {
      await _shoppingListRepository.shoppingListIncrementCompleted(
          listId: shoppingList.id);
      await _shoppingListRepository.shoppingListDecrementActive(
          listId: shoppingList.id);
    } else {
      await _shoppingListRepository.shoppingListDecrementCompleted(
          listId: shoppingList.id);
      await _shoppingListRepository.shoppingListIncrementActive(
          listId: shoppingList.id);
    }
  }

  Future<void> _onListItemDeleted(
    ShoppingListItemsDeleted event,
    Emitter<ShoppingListItemsState> emit,
  ) async {
    emit(
      state.copyWith(
        lastDeletedItem: () => event.listItem,
        status: () => ShoppingListItemsStatus.loading,
      ),
    );

    try {
      await _shoppingListRepository.deleteListItem(event.listItem.id);

      event.listItem.isCompleted
          ? await _shoppingListRepository.shoppingListDecrementCompleted(
              listId: shoppingList.id)
          : await _shoppingListRepository.shoppingListDecrementActive(
              listId: shoppingList.id);

      emit(state.copyWith(status: () => ShoppingListItemsStatus.success));
    } catch (_) {
      emit(state.copyWith(status: () => ShoppingListItemsStatus.failure));
    }
  }

  Future<void> _onUndoDelete(
    ShoppingListItemsUndoDelete event,
    Emitter<ShoppingListItemsState> emit,
  ) async {
    if (state.lastDeletedItem != null) {
      final deletedListItem = state.lastDeletedItem!;
      emit(state.copyWith(lastDeletedItem: () => null));
      await _shoppingListRepository.saveListItem(deletedListItem);

      deletedListItem.isCompleted
          ? await _shoppingListRepository.shoppingListIncrementCompleted(
              listId: shoppingList.id)
          : await _shoppingListRepository.shoppingListIncrementActive(
              listId: shoppingList.id);
    }
  }

  Future<void> _onFilterChanged(
    ShoppingListItemsFilterChanged event,
    Emitter<ShoppingListItemsState> emit,
  ) async {
    emit(state.copyWith(filter: () => event.filter));
  }

  Future<void> _onToggleAll(
    ShoppingListItemsToggleAll event,
    Emitter<ShoppingListItemsState> emit,
  ) async {
    final areAllCompleted =
        state.listItems.every((listItem) => listItem.isCompleted);
    int completed = await _shoppingListRepository.toggleCompleteAllItems(
        isCompleted: !areAllCompleted, listId: shoppingList.id);

    if (areAllCompleted) {
      await _shoppingListRepository.shoppingListSetCompleted(
          value: 0, listId: shoppingList.id);
      await _shoppingListRepository.shoppingListSetActive(
          value: completed, listId: shoppingList.id);
    } else {
      await _shoppingListRepository.shoppingListSetCompleted(
          value: completed, listId: shoppingList.id);
      await _shoppingListRepository.shoppingListSetActive(
          value: 0, listId: shoppingList.id);
    }
  }

  Future<void> _onClearCompleted(
    ShoppingListItemsClearCompleted event,
    Emitter<ShoppingListItemsState> emit,
  ) async {
    int cleared = await _shoppingListRepository.clearCompletedItems(
        listId: shoppingList.id);
    await _shoppingListRepository.shoppingListDecrementCompleted(
        listId: shoppingList.id, value: cleared);
  }
}
