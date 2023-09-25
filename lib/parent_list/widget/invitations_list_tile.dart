part of 'widget.dart';

class InvitationsListTile extends StatelessWidget {
  const InvitationsListTile({super.key, required this.shoppingList});

  final ShoppingList shoppingList;

  @override
  Widget build(BuildContext context) {
    final ParentListBloc parentListBloc = context.read<ParentListBloc>();

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        leading: _InvitationsTileIcon(icon: shoppingList.icon),
        title: Text(
          shoppingList.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _RejectButton(
              shoppingList: shoppingList,
              parentListBloc: parentListBloc,
            ),
            _AcceptButton(shoppingList: shoppingList),
          ],
        ),
      ),
    );
  }
}

class _InvitationsTileIcon extends StatelessWidget {
  const _InvitationsTileIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: Theme.of(context).colorScheme.primary,
      size: 25,
    );
  }
}

class _AcceptButton extends StatelessWidget {
  const _AcceptButton({required this.shoppingList});

  final ShoppingList shoppingList;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Icon(Icons.check, size: 20),
      ),
      onTap: () => context
          .read<ParentListBloc>()
          .add(ParentListInvitationAccepted(shoppingList: shoppingList)),
    );
  }
}

class _RejectButton extends StatelessWidget {
  const _RejectButton({
    required this.shoppingList,
    required this.parentListBloc,
  });

  final ShoppingList shoppingList;
  final ParentListBloc parentListBloc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Icon(Icons.close, size: 20),
      ),
      onTap: () => showDialog(
        context: context,
        builder: (context) => MultiBlocProvider(
          providers: [BlocProvider.value(value: parentListBloc)],
          child: RejectInvitationDialog(shoppingList: shoppingList),
        ),
      ),
    );
  }
}
