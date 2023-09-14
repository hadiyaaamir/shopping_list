part of 'shopping_item_bloc.dart';

enum ShoppingItemStatus { initial, loading, success, failure }

extension ShoppingItemStatusX on ShoppingItemStatus {
  bool get isLoadingOrSuccess =>
      [ShoppingItemStatus.loading, ShoppingItemStatus.success].contains(this);
}

final class ShoppingItemState extends Equatable {
  const ShoppingItemState({
    this.status = ShoppingItemStatus.initial,
    this.listItem,
    this.item = const StringInput.pure(),
    this.quantity = const NumericInput.pure(allowEmpty: true),
    this.quantityUnit = const StringInput.pure(allowEmpty: true),
    this.description = const StringInput.pure(allowEmpty: true),
    this.isValid = false,
  });

  final ShoppingItemStatus status;
  final ShoppingListItem? listItem;
  final StringInput item;
  final NumericInput quantity;
  final StringInput quantityUnit;
  final StringInput description;
  final bool isValid;

  bool get isNewItem => listItem == null;

  ShoppingItemState copyWith({
    ShoppingItemStatus? status,
    ShoppingListItem? listItem,
    StringInput? item,
    NumericInput? quantity,
    StringInput? quantityUnit,
    StringInput? description,
    bool? isValid,
  }) {
    return ShoppingItemState(
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
