part of 'view.dart';

class ShoppingListItemsList extends StatelessWidget {
  const ShoppingListItemsList({super.key, required this.currentListUser});

  final ShoppingListUser? currentListUser;

  @override
  Widget build(BuildContext context) {
    bool isNotViewer = currentListUser != null
        ? currentListUser!.role != ShoppingListUserRoles.viewer
        : false;

    return BlocBuilder<ShoppingListBloc, ShoppingListState>(
      builder: (context, state) {
        if (state.listItems.isEmpty) {
          return (state.status == ShoppingListStatus.loading)
              ? const CustomProgressIndicator()
              : (state.status != ShoppingListStatus.success)
                  ? const SizedBox()
                  : _EmptyList(isButtonVisible: isNotViewer);
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ShoppingListFilterOptions(),
                  ShoppingListOptionsMenu(currentListUser: currentListUser),
                ],
              ),
            ),
            _NonEmptyList(currentListUser: currentListUser),
          ],
        );
      },
    );
  }
}

class _NonEmptyList extends StatelessWidget {
  const _NonEmptyList({required this.currentListUser});

  final ShoppingListUser? currentListUser;

  @override
  Widget build(BuildContext context) {
    final Iterable<ShoppingListItem> filteredTodos =
        context.select((ShoppingListBloc bloc) => bloc.state.filteredItems);

    final ShoppingListStatus status =
        context.select((ShoppingListBloc bloc) => bloc.state.status);

    final ShoppingList shoppingList =
        context.select((ShoppingListBloc bloc) => bloc.shoppingList);

    return Expanded(
      child: status == ShoppingListStatus.loading
          ? const CustomProgressIndicator()
          : AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Scrollbar(
                key: ValueKey<int>(
                    context.read<ShoppingListBloc>().state.filter.index),
                radius: const Radius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                      itemCount: filteredTodos.length,
                      itemBuilder: (context, index) {
                        ShoppingListItem listItem =
                            filteredTodos.elementAt(index);

                        return ShoppingItemTile(
                          key: Key(listItem.id),
                          listItem: listItem,
                          currentListUser: currentListUser,
                          onTap: () {
                            Navigator.push(
                              context,
                              ShoppingItemPage.route(
                                  listItem: listItem,
                                  shoppingList: shoppingList),
                            );
                          },
                          onDismissed: (_) {
                            context
                                .read<ShoppingListBloc>()
                                .add(ShoppingListDeleted(listItem: listItem));
                          },
                          onToggleCompleted: (isCompleted) {
                            context.read<ShoppingListBloc>().add(
                                  ShoppingListCompletionToggled(
                                    listItem: listItem,
                                    isCompleted: isCompleted,
                                  ),
                                );
                          },
                        );
                      }),
                ),
              ),
            ),
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList({required this.isButtonVisible});

  final bool isButtonVisible;

  @override
  Widget build(BuildContext context) {
    final ShoppingList shoppingList =
        context.select((ShoppingListBloc bloc) => bloc.shoppingList);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Your List is Empty'),
          const SizedBox(height: 10),
          Visibility(
            visible: isButtonVisible,
            child: Button(
              label: 'Add List Item',
              width: 160,
              onPressed: () {
                Navigator.push(context,
                    ShoppingItemPage.route(shoppingList: shoppingList));
              },
            ),
          )
        ],
      ),
    );
  }
}
