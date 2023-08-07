part of 'widgets.dart';

enum ListItemsOverviewOption { toggleAll, clearCompleted }

class ListItemsOptionsMenu extends StatelessWidget {
  const ListItemsOptionsMenu({super.key, required this.currentListUser});

  final ListUser? currentListUser;

  @override
  Widget build(BuildContext context) {
    final listItems = context
        .select((ListItemsOverviewBloc bloc) => bloc.state.filteredItems);
    final hasItems = listItems.isNotEmpty;
    final completedItems = listItems.where((item) => item.isCompleted).length;

    ListUserRoles userRole =
        currentListUser != null ? currentListUser!.role : ListUserRoles.viewer;
    bool canClearAll = userRole != ListUserRoles.viewer;

    return PopupMenuButton<ListItemsOverviewOption>(
      child: const Padding(
        padding: EdgeInsets.only(left: 15),
        child: Icon(Icons.more_vert),
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: ListItemsOverviewOption.toggleAll,
            enabled: hasItems,
            child: Text(
              completedItems == listItems.length
                  ? 'Mark All as Incomplete'
                  : 'Mark All as Complete',
            ),
          ),
          PopupMenuItem(
            value: ListItemsOverviewOption.clearCompleted,
            enabled: hasItems && completedItems > 0 && canClearAll,
            child: const Text('Clear Completed'),
          ),
        ];
      },
      onSelected: (options) {
        switch (options) {
          case ListItemsOverviewOption.toggleAll:
            context
                .read<ListItemsOverviewBloc>()
                .add(const ListItemsOverviewToggleAll());
          case ListItemsOverviewOption.clearCompleted:
            context
                .read<ListItemsOverviewBloc>()
                .add(const ListItemsOverviewClearCompleted());
        }
      },
    );
  }
}
