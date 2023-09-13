part of 'view.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Shopping Lists', profileButton: true),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ShoppingListBloc, ShoppingListState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == ShoppingListStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('Unexpected error occured')),
                  );
              }
            },
          ),
          BlocListener<ShoppingListBloc, ShoppingListState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedList != current.lastDeletedList &&
                current.lastDeletedList != null,
            listener: (context, state) {
              final deletedTodo = state.lastDeletedList!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Deleted ${deletedTodo.title}'),
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<ShoppingListBloc>()
                            .add(const ShoppingListUndoDelete());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: const ShoppingListsList(),
      ),
      floatingActionButton: const _AddShoppingListButton(),
    );
  }
}

class _AddShoppingListButton extends StatelessWidget {
  const _AddShoppingListButton();

  @override
  Widget build(BuildContext context) {
    final shoppingListBloc = BlocProvider.of<ShoppingListBloc>(context);

    return BlocBuilder<ShoppingListBloc, ShoppingListState>(
      builder: (context, state) {
        return FloatingActionIconButton(
          isVisible: state.shoppingLists.isNotEmpty,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: shoppingListBloc),
              ],
              child: const AddListDialog(),
            ),
          ),
        );
      },
    );
  }
}