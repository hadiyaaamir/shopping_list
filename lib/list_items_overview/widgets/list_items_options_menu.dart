part of 'widgets.dart';

enum ListItemsOverviewOption { toggleAll, clearCompleted }

class ListItemsOptionsMenu extends StatelessWidget {
  const ListItemsOptionsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final listItems = context
        .select((ListItemsOverviewBloc bloc) => bloc.state.filteredItems);
    final hasItems = listItems.isNotEmpty;
    final completedItems = listItems.where((item) => item.isCompleted).length;

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
            enabled: hasItems && completedItems > 0,
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
