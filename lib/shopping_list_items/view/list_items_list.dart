part of 'view.dart';

class ListItemsList extends StatelessWidget {
  const ListItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListItemsBloc, ShoppingListItemsState>(
      builder: (context, state) {
        if (state.listItems.isEmpty) {
          return (state.status == ShoppingListItemsStatus.loading)
              ? const Center(child: CircularProgressIndicator())
              : (state.status != ShoppingListItemsStatus.success)
                  ? const SizedBox()
                  : const _EmptyList();
        }
        return const Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ListItemsFilterOptions(), ListItemsOptionsMenu()],
            ),
            _NonEmptyList(),
          ],
        );
      },
    );
  }
}

class _NonEmptyList extends StatelessWidget {
  const _NonEmptyList();

  @override
  Widget build(BuildContext context) {
    final Iterable<ShoppingListItem> filteredTodos = context
        .select((ShoppingListItemsBloc bloc) => bloc.state.filteredTodos);

    final ShoppingListItemsStatus status =
        context.select((ShoppingListItemsBloc bloc) => bloc.state.status);

    final ShoppingList shoppingList =
        context.select((ShoppingListItemsBloc bloc) => bloc.shoppingList);

    return Expanded(
      child: status == ShoppingListItemsStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : Scrollbar(
              radius: const Radius.circular(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      ShoppingListItem listItem =
                          filteredTodos.elementAt(index);
                      return ItemListTile(
                        listItem: listItem,
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   TodoEditPage.route(listItem: listItem, shoppingList: shoppingList),
                          // );
                        },
                        onDismissed: (_) {
                          context.read<ShoppingListItemsBloc>().add(
                              ShoppingListItemsDeleted(listItem: listItem));
                        },
                        onToggleCompleted: (isCompleted) {
                          context.read<ShoppingListItemsBloc>().add(
                                ShoppingListItemsCompletionToggled(
                                  listItem: listItem,
                                  isCompleted: isCompleted,
                                ),
                              );
                        },
                      );
                    }),
              ),
            ),
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList();

  @override
  Widget build(BuildContext context) {
    final ShoppingList shoppingList =
        context.select((ShoppingListItemsBloc bloc) => bloc.shoppingList);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Your List is Empty'),
          const SizedBox(height: 10),
          Button(
            label: 'Add To Do',
            width: 130,
            onPressed: () {
              // Navigator.push(context, TodoEditPage.route(shoppingList: shoppingList));
            },
          )
        ],
      ),
    );
  }
}
