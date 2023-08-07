part of 'view.dart';

class ListItemsList extends StatelessWidget {
  const ListItemsList({super.key, required this.currentListUser});

  final ListUser? currentListUser;

  @override
  Widget build(BuildContext context) {
    bool isNotViewer = currentListUser != null
        ? currentListUser!.role != ListUserRoles.viewer
        : false;

    return BlocBuilder<ListItemsOverviewBloc, ListItemsOverviewState>(
      builder: (context, state) {
        if (state.listItems.isEmpty) {
          return (state.status == ListItemsOverviewStatus.loading)
              ? const CustomProgressIndicator()
              : (state.status != ListItemsOverviewStatus.success)
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
                  const ListItemsFilterOptions(),
                  ListItemsOptionsMenu(currentListUser: currentListUser),
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

  final ListUser? currentListUser;

  @override
  Widget build(BuildContext context) {
    final Iterable<ShoppingListItem> filteredTodos = context
        .select((ListItemsOverviewBloc bloc) => bloc.state.filteredItems);

    final ListItemsOverviewStatus status =
        context.select((ListItemsOverviewBloc bloc) => bloc.state.status);

    final ShoppingList shoppingList =
        context.select((ListItemsOverviewBloc bloc) => bloc.shoppingList);

    return Expanded(
      child: status == ListItemsOverviewStatus.loading
          ? const CustomProgressIndicator()
          : AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Scrollbar(
                key: ValueKey<int>(
                    context.read<ListItemsOverviewBloc>().state.filter.index),
                radius: const Radius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                      itemCount: filteredTodos.length,
                      itemBuilder: (context, index) {
                        ShoppingListItem listItem =
                            filteredTodos.elementAt(index);

                        return ListItemTile(
                          key: Key(listItem.id),
                          listItem: listItem,
                          currentListUser: currentListUser,
                          onTap: () {
                            Navigator.push(
                              context,
                              ListItemEditPage.route(
                                  listItem: listItem,
                                  shoppingList: shoppingList),
                            );
                          },
                          onDismissed: (_) {
                            context.read<ListItemsOverviewBloc>().add(
                                ListItemsOverviewDeleted(listItem: listItem));
                          },
                          onToggleCompleted: (isCompleted) {
                            context.read<ListItemsOverviewBloc>().add(
                                  ListItemsOverviewCompletionToggled(
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
        context.select((ListItemsOverviewBloc bloc) => bloc.shoppingList);

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
                    ListItemEditPage.route(shoppingList: shoppingList));
              },
            ),
          )
        ],
      ),
    );
  }
}
