part of 'list_item_edit_bloc.dart';

enum ListItemEditStatus { initial, loading, success, failure }

extension ListItemEditStatusX on ListItemEditStatus {
  bool get isLoadingOrSuccess =>
      [ListItemEditStatus.loading, ListItemEditStatus.success].contains(this);
}

final class ListItemEditState extends Equatable {
  const ListItemEditState({
    this.status = ListItemEditStatus.initial,
    this.listItem,
    this.item = const StringInput.pure(),
    this.quantity = const NumericInput.pure(allowEmpty: true),
    this.quantityUnit = const StringInput.pure(allowEmpty: true),
    this.description = const StringInput.pure(allowEmpty: true),
    this.isValid = false,
  });

  final ListItemEditStatus status;
  final ShoppingListItem? listItem;
  final StringInput item;
  final NumericInput quantity;
  final StringInput quantityUnit;
  final StringInput description;
  final bool isValid;

  bool get isNewItem => listItem == null;

  ListItemEditState copyWith({
    ListItemEditStatus? status,
    ShoppingListItem? listItem,
    StringInput? item,
    NumericInput? quantity,
    StringInput? quantityUnit,
    StringInput? description,
    bool? isValid,
  }) {
    return ListItemEditState(
      status: status ?? this.status,
      listItem: listItem ?? this.listItem,
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      quantityUnit: quantityUnit ?? this.quantityUnit,
      description: description ?? this.description,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props =>
      [status, listItem, item, quantity, quantityUnit, description];
}
