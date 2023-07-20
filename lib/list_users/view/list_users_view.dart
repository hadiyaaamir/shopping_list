part of 'view.dart';

class ListUsersView extends StatelessWidget {
  const ListUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    String userId =
        context.select((ListUsersBloc bloc) => bloc.shoppingList.userId);

    final List<User> users =
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
                const SnackBar(content: Text('Unexpected error occured')),
              );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: FutureBuilder<User>(
            future: context.read<UserRepository>().getUser(userId: userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final User owner = snapshot.data!;

                return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: users.length + 1,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? UserListTile(user: owner)
                        : UserListTile(user: users[index - 1]);
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
