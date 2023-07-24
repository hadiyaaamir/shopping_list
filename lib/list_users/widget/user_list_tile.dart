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
    return onDismissed != null
        ? _DismissibleListTile(
            listTile: _ListTile(user: user),
            dismissibleKey: Key('userTile_dismissible_${user.listUser.id}'),
            onDismissed: onDismissed,
          )
        : _ListTile(user: user, roleDropdown: false);
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({required this.user, this.roleDropdown = true});

  final RoleUser user;
  final bool roleDropdown;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${user.user.firstName} ${user.user.lastName}'),
      subtitle: Text(user.user.email),
      trailing: roleDropdown
          ? _Dropdown(user: user)
          : Text(user.listUser.role.toStringValue().toUpperCase()),
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({required this.user});

  final RoleUser user;

  @override
  Widget build(BuildContext context) {
    final List<ListUserRoles> userRolesList = ListUserRoles.values
        .where((role) => role != ListUserRoles.owner)
        .toList();

    return DropdownButton<ListUserRoles>(
      value: user.listUser.role,
      items: userRolesList.map((role) {
        return DropdownMenuItem<ListUserRoles>(
          value: role,
          child: Text(role.toStringValue().toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall),
        );
      }).toList(),
      onChanged: (newValue) {
        final editedUser = user.listUser.copyWith(role: newValue);

        context.read<ListUsersBloc>().add(
              ListUsersEdited(
                editedUser: editedUser,
                onSuccess: () {
                  final List<ListUser> listUsers = context
                      .read<ListUsersBloc>()
                      .state
                      .users
                      .map((roleUser) => roleUser.listUser)
                      .toList();

                  context.read<ListItemsOverviewBloc>().add(
                      ListItemsOverviewListUsersEdited(listUsers: listUsers));
                },
              ),
            );
      },
    );
  }
}

class _DismissibleListTile extends StatelessWidget {
  const _DismissibleListTile({
    required this.listTile,
    required this.dismissibleKey,
    required this.onDismissed,
  });

  final _ListTile listTile;
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
