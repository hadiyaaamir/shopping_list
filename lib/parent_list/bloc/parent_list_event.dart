part of 'parent_list_bloc.dart';

sealed class ParentListEvent extends Equatable {
  const ParentListEvent();

  @override
  List<Object> get props => [];
}

final class ParentListSubscriptionRequested extends ParentListEvent {
  const ParentListSubscriptionRequested();
}

final class ParentListTitleChanged extends ParentListEvent {
  const ParentListTitleChanged({required this.title});

  final String title;

  @override
  List<Object> get props => [title];
}

final class ParentListIconChanged extends ParentListEvent {
  const ParentListIconChanged({required this.icon});

  final IconData icon;

  @override
  List<Object> get props => [icon];
}

final class ParentListAdded extends ParentListEvent {
  const ParentListAdded({this.shoppingList});

  final ShoppingList? shoppingList;
}

final class ParentListDeleted extends ParentListEvent {
  const ParentListDeleted({required this.shoppingList});

  final ShoppingList shoppingList;

  @override
  List<Object> get props => [shoppingList];
}

final class ParentListUndoDelete extends ParentListEvent {
  const ParentListUndoDelete();
}
