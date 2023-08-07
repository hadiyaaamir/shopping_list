part of 'view.dart';

class ShoppingListView extends StatelessWidget {
  const ShoppingListView({super.key});

  @override
  Widget build(BuildContext context) {
    final String title =
        context.select((ShoppingListBloc bloc) => bloc.shoppingList.title);

    final ShoppingList shoppingList =
        context.select((ShoppingListBloc bloc) => bloc.shoppingList);

    final AuthUser currentAuthUser =
        context.read<AuthenticationRepository>().currentAuthUser!;

    final bool isOwner = currentAuthUser.id == shoppingList.userId;

    final ShoppingListUser? currentListUser = isOwner
        ? ShoppingListUser(
            id: currentAuthUser.id, role: ShoppingListUserRoles.owner)
        : shoppingList.users.isNotEmpty
            ? shoppingList.users.firstWhere(
                (user) => user.id == currentAuthUser.id,
              )
            : null;

    return Scaffold(
      appBar: CustomAppBar(
        heroTag: 'title_${shoppingList.id}',
        title: title,
        actions: [
          AddUsersButton(shoppingList: shoppingList, isVisible: isOwner)
        ],
      ),
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
                            .read<ShoppingListBloc>()
                            .add(const ShoppingListUndoDelete());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: ShoppingListItemsList(currentListUser: currentListUser),
      ),
      floatingActionButton: _AddTodoButton(
          isVisible: currentListUser != null
              ? currentListUser.role != ShoppingListUserRoles.viewer
              : false),
    );
  }
}

class _AddTodoButton extends StatelessWidget {
  const _AddTodoButton({required this.isVisible});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListBloc, ShoppingListState>(
      builder: (context, state) {
        final ShoppingList shoppingList =
            context.select((ShoppingListBloc bloc) => bloc.shoppingList);

        return FloatingActionIconButton(
          isVisible: state.listItems.isNotEmpty && isVisible,
          onPressed: () => Navigator.push(
              context, ShoppingItemPage.route(shoppingList: shoppingList)),
        );
      },
    );
  }
}
