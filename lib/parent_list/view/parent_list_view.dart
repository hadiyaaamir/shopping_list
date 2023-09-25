part of 'view.dart';

class ParentListView extends StatelessWidget {
  const ParentListView({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Shopping Lists', profileButton: true),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ParentListBloc, ParentListState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == ParentListStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('Unexpected error occured')),
                  );
              }
            },
          ),
          BlocListener<ParentListBloc, ParentListState>(
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
                            .read<ParentListBloc>()
                            .add(const ParentListUndoDelete());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: ParentList(initialIndex: initialIndex),
      ),
      floatingActionButton: Visibility(
        visible: context.select((ParentListBloc bloc) => bloc.state.filter) ==
            ParentListFilter.accepted,
        child: const _AddShoppingListButton(),
      ),
    );
  }
}

class _AddShoppingListButton extends StatelessWidget {
  const _AddShoppingListButton();

  @override
  Widget build(BuildContext context) {
    final shoppingListBloc = BlocProvider.of<ParentListBloc>(context);

    return BlocBuilder<ParentListBloc, ParentListState>(
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
