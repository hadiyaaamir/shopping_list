part of 'widget.dart';

class AddListDialog extends StatelessWidget {
  const AddListDialog({
    super.key,
    required this.shoppingListBloc,
    this.shoppingList,
  });

  final ShoppingListBloc shoppingListBloc;
  final ShoppingList? shoppingList;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${shoppingList == null ? 'Add' : 'Edit'} Shopping List'),
      content: TextFormField(
        initialValue: shoppingList?.title,
        onChanged: (value) {
          shoppingListBloc.add(ShoppingListTitleChanged(title: value));
        },
        decoration: const InputDecoration(hintText: 'Enter title'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            shoppingListBloc.add(ShoppingListAdded(shoppingList: shoppingList));
          },
          child: Text(shoppingList == null ? 'Add' : 'Edit'),
        ),
      ],
    );
  }
}
