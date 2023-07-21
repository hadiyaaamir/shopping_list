part of 'view.dart';

class AddUserDialog extends StatelessWidget {
  const AddUserDialog({
    super.key,
    required this.listUsersBloc,
  });

  final ListUsersBloc listUsersBloc;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add User'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) {
              listUsersBloc.add(ListUsersIdentifierChanged(identifier: value));
            },
            decoration: const InputDecoration(hintText: 'Email or Username'),
          ),
          DropdownButtonFormField<ListUserRoles>(
            value: listUsersBloc.state.userRole,
            onChanged: (ListUserRoles? newRole) {
              listUsersBloc.add(ListUsersRoleChanged(
                  userRole: newRole ?? ListUserRoles.editor));
            },
            items: ListUserRoles.values
                .map<DropdownMenuItem<ListUserRoles>>((ListUserRoles value) {
              return DropdownMenuItem<ListUserRoles>(
                value: value,
                child: Text(value.toStringValue().toUpperCase()),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            listUsersBloc.add(const ListUsersAdded());
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
