part of 'widget.dart';

class AddListDialog extends StatelessWidget {
  const AddListDialog({super.key, this.shoppingList});

  final ShoppingList? shoppingList;

  @override
  Widget build(BuildContext context) {
    if (shoppingList != null) {
      context
          .read<ShoppingListBloc>()
          .add(ShoppingListIconChanged(icon: shoppingList!.icon));
    } else {
      context
          .read<ShoppingListBloc>()
          .add(const ShoppingListIconChanged(icon: Icons.shopping_cart));
    }

    return AlertDialog(
      title: Text('${shoppingList == null ? 'Add' : 'Edit'} Shopping List'),
      content: Row(
        children: [
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(50),
                child: BlocBuilder<ShoppingListBloc, ShoppingListState>(
                  buildWhen: (previous, current) =>
                      previous.icon != current.icon,
                  builder: (context, state) {
                    return IconButton(
                      onPressed: () => _openIconPicker(context),
                      icon: Icon(state.icon),
                    );
                  },
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: TextFormField(
              initialValue: shoppingList?.title,
              onChanged: (value) {
                context
                    .read<ShoppingListBloc>()
                    .add(ShoppingListTitleChanged(title: value));
              },
              decoration: const InputDecoration(hintText: 'Enter title'),
            ),
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
            Navigator.pop(context);
            context
                .read<ShoppingListBloc>()
                .add(ShoppingListAdded(shoppingList: shoppingList));
          },
          child: Text(shoppingList == null ? 'Add' : 'Edit'),
        ),
      ],
    );
  }

  Future<void> _openIconPicker(BuildContext context) async {
    final icon = await FlutterIconPicker.showIconPicker(
      context,
      iconPackModes: [IconPack.material],
    );
    if (icon != null) {
      context.read<ShoppingListBloc>().add(ShoppingListIconChanged(icon: icon));
    }
  }
}
