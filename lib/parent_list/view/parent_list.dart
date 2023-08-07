part of 'view.dart';

class ParentList extends StatelessWidget {
  const ParentList({super.key});

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
        context.select((ParentListBloc bloc) => bloc.state.shoppingLists);

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
                  todoLists.length,
                  (index) => ParentListTile(
                      shoppingList: todoLists[index],
                      onDismissed: (_) {
                        context.read<ParentListBloc>().add(
                            ParentListDeleted(shoppingList: todoLists[index]));
                      }),
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
