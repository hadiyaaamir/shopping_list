part of 'widgets.dart';

class ItemListTile extends StatelessWidget {
  const ItemListTile({
    super.key,
    required this.listItem,
    required this.onTap,
    required this.onToggleCompleted,
    required this.onDismissed,
  });

  final ShoppingListItem listItem;
  final Function() onTap;
  final DismissDirectionCallback onDismissed;
  final ValueChanged<bool> onToggleCompleted;

  @override
  Widget build(BuildContext context) {
    final status = context.read<ShoppingListItemsBloc>().state.status;

    return Dismissible(
      key: Key('todoListTile_dismissible_${listItem.id}'),
      onDismissed:
          status == ShoppingListItemsStatus.loading ? null : onDismissed,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).colorScheme.error,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onError),
      ),
      child: ListTile(
        title: Text(
          listItem.title,
          style: !listItem.isCompleted
              ? null
              : const TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
        ),
        subtitle: listItem.description.isNotEmpty
            ? Text(
                listItem.description,
                style: !listItem.isCompleted
                    ? null
                    : const TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
              )
            : null,
        onTap: onTap,
        leading: Checkbox(
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          value: listItem.isCompleted,
          onChanged: (value) => onToggleCompleted(value!),
        ),
        trailing: const Icon(Icons.keyboard_arrow_right_rounded),
      ),
    );
  }
}
