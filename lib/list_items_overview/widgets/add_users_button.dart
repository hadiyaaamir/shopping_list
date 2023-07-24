import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/list_items_overview/bloc/list_items_overview_bloc.dart';
import 'package:shopping_list/list_users/view/view.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

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
              ListUsersPage.route(
                shoppingList: shoppingList,
                listItemsOverviewBloc:
                    BlocProvider.of<ListItemsOverviewBloc>(context),
              ));
        },
      ),
    );
  }
}
