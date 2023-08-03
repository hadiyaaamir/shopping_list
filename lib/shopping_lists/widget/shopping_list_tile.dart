part of 'widget.dart';

class ShoppingListTile extends StatelessWidget {
  const ShoppingListTile(
      {super.key, required this.shoppingList, required this.onDismissed});

  final ShoppingList shoppingList;
  final DismissDirectionCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final status = context.read<ShoppingListBloc>().state.status;

    final shoppingListBloc = BlocProvider.of<ShoppingListBloc>(context);

    return Dismissible(
      key: Key('todoListListTile_dismissible_${shoppingList.id}'),
      onDismissed: status == ShoppingListStatus.loading ? null : onDismissed,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).colorScheme.error,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onError),
      ),
      child: Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          title: _TitleRow(
              shoppingList: shoppingList, shoppingListBloc: shoppingListBloc),
          subtitle: _SubtitleRow(todoList: shoppingList),
          onTap: () => Navigator.push(
            context,
            ListItemsOverviewPage.route(shoppingList: shoppingList),
          ),
        ),
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.shoppingList, required this.shoppingListBloc});

  final ShoppingList shoppingList;
  final ShoppingListBloc shoppingListBloc;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Hero(
            tag: 'title_${shoppingList.id}',
            child: Text(
              shoppingList.title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        _EditButton(shoppingListBloc: shoppingListBloc, todoList: shoppingList),
      ],
    );
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton({required this.shoppingListBloc, required this.todoList});

  final ShoppingListBloc shoppingListBloc;
  final ShoppingList todoList;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Icon(Icons.edit, size: 15),
      onTap: () => showDialog(
        context: context,
        builder: (context) => AddListDialog(
          shoppingListBloc: shoppingListBloc,
          shoppingList: todoList,
        ),
      ),
    );
  }
}

class _SubtitleRow extends StatelessWidget {
  const _SubtitleRow({
    required this.todoList,
  });

  final ShoppingList todoList;

  @override
  Widget build(BuildContext context) {
    final totalItems = todoList.activeItems + todoList.completedItems;
    // final String progress = totalItems == 0
    //     ? ''
    //     : '${((todoList.completedItems.toDouble() / totalItems.toDouble()) * 100).toStringAsFixed(1)}%';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (totalItems == 0)
            Text(
              'No items in the list',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (totalItems != 0) ...[
            Text(
              'Completed: ${todoList.completedItems}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Active: ${todoList.activeItems}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
