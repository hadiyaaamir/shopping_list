part of 'widget.dart';

class AddUserDialog extends StatelessWidget {
  const AddUserDialog({super.key});

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
              ...ListUserRoles.values
                  .where((role) => role != ListUserRoles.owner)
                  .map<Widget>((ListUserRoles value) {
                return RadioListTile<ListUserRoles>(
                  title: Text(value.toStringValue()),
                  value: value,
                  groupValue: context
                      .select((ListUsersBloc bloc) => bloc.state.userRole),
                  onChanged: (ListUserRoles? newRole) {
                    context.read<ListUsersBloc>().add(ListUsersRoleChanged(
                        userRole: newRole ?? ListUserRoles.editor));
                  },
                );
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
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
