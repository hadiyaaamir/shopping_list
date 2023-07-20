part of 'widget.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({
    super.key,
    required this.user,
  });
  final ListUser user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.id),
      subtitle: Text(user.role.toStringValue()),
    );
  }
}
