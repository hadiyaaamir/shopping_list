import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

part 'parent_list_event.dart';
part 'parent_list_state.dart';

class ParentListBloc extends Bloc<ParentListEvent, ParentListState> {
  ParentListBloc({
    required ShoppingListRepository shoppingListRepository,
    required String userId,
  })  : _shoppingListRepository = shoppingListRepository,
        _userId = userId,
        super(const ParentListState()) {
    on<ParentListSubscriptionRequested>(_onSubscriptionRequested);
    on<ParentListAdded>(_onListAdded);
    on<ParentListTitleChanged>(_onTitleChanged);
    on<ParentListIconChanged>(_onIconChanged);
    on<ParentListDeleted>(_onListDeleted);
    on<ParentListUndoDelete>(_onUndoDelete);
  }

  final ShoppingListRepository _shoppingListRepository;
  final String _userId;

  Future<void> _onSubscriptionRequested(
    ParentListSubscriptionRequested event,
    Emitter<ParentListState> emit,
  ) async {
    emit(state.copyWith(status: () => ParentListStatus.loading));

    await emit.forEach<List<ShoppingList>>(
      _shoppingListRepository.getAllLists(userId: _userId),
      onData: (shoppingLists) => state.copyWith(
        status: () => ParentListStatus.success,
        shoppingLists: () => shoppingLists,
      ),
      onError: (_, __) => state.copyWith(
        status: () => ParentListStatus.failure,
      ),
    );
  }

  Future<void> _onListAdded(
    ParentListAdded event,
    Emitter<ParentListState> emit,
  ) async {
    emit(state.copyWith(status: () => ParentListStatus.loading));

    final shoppingList = (event.shoppingList ?? ShoppingList(userId: _userId))
        .copyWith(title: state.title.value, icon: state.icon);

    try {
      await _shoppingListRepository.saveShoppingList(shoppingList);
      emit(state.copyWith(
        status: () => ParentListStatus.success,
        title: const StringInput.pure(),
        icon: Icons.shopping_cart,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: () => ParentListStatus.failure,
        title: const StringInput.pure(),
        icon: Icons.shopping_cart,
      ));
    }
  }

  Future<void> _onTitleChanged(
    ParentListTitleChanged event,
    Emitter<ParentListState> emit,
  ) async {
    final title = StringInput.dirty(value: event.title, allowEmpty: true);
    emit(
      state.copyWith(title: title),
    );
  }

  Future<void> _onIconChanged(
    ParentListIconChanged event,
    Emitter<ParentListState> emit,
  ) async {
    emit(state.copyWith(icon: event.icon));
  }

  Future<void> _onListDeleted(
    ParentListDeleted event,
    Emitter<ParentListState> emit,
  ) async {
    emit(
      state.copyWith(
        lastDeletedList: () => event.shoppingList,
        status: () => ParentListStatus.loading,
      ),
    );
    try {
      await _shoppingListRepository.deleteShoppingList(event.shoppingList.id);
      emit(state.copyWith(status: () => ParentListStatus.success));
    } catch (e) {
      emit(state.copyWith(status: () => ParentListStatus.failure));
    }
  }

  Future<void> _onUndoDelete(
    ParentListUndoDelete event,
    Emitter<ParentListState> emit,
  ) async {
    if (state.lastDeletedList != null) {
      final deletedTodoList = state.lastDeletedList!;
      emit(state.copyWith(lastDeletedList: () => null));
      await _shoppingListRepository.saveShoppingList(deletedTodoList);
    }
  }
}
