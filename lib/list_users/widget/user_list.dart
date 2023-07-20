part of 'widget.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({
    super.key,
    required this.user,
  });
  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.firstName),
      // subtitle: Text(user.role.toStringValue()),
    );
  }
}
