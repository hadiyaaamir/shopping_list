import 'package:flutter/material.dart';
import 'package:shopping_list/list_users/view/view.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

class AddUsersButton extends StatelessWidget {
  const AddUsersButton({super.key, required this.shoppingList});

  final ShoppingList shoppingList;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.person_add_alt_1),
      onPressed: () {
        Navigator.push(
            context, ListUsersPage.route(shoppingList: shoppingList));
      },
    );
  }
}
