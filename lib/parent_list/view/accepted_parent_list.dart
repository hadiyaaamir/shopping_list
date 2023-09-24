part of 'view.dart';

class AcceptedParentList extends StatelessWidget {
  const AcceptedParentList({super.key, required this.filteredList});

  final List<ShoppingList> filteredList;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentListBloc, ParentListState>(
      builder: (context, state) {
        if (state.shoppingLists.isEmpty) {
          return (state.status == ParentListStatus.loading)
              ? const CustomProgressIndicator()
              : (state.status != ParentListStatus.success)
                  ? const SizedBox()
                  : const _EmptyList();
        }
        return _NonEmptyList(filteredList: filteredList);
      },
    );
  }
}

class _NonEmptyList extends StatelessWidget {
  const _NonEmptyList({required this.filteredList});

  final List<ShoppingList> filteredList;

  @override
  Widget build(BuildContext context) {
    final ParentListStatus status =
        context.select((ParentListBloc bloc) => bloc.state.status);

    return status == ParentListStatus.loading
        ? const Center(child: CustomProgressIndicator())
        : Scrollbar(
            radius: const Radius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                children: List.generate(
                  filteredList.length,
                  (index) => ParentListTile(
                    shoppingList: filteredList[index],
                    onDismissed: (_) {
                      context.read<ParentListBloc>().add(
                            ParentListDeleted(
                              shoppingList: filteredList[index],
                            ),
                          );
                    },
                  ),
                ),
              ),
            ),
          );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList();

  @override
  Widget build(BuildContext context) {
    final shoppingListBloc = BlocProvider.of<ParentListBloc>(context);
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
              builder: (context) => MultiBlocProvider(
                providers: [BlocProvider.value(value: shoppingListBloc)],
                child: const AddListDialog(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
