part of 'view.dart';

class UsersList extends StatelessWidget {
  const UsersList({
    super.key,
    required this.userId,
    required this.users,
  });

  final String userId;
  final List<RoleUser> users;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: FutureBuilder<User>(
        future: context.read<UserRepository>().getUser(userId: userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final RoleUser owner = RoleUser(
              user: snapshot.data!,
              listUser: ListUser(id: userId, role: ListUserRoles.owner),
            );

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
    );
  }
}
