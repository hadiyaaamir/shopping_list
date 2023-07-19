part of 'view.dart';

class ListItemsOverviewView extends StatelessWidget {
  const ListItemsOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final String title =
        context.select((ListItemsOverviewBloc bloc) => bloc.shoppingList.title);

    return Scaffold(
      appBar: CustomAppBar(title: title, profileButton: true),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ListItemsOverviewBloc, ListItemsOverviewState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == ListItemsOverviewStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('Unexpected error occured')),
                  );
              }
            },
          ),
          BlocListener<ListItemsOverviewBloc, ListItemsOverviewState>(
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
                    content: Text('Deleted ${deletedItem.item}'),
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<ListItemsOverviewBloc>()
                            .add(const ListItemsOverviewUndoDelete());
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
    return BlocBuilder<ListItemsOverviewBloc, ListItemsOverviewState>(
      builder: (context, state) {
        final ShoppingList shoppingList =
            context.select((ListItemsOverviewBloc bloc) => bloc.shoppingList);

        return FloatingActionIconButton(
            isVisible: state.listItems.isNotEmpty,
            onPressed: () {} //TODO: add navigation
            // Navigator.push(context, TodoEditPage.route(shoppingList: shoppingList)),
            );
      },
    );
  }
}