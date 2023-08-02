part of 'widgets.dart';

class ListItemTile extends StatelessWidget {
  const ListItemTile({
    super.key,
    required this.listItem,
    required this.onTap,
    required this.onToggleCompleted,
    required this.onDismissed,
    required this.currentListUser,
  });

  final ShoppingListItem listItem;
  final Function()? onTap;
  final DismissDirectionCallback? onDismissed;
  final ValueChanged<bool> onToggleCompleted;

  final ListUser? currentListUser;

  @override
  Widget build(BuildContext context) {
    final status = context.read<ListItemsOverviewBloc>().state.status;

    ListUserRoles userRole =
        currentListUser != null ? currentListUser!.role : ListUserRoles.viewer;

    bool allowEdit = (userRole != ListUserRoles.viewer) &&
        (userRole == ListUserRoles.owner ||
            listItem.userId == currentListUser?.id);

    final _ItemListTile listTile = _ItemListTile(
      listItem: listItem,
      allowEdit: allowEdit,
      onTap: onTap,
      onToggleCompleted: onToggleCompleted,
    );

    return allowEdit
        ? _DismissibleListTile(
            status: status,
            onDismissed: onDismissed,
            listTile: listTile,
          )
        : listTile;
  }
}

class _DismissibleListTile extends StatelessWidget {
  const _DismissibleListTile({
    required this.status,
    required this.onDismissed,
    required this.listTile,
  });

  final ListItemsOverviewStatus status;
  final DismissDirectionCallback? onDismissed;
  final _ItemListTile listTile;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('todoListTile_dismissible_${listTile.listItem.id}'),
      onDismissed:
          status == ListItemsOverviewStatus.loading ? null : onDismissed,
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

class _ItemListTile extends StatelessWidget {
  const _ItemListTile({
    required this.listItem,
    required this.allowEdit,
    required this.onTap,
    required this.onToggleCompleted,
  });

  final ShoppingListItem listItem;
  final bool allowEdit;
  final Function()? onTap;
  final ValueChanged<bool> onToggleCompleted;

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = !listItem.isCompleted
        ? null
        : const TextStyle(
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
          );

    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            listItem.item,
            style: textStyle,
          ),
          // const Text('    -    '),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(listItem.quantity, style: textStyle),
          ),
        ],
      ),
      subtitle: listItem.description.isNotEmpty
          ? Text(listItem.description, style: textStyle)
          : null,
      onTap: allowEdit ? onTap : null,
      leading: Checkbox(
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        value: listItem.isCompleted,
        onChanged: (value) => onToggleCompleted(value!),
      ),
      trailing: Icon(
        Icons.keyboard_arrow_right_rounded,
        color: allowEdit ? null : Colors.transparent,
      ),
    );
  }
}
