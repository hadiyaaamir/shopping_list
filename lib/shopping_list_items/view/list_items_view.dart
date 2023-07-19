part of 'view.dart';

class ListItemsView extends StatelessWidget {
  const ListItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    final String title =
        context.select((ShoppingListItemsBloc bloc) => bloc.shoppingList.title);

    return Scaffold(
      appBar: CustomAppBar(title: title, profileButton: true),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ShoppingListItemsBloc, ShoppingListItemsState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == ShoppingListItemsStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('Unexpected error occured')),
                  );
              }
            },
          ),
          BlocListener<ShoppingListItemsBloc, ShoppingListItemsState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedItem != current.lastDeletedItem &&
                current.lastDeletedItem != null,
            listener: (context, state) {
              final deletedItem = state.lastDeletedItem!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Deleted ${deletedItem.title}'),
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<ShoppingListItemsBloc>()
                            .add(const ShoppingListItemsUndoDelete());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: const ListItemsList(),
      ),
      floatingActionButton: const _AddTodoButton(),
    );
  }
}

class _AddTodoButton extends StatelessWidget {
  const _AddTodoButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListItemsBloc, ShoppingListItemsState>(
      builder: (context, state) {
        final ShoppingList shoppingList =
            context.select((ShoppingListItemsBloc bloc) => bloc.shoppingList);

        return FloatingActionIconButton(
            isVisible: state.listItems.isNotEmpty, onPressed: () {}
            // => Navigator.push(
            // context, TodoEditPage.route(shoppingList: shoppingList)),
            );
      },
    );
  }
}
