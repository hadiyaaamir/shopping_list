part of 'widgets.dart';

class AddUsersButton extends StatelessWidget {
  const AddUsersButton({super.key, required this.shoppingList});

  final ShoppingList shoppingList;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.person_add_alt_1),
      onPressed: () {
        Navigator.push(
            context,
            ShoppingListUsersPage.route(
              shoppingList: shoppingList,
              listItemsOverviewBloc: BlocProvider.of<ShoppingListBloc>(context),
            ));
      },
    );
  }
}

class UserLeaveButton extends StatelessWidget {
  const UserLeaveButton(
      {super.key, required this.userId, required this.shoppingListBloc});

  final String userId;
  final ShoppingListBloc shoppingListBloc;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.exit_to_app),
      onPressed: () => showDialog(
        context: context,
        builder: (context) => MultiBlocProvider(
          providers: [BlocProvider.value(value: shoppingListBloc)],
          child: _LeaveListDialog(userId: userId),
        ),
      ),
    );
  }
}

class _LeaveListDialog extends StatelessWidget {
  const _LeaveListDialog({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm Leaving"),
      content: const Text("Are you sure you want to leave this list?"),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text("Leave"),
          onPressed: () {
            context
                .read<ShoppingListBloc>()
                .add(ShoppingListUserLeaves(userId: userId));
            Navigator.pop(context);

            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
