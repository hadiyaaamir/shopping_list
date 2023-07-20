part of 'view.dart';

class ListUsersView extends StatelessWidget {
  const ListUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    String owner =
        context.select((ListUsersBloc bloc) => bloc.shoppingList.userId);
    List users = context.select((ListUsersBloc bloc) => bloc.state.users);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Users'),
      body: BlocListener<ListUsersBloc, ListUsersState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == ListUsersStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Unexpected error occured')),
              );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: users.length + 1,
            itemBuilder: (context, index) {
              return index == 0
                  ? UserListTile(user: owner)
                  : UserListTile(user: users[index - 1]);
            },
          ),
        ),
      ),
    );
  }
}

class UserListTile extends StatelessWidget {
  const UserListTile({
    super.key,
    required this.user,
  });
  final String user;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(user));
  }
}
