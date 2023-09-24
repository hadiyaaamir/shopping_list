import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:messaging_repository/messaging_repository.dart';
import 'package:shopping_list/parent_list/model/model.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

part 'parent_list_event.dart';
part 'parent_list_state.dart';

class ParentListBloc extends Bloc<ParentListEvent, ParentListState> {
  ParentListBloc({
    required ShoppingListRepository shoppingListRepository,
    required MessagingRepository messagingRepository,
    required this.userId,
  })  : _shoppingListRepository = shoppingListRepository,
        _messagingRepository = messagingRepository,
        super(const ParentListState()) {
    on<ParentListSubscriptionRequested>(_onSubscriptionRequested);
    on<ParentListAdded>(_onListAdded);
    on<ParentListTitleChanged>(_onTitleChanged);
    on<ParentListIconChanged>(_onIconChanged);
    on<ParentListDeleted>(_onListDeleted);
    on<ParentListUndoDelete>(_onUndoDelete);
    on<ParentListFilterChanged>(_onFilterChanged);
  }

  final ShoppingListRepository _shoppingListRepository;
  final MessagingRepository _messagingRepository;
  final String userId;

  Future<void> _onSubscriptionRequested(
    ParentListSubscriptionRequested event,
    Emitter<ParentListState> emit,
  ) async {
    emit(state.copyWith(status: () => ParentListStatus.loading));

    await _messagingRepository.setupToken(userId);

    await emit.forEach<List<ShoppingList>>(
      _shoppingListRepository.getAllLists(userId: userId),
      onData: (shoppingLists) => state.copyWith(
        status: () => ParentListStatus.success,
        shoppingLists: () => shoppingLists,
      ),
      onError: (_, __) {
        return state.copyWith(
          status: () => ParentListStatus.failure,
        );
      },
    );
  }

  Future<void> _onListAdded(
    ParentListAdded event,
    Emitter<ParentListState> emit,
  ) async {
    emit(state.copyWith(status: () => ParentListStatus.loading));

    final shoppingList = (event.shoppingList ?? ShoppingList(userId: userId))
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

  Future<void> _onFilterChanged(
    ParentListFilterChanged event,
    Emitter<ParentListState> emit,
  ) async {
    emit(state.copyWith(filter: () => event.filter));
  }
}
