part of 'widgets.dart';

class AddUsersButton extends StatelessWidget {
  const AddUsersButton({
    super.key,
    required this.shoppingList,
    required this.isVisible,
  });

  final ShoppingList shoppingList;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: IconButton(
        icon: const Icon(Icons.person_add_alt_1),
        onPressed: () {
          Navigator.push(
              context,
              ShoppingListUsersPage.route(
                shoppingList: shoppingList,
                listItemsOverviewBloc:
                    BlocProvider.of<ShoppingListBloc>(context),
              ));
        },
      ),
    );
  }
}
