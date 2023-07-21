part of 'list_item_edit_bloc.dart';

sealed class ListItemEditEvent extends Equatable {
  const ListItemEditEvent();

  @override
  List<Object> get props => [];
}

final class ListItemEditItemChanged extends ListItemEditEvent {
  const ListItemEditItemChanged({required this.item});

  final String item;

  @override
  List<Object> get props => [item];
}

final class ListItemEditQuantityChanged extends ListItemEditEvent {
  const ListItemEditQuantityChanged({required this.quantity});

  final String quantity;

  @override
  List<Object> get props => [quantity];
}

final class ListItemEditSubmitted extends ListItemEditEvent {
  const ListItemEditSubmitted();
}
