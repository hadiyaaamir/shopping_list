part of 'widget.dart';

class AddUserDialog extends StatelessWidget {
  const AddUserDialog({super.key, required this.listItemsOverviewBloc});
  final ListItemsOverviewBloc listItemsOverviewBloc;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add User'),
      content: BlocBuilder<ListUsersBloc, ListUsersState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  context
                      .read<ListUsersBloc>()
                      .add(ListUsersIdentifierChanged(identifier: value));
                },
                decoration:
                    const InputDecoration(hintText: 'Email or Username'),
              ),
              const SizedBox(height: 20),
              ...ListUserRoles.values
                  .where((role) => role != ListUserRoles.owner)
                  .map<Widget>((ListUserRoles role) {
                return _RoleRadioButton(role: role);
              }).toList(),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            context.read<ListUsersBloc>().add(const ListUsersAdded());

            final ListUsersState state = context.read<ListUsersBloc>().state;
            final List<ListUser> listUsers =
                state.users.map((roleUser) => roleUser.listUser).toList();
            listItemsOverviewBloc
                .add(ListItemsOverviewListUsersEdited(listUsers: listUsers));
            Navigator.pop(context);
            // context.read<ListItemsOverviewBloc>().add(
            //       ListItemsOverviewListUsersEdited(listUsers: listUsers),
            //     );
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class _RoleRadioButton extends StatelessWidget {
  const _RoleRadioButton({required this.role});

  final ListUserRoles role;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<ListUserRoles>(
      contentPadding: EdgeInsets.zero,
      title: Text(role.toTitleCaseString()),
      subtitle: Text(
        role.toStringInformation(),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      value: role,
      groupValue: context.select((ListUsersBloc bloc) => bloc.state.userRole),
      onChanged: (ListUserRoles? newRole) {
        context.read<ListUsersBloc>().add(
            ListUsersRoleChanged(userRole: newRole ?? ListUserRoles.editor));
      },
    );
  }
}
