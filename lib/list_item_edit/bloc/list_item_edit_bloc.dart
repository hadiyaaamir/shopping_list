import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

part 'list_item_edit_event.dart';
part 'list_item_edit_state.dart';

class ListItemEditBloc extends Bloc<ListItemEditEvent, ListItemEditState> {
  ListItemEditBloc({
    required ShoppingListRepository shoppingListRepository,
    required ShoppingListItem? listItem,
    required this.shoppingList,
    required this.userId,
  })  : _shoppingListRepository = shoppingListRepository,
        super(
          ListItemEditState(
            listItem: listItem,
            item: listItem?.item != null
                ? StringInput.dirty(value: listItem!.item)
                : const StringInput.pure(),
            quantity: NumericInput.dirty(
              value: listItem?.quantity ?? '',
              allowEmpty: true,
            ),
            quantityUnit: StringInput.dirty(
              value: listItem?.quantityUnit ?? '',
              allowEmpty: true,
            ),
            description: StringInput.dirty(
              value: listItem?.description ?? '',
              allowEmpty: true,
            ),
          ),
        ) {
    on<ListItemEditItemChanged>(_onItemChanged);
    on<ListItemEditQuantityChanged>(_onQuantityChanged);
    on<ListItemEditQuantityUnitChanged>(_onQuantityUnitChanged);
    on<ListItemEditDescriptionChanged>(_onDescriptionChanged);
    on<ListItemEditSubmitted>(_onSubmitted);
  }

  final ShoppingListRepository _shoppingListRepository;
  final ShoppingList shoppingList;
  final String userId;

  Future<void> _onItemChanged(
    ListItemEditItemChanged event,
    Emitter<ListItemEditState> emit,
  ) async {
    final item = StringInput.dirty(value: event.item);
    emit(
      state.copyWith(
        item: item,
        isValid: Formz.validate(
            [item, state.quantity, state.quantityUnit, state.description]),
      ),
    );
  }

  Future<void> _onQuantityChanged(
    ListItemEditQuantityChanged event,
    Emitter<ListItemEditState> emit,
  ) async {
    final quantity = NumericInput.dirty(
      value: event.quantity,
      allowEmpty: true,
    );
    emit(
      state.copyWith(
        quantity: quantity,
        isValid: Formz.validate(
            [state.item, quantity, state.quantityUnit, state.description]),
      ),
    );
  }

  Future<void> _onQuantityUnitChanged(
    ListItemEditQuantityUnitChanged event,
    Emitter<ListItemEditState> emit,
  ) async {
    final quantityUnit =
        StringInput.dirty(value: event.quantityUnit, allowEmpty: true);
    emit(state.copyWith(
      quantityUnit: quantityUnit,
      isValid: Formz.validate(
          [state.item, state.quantity, quantityUnit, state.description]),
    ));
  }

  Future<void> _onDescriptionChanged(
    ListItemEditDescriptionChanged event,
    Emitter<ListItemEditState> emit,
  ) async {
    final description =
        StringInput.dirty(value: event.description, allowEmpty: true);
    emit(
      state.copyWith(
        description: description,
        isValid: Formz.validate(
            [state.item, state.quantity, state.quantityUnit, description]),
      ),
    );
  }

  Future<void> _onSubmitted(
    ListItemEditSubmitted event,
    Emitter<ListItemEditState> emit,
  ) async {
    emit(state.copyWith(status: ListItemEditStatus.loading));

    bool newItem = state.listItem == null;

    final listItem = (state.listItem ??
            ShoppingListItem(
              item: '',
              listId: shoppingList.id,
              userId: userId,
            ))
        .copyWith(
      item: state.item.value,
      quantity: state.quantity.value,
      quantityUnit: state.quantityUnit.value,
      description: state.description.value,
    );

    try {
      await _shoppingListRepository.saveListItem(listItem);
      if (newItem) {
        await _shoppingListRepository.shoppingListIncrementTotal(
          listId: shoppingList.id,
        );
      }
      emit(state.copyWith(status: ListItemEditStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ListItemEditStatus.failure));
    }
  }
}
