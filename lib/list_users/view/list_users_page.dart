part of 'view.dart';

class ListUsersPage extends StatelessWidget {
  const ListUsersPage({
    super.key,
    required this.shoppingList,
    required this.listItemsOverviewBloc,
    // required this.listUsers,
  });

  final ShoppingList shoppingList;
  final ListItemsOverviewBloc listItemsOverviewBloc;
  // final List<ListUser> listUsers;

  static Route<void> route({
    required ShoppingList shoppingList,
    required ListItemsOverviewBloc listItemsOverviewBloc,
    // required List<ListUser> listUsers,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => ListUsersPage(
        shoppingList: shoppingList,
        listItemsOverviewBloc: listItemsOverviewBloc,
        // listUsers: listUsers
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListUsersBloc(
        shoppingList: shoppingList,
        userRepository: context.read<UserRepository>(),
        shoppingListRepository: context.read<ShoppingListRepository>(),
        listUsers: listItemsOverviewBloc.state.listUsers,
      )..add(const ListUsersGetUsersDetails()),
      child: ListUsersView(listItemsOverviewBloc: listItemsOverviewBloc),
    );
  }
}
