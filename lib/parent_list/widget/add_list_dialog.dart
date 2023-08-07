part of 'widget.dart';

class AddListDialog extends StatelessWidget {
  const AddListDialog({super.key, this.shoppingList});

  final ShoppingList? shoppingList;

  @override
  Widget build(BuildContext context) {
    if (shoppingList != null) {
      context
          .read<ParentListBloc>()
          .add(ParentListIconChanged(icon: shoppingList!.icon));
      context
          .read<ParentListBloc>()
          .add(ParentListTitleChanged(title: shoppingList!.title));
    } else {
      context
          .read<ParentListBloc>()
          .add(const ParentListIconChanged(icon: Icons.shopping_cart));
      context
          .read<ParentListBloc>()
          .add(const ParentListTitleChanged(title: 'Unnamed'));
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
                .read<ParentListBloc>()
                .add(ParentListAdded(shoppingList: shoppingList));
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
            child: BlocBuilder<ParentListBloc, ParentListState>(
              buildWhen: (previous, current) => previous.icon != current.icon,
              builder: (context, state) {
                return IconButton(
                  onPressed: () => _openIconPicker(context),
                  icon: Icon(
                    state.icon,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
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
    await FlutterIconPicker.showIconPicker(
      context,
      iconPackModes: [IconPack.custom],
      customIconPack: cShoppingListIconPack,
      iconColor: Theme.of(context).colorScheme.primary,
      iconSize: 25,
      crossAxisSpacing: 20,
      mainAxisSpacing: 15,
      showSearchBar: false,
      constraints: const BoxConstraints(maxHeight: 150),
    ).then((icon) {
      if (icon != null) {
        context.read<ParentListBloc>().add(ParentListIconChanged(icon: icon));
      }
    });
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
            .read<ParentListBloc>()
            .add(ParentListTitleChanged(title: value));
      },
      decoration: const InputDecoration(hintText: 'Enter title'),
    );
  }
}
