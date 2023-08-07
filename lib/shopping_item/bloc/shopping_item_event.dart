part of 'shopping_item_bloc.dart';

sealed class ShoppingItemEvent extends Equatable {
  const ShoppingItemEvent();

  @override
  List<Object> get props => [];
}

final class ShoppingItemChanged extends ShoppingItemEvent {
  const ShoppingItemChanged({required this.item});

  final String item;

  @override
  List<Object> get props => [item];
}

final class ShoppingItemQuantityChanged extends ShoppingItemEvent {
  const ShoppingItemQuantityChanged({required this.quantity});

  final String quantity;

  @override
  List<Object> get props => [quantity];
}

final class ShoppingItemQuantityUnitChanged extends ShoppingItemEvent {
  const ShoppingItemQuantityUnitChanged({required this.quantityUnit});

  final String quantityUnit;

  @override
  List<Object> get props => [quantityUnit];
}

final class ShoppingItemDescriptionChanged extends ShoppingItemEvent {
  const ShoppingItemDescriptionChanged({required this.description});

  final String description;

  @override
  List<Object> get props => [description];
}

final class ShoppingItemSubmitted extends ShoppingItemEvent {
  const ShoppingItemSubmitted();
}
