part of 'widget.dart';

class AcceptedListTile extends StatelessWidget {
  const AcceptedListTile(
      {super.key, required this.shoppingList, required this.onDismissed});

  final ShoppingList shoppingList;
  final DismissDirectionCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final status = context.read<ParentListBloc>().state.status;

    final shoppingListBloc = BlocProvider.of<ParentListBloc>(context);

    return Dismissible(
      key: Key('todoListListTile_dismissible_${shoppingList.id}'),
      onDismissed: status == ParentListStatus.loading ? null : onDismissed,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).colorScheme.error,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onError),
      ),
      child: GestureDetector(
        child: Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  children: [
                    _TileIcon(icon: shoppingList.icon),
                    _TitleRow(
                      shoppingList: shoppingList,
                      shoppingListBloc: shoppingListBloc,
                    ),
                    _SubtitleRow(todoList: shoppingList),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: _EditButton(
                  shoppingListBloc: shoppingListBloc,
                  shoppingList: shoppingList,
                ),
              ),
            ],
          ),
        ),
        onTap: () => Navigator.push(
          context,
          ShoppingListPage.route(shoppingList: shoppingList),
        ),
      ),
    );
  }
}

class _TileIcon extends StatelessWidget {
  const _TileIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
        size: 25,
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.shoppingList, required this.shoppingListBloc});

  final ShoppingList shoppingList;
  final ParentListBloc shoppingListBloc;

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
      ],
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
    final totalItems = todoList.totalItems;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            totalItems == 0
                ? 'Your list is empty'
                : '$totalItems item${totalItems > 1 ? 's' : ''}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton(
      {required this.shoppingListBloc, required this.shoppingList});

  final ParentListBloc shoppingListBloc;
  final ShoppingList shoppingList;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit, size: 15),
      onPressed: () => showDialog(
        context: context,
        builder: (context) => MultiBlocProvider(
          providers: [BlocProvider.value(value: shoppingListBloc)],
          child: AddListDialog(shoppingList: shoppingList),
        ),
      ),
    );
  }
}
