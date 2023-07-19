part of 'view.dart';

class ListItemsList extends StatelessWidget {
  const ListItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListItemsOverviewBloc, ListItemsOverviewState>(
      builder: (context, state) {
        if (state.listItems.isEmpty) {
          return (state.status == ListItemsOverviewStatus.loading)
              ? const Center(child: CircularProgressIndicator())
              : (state.status != ListItemsOverviewStatus.success)
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
        .select((ListItemsOverviewBloc bloc) => bloc.state.filteredItems);

    final ListItemsOverviewStatus status =
        context.select((ListItemsOverviewBloc bloc) => bloc.state.status);

    final ShoppingList shoppingList =
        context.select((ListItemsOverviewBloc bloc) => bloc.shoppingList);

    return Expanded(
      child: status == ListItemsOverviewStatus.loading
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
                      return ListItemTile(
                        listItem: listItem,
                        onTap: () {
                          //TODO: add nav
                          // Navigator.push(
                          //   context,
                          //   TodoEditPage.route(todo: todo, todoList: todoList),
                          // );
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
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList();

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
          Button(
            label: 'Add To Do',
            width: 130,
            onPressed: () {
              //TODO: add nav
              // Navigator.push(context, TodoEditPage.route(todoList: todoList));
            },
          )
        ],
      ),
    );
  }
}