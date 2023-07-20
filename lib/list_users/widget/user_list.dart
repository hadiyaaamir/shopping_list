part of 'widget.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({
    super.key,
    required this.user,
  });
  final RoleUser user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${user.user.firstName} ${user.user.lastName}'),
      subtitle: Text(user.user.email),
      trailing: Text(user.listUser.role.toStringValue().toUpperCase()),
    );
  }
}
