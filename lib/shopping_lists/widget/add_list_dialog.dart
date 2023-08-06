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
          const Flexible(
            flex: 1,
            child: _IconInput(),
          ),
          Flexible(
            flex: 3,
            child: _TitleInput(initialValue: shoppingList?.title),
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
}

class _IconInput extends StatelessWidget {
  const _IconInput();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(50),
            child: BlocBuilder<ShoppingListBloc, ShoppingListState>(
              buildWhen: (previous, current) => previous.icon != current.icon,
              builder: (context, state) {
                return IconButton(
                  onPressed: () => _openIconPicker(context),
                  icon: Icon(state.icon),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Icon(
                  Icons.edit,
                  size: 10,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
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

class _TitleInput extends StatelessWidget {
  const _TitleInput({required this.initialValue});

  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: (value) {
        context
            .read<ShoppingListBloc>()
            .add(ShoppingListTitleChanged(title: value));
      },
      decoration: const InputDecoration(hintText: 'Enter title'),
    );
  }
}
