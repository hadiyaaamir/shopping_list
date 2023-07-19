part of 'widgets.dart';

enum ListItemsOptions { toggleAll, clearCompleted }

class ListItemsOptionsMenu extends StatelessWidget {
  const ListItemsOptionsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final listItems = context
        .select((ShoppingListItemsBloc bloc) => bloc.state.filteredTodos);
    final hasItems = listItems.isNotEmpty;
    final completedItems = listItems.where((item) => item.isCompleted).length;

    return PopupMenuButton<ListItemsOptions>(
      child: const Padding(
        padding: EdgeInsets.only(left: 15),
        child: Icon(Icons.more_vert),
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: ListItemsOptions.toggleAll,
            enabled: hasItems,
            child: Text(
              completedItems == listItems.length
                  ? 'Mark All as Incomplete'
                  : 'Mark All as Complete',
            ),
          ),
          PopupMenuItem(
            value: ListItemsOptions.clearCompleted,
            enabled: hasItems && completedItems > 0,
            child: const Text('Clear Completed'),
          ),
        ];
      },
      onSelected: (options) {
        switch (options) {
          case ListItemsOptions.toggleAll:
            context
                .read<ShoppingListItemsBloc>()
                .add(const ShoppingListItemsToggleAll());
          case ListItemsOptions.clearCompleted:
            context
                .read<ShoppingListItemsBloc>()
                .add(const ShoppingListItemsClearCompleted());
        }
      },
    );
  }
}
