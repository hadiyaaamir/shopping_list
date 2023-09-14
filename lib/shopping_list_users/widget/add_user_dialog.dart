part of 'widget.dart';

class AddUserDialog extends StatelessWidget {
  const AddUserDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add User'),
      content: BlocBuilder<ShoppingListUsersBloc, ListUsersState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  context.read<ShoppingListUsersBloc>().add(
                      ShoppingListUsersIdentifierChanged(identifier: value));
                },
                decoration:
                    const InputDecoration(hintText: 'Email or Username'),
              ),
              const SizedBox(height: 20),
              ...ShoppingListUserRoles.values
                  .where((role) => role != ShoppingListUserRoles.owner)
                  .map<Widget>((ShoppingListUserRoles role) {
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
          onPressed: () async {
            context
                .read<ShoppingListUsersBloc>()
                .add(ShoppingListUsersAdded(onSuccess: () {
              final ListUsersState state =
                  context.read<ShoppingListUsersBloc>().state;
              final List<ShoppingListUser> listUsers =
                  state.users.map((roleUser) => roleUser.listUser).toList();

              context.read<ShoppingListBloc>().add(
                    ShoppingListListUsersEdited(listUsers: listUsers),
                  );
              Navigator.pop(context);
            }));
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  onSuccess(context) {
    final ListUsersState state = context.read<ShoppingListUsersBloc>().state;
    final List<ShoppingListUser> listUsers =
        state.users.map((roleUser) => roleUser.listUser).toList();

    context.read<ShoppingListBloc>().add(
          ShoppingListListUsersEdited(listUsers: listUsers),
        );
    Navigator.pop(context);
  }
}

class _RoleRadioButton extends StatelessWidget {
  const _RoleRadioButton({required this.role});

  final ShoppingListUserRoles role;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<ShoppingListUserRoles>(
      contentPadding: EdgeInsets.zero,
      title: Text(role.toTitleCaseString()),
      subtitle: Text(
        role.toStringInformation(),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      value: role,
      groupValue:
          context.select((ShoppingListUsersBloc bloc) => bloc.state.userRole),
      onChanged: (ShoppingListUserRoles? newRole) {
        context.read<ShoppingListUsersBloc>().add(ShoppingListUsersRoleChanged(
            userRole: newRole ?? ShoppingListUserRoles.editor));
      },
    );
  }
}
