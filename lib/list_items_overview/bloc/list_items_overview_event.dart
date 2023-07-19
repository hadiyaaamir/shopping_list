part of 'list_items_overview_bloc.dart';

sealed class ListItemsOverviewEvent extends Equatable {
  const ListItemsOverviewEvent();

  @override
  List<Object> get props => [];
}

final class ListItemsOverviewSubscriptionRequested
    extends ListItemsOverviewEvent {
  const ListItemsOverviewSubscriptionRequested();
}

final class ListItemsOverviewCompletionToggled extends ListItemsOverviewEvent {
  const ListItemsOverviewCompletionToggled({
    required this.listItem,
    required this.isCompleted,
  });

  final ShoppingListItem listItem;
  final bool isCompleted;

  @override
  List<Object> get props => [listItem, isCompleted];
}

final class ListItemsOverviewDeleted extends ListItemsOverviewEvent {
  const ListItemsOverviewDeleted({required this.listItem});

  final ShoppingListItem listItem;

  @override
  List<Object> get props => [listItem];
}

final class ListItemsOverviewUndoDelete extends ListItemsOverviewEvent {
  const ListItemsOverviewUndoDelete();
}

final class ListItemsOverviewFilterChanged extends ListItemsOverviewEvent {
  const ListItemsOverviewFilterChanged({required this.filter});

  final ListItemsViewFilter filter;

  @override
  List<Object> get props => [filter];
}

final class ListItemsOverviewToggleAll extends ListItemsOverviewEvent {
  const ListItemsOverviewToggleAll();
}

final class ListItemsOverviewClearCompleted extends ListItemsOverviewEvent {
  const ListItemsOverviewClearCompleted();
}
