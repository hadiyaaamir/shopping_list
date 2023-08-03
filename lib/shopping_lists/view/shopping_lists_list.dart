part of 'view.dart';

class ShoppingListsList extends StatelessWidget {
  const ShoppingListsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListBloc, ShoppingListState>(
      builder: (context, state) {
        if (state.shoppingLists.isEmpty) {
          return (state.status == ShoppingListStatus.loading)
              ? const Center(child: CircularProgressIndicator())
              : (state.status != ShoppingListStatus.success)
                  ? const SizedBox()
                  : const _EmptyList();
        }
        return const _NonEmptyList();
      },
    );
  }
}

class _NonEmptyList extends StatelessWidget {
  const _NonEmptyList();

  @override
  Widget build(BuildContext context) {
    List todoLists =
        context.select((ShoppingListBloc bloc) => bloc.state.shoppingLists);

    final ShoppingListStatus status =
        context.select((ShoppingListBloc bloc) => bloc.state.status);

    return status == ShoppingListStatus.loading
        ? const Center(child: CircularProgressIndicator())
        : Scrollbar(
            radius: const Radius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GridView.count(
                // itemCount: todoLists.length,
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                children: List.generate(
                  todoLists.length,
                  (index) => ShoppingListTile(
                      shoppingList: todoLists[index],
                      onDismissed: (_) {
                        context.read<ShoppingListBloc>().add(
                            ShoppingListDeleted(
                                shoppingList: todoLists[index]));
                      }),
                ),

                // itemBuilder: (context, index) => ShoppingListTile(
                //     shoppingList: todoLists[index],
                //     onDismissed: (_) {
                //       context.read<ShoppingListBloc>().add(
                //           ShoppingListDeleted(shoppingList: todoLists[index]));
                //     }),
                // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //   crossAxisCount: 2,
                //   // crossAxisSpacing: 4.0,
                //   mainAxisSpacing: 0,
                // ),
              ),
            ),
          );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList();

  @override
  Widget build(BuildContext context) {
    final shoppingListBloc = BlocProvider.of<ShoppingListBloc>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('You don\'t have any lists yet'),
          const SizedBox(height: 10),
          Button(
            label: 'Create List',
            width: 130,
            onPressed: () => showDialog(
              context: context,
              builder: (context) =>
                  AddListDialog(shoppingListBloc: shoppingListBloc),
            ),
          )
        ],
      ),
    );
  }
}
