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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Card(
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            title: _TitleRow(
                shoppingList: shoppingList, shoppingListBloc: shoppingListBloc),
            subtitle: _SubtitleRow(todoList: shoppingList),
            onTap: () => Navigator.push(
              context,
              ListItemsPage.route(shoppingList: shoppingList),
            ),
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
        Text(
          shoppingList.title,
          style: Theme.of(context).textTheme.titleMedium,
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
    final String progress = totalItems == 0
        ? ''
        : '${((todoList.completedItems.toDouble() / totalItems.toDouble()) * 100).toStringAsFixed(1)}%';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          totalItems == 0
              ? 'No items in list'
              : 'Completed: ${todoList.completedItems}, '
                  'Active: ${todoList.activeItems}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (totalItems != 0)
          Text(
            'Progress: $progress',
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          )
      ],
    );
  }
}
