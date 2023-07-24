part of 'view.dart';

class ListUsersView extends StatelessWidget {
  const ListUsersView({super.key, required this.listItemsOverviewBloc});

  final ListItemsOverviewBloc listItemsOverviewBloc;

  @override
  Widget build(BuildContext context) {
    String userId =
        context.select((ListUsersBloc bloc) => bloc.shoppingList.userId);

    final List<RoleUser> users =
        context.select((ListUsersBloc bloc) => bloc.state.users);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Users'),
      body: BlocListener<ListUsersBloc, ListUsersState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == ListUsersStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content:
                      Text(state.errorMessage ?? 'Unexpected error occured'),
                ),
              );
          }
        },
        child: UsersList(userId: userId, users: users),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          _AddUserButton(listItemsOverviewBloc: listItemsOverviewBloc),
    );
  }
}

class _AddUserButton extends StatelessWidget {
  const _AddUserButton({required this.listItemsOverviewBloc});
  final ListItemsOverviewBloc listItemsOverviewBloc;

  @override
  Widget build(BuildContext context) {
    final listUsersBloc = BlocProvider.of<ListUsersBloc>(context);

    return BlocBuilder<ListUsersBloc, ListUsersState>(
      builder: (context, state) {
        return Button(
          label: 'Add User',
          onPressed: () => showDialog(
            context: context,
            builder: (context) => BlocProvider.value(
              value: listUsersBloc,
              child:
                  AddUserDialog(listItemsOverviewBloc: listItemsOverviewBloc),
            ),
          ),
        );
      },
    );
  }
}
