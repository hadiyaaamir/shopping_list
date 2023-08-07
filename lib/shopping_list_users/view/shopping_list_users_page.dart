part of 'view.dart';

class ShoppingListUsersPage extends StatelessWidget {
  const ShoppingListUsersPage({
    super.key,
    required this.shoppingList,
  });

  final ShoppingList shoppingList;

  static Route<void> route({
    required ShoppingList shoppingList,
    required ShoppingListBloc listItemsOverviewBloc,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: listItemsOverviewBloc,
        child: ShoppingListUsersPage(shoppingList: shoppingList),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShoppingListUsersBloc(
        shoppingList: shoppingList,
        userRepository: context.read<UserRepository>(),
        shoppingListRepository: context.read<ShoppingListRepository>(),
        listUsers: BlocProvider.of<ShoppingListBloc>(context).state.listUsers,
      )..add(const ShoppingListUsersGetUsersDetails()),
      child: const ShoppingListUsersView(),
    );
  }
}
