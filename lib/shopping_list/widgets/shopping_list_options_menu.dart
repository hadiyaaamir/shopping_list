part of 'widgets.dart';

enum ShoppingListOption { toggleAll, clearCompleted }

class ShoppingListOptionsMenu extends StatelessWidget {
  const ShoppingListOptionsMenu({super.key, required this.currentListUser});

  final ShoppingListUser? currentListUser;

  @override
  Widget build(BuildContext context) {
    final listItems =
        context.select((ShoppingListBloc bloc) => bloc.state.filteredItems);
    final hasItems = listItems.isNotEmpty;
    final completedItems = listItems.where((item) => item.isCompleted).length;

    ShoppingListUserRoles userRole = currentListUser != null
        ? currentListUser!.role
        : ShoppingListUserRoles.viewer;
    bool canClearAll = userRole != ShoppingListUserRoles.viewer;

    return PopupMenuButton<ShoppingListOption>(
      child: const Padding(
        padding: EdgeInsets.only(left: 15),
        child: Icon(Icons.more_vert),
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: ShoppingListOption.toggleAll,
            enabled: hasItems,
            child: Text(
              completedItems == listItems.length
                  ? 'Mark All as Incomplete'
                  : 'Mark All as Complete',
            ),
          ),
          PopupMenuItem(
            value: ShoppingListOption.clearCompleted,
            enabled: hasItems && completedItems > 0 && canClearAll,
            child: const Text('Clear Completed'),
          ),
        ];
      },
      onSelected: (options) {
        switch (options) {
          case ShoppingListOption.toggleAll:
            context.read<ShoppingListBloc>().add(const ShoppingListToggleAll());
          case ShoppingListOption.clearCompleted:
            context
                .read<ShoppingListBloc>()
                .add(const ShoppingListClearCompleted());
        }
      },
    );
  }
}
