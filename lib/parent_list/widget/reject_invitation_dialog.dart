part of 'widget.dart';

class RejectInvitationDialog extends StatelessWidget {
  const RejectInvitationDialog({super.key, required this.shoppingList});

  final ShoppingList shoppingList;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Reject Invitation"),
      content: const Text(
          "Are you sure you want to reject the invitation to this list??"),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text("Reject"),
          onPressed: () {
            context
                .read<ParentListBloc>()
                .add(ParentListInvitationRejected(shoppingList: shoppingList));
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
