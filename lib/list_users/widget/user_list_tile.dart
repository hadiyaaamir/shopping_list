part of 'widget.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({
    super.key,
    required this.user,
    this.onDismissed,
  });

  final RoleUser user;
  final DismissDirectionCallback? onDismissed;

  @override
  Widget build(BuildContext context) {
    final ListTile listTile = ListTile(
      title: Text('${user.user.firstName} ${user.user.lastName}'),
      subtitle: Text(user.user.email),
      trailing: Text(user.listUser.role.toStringValue().toUpperCase()),
    );

    return onDismissed != null
        ? _DismissibleListTile(
            listTile: listTile,
            dismissibleKey: Key('userTile_dismissible_${user.listUser.id}'),
            onDismissed: onDismissed,
          )
        : listTile;
  }
}

class _DismissibleListTile extends StatelessWidget {
  const _DismissibleListTile({
    required this.listTile,
    required this.dismissibleKey,
    required this.onDismissed,
  });

  final ListTile listTile;
  final Key dismissibleKey;
  final DismissDirectionCallback? onDismissed;

  @override
  Widget build(BuildContext context) {
    final status = context.read<ListUsersBloc>().state.status;

    return Dismissible(
      key: dismissibleKey,
      onDismissed: status == ListUsersStatus.loading ? null : onDismissed,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).colorScheme.error,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onError),
      ),
      child: listTile,
    );
  }
}
