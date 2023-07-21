part of 'view.dart';

class ListUsersPage extends StatelessWidget {
  const ListUsersPage({super.key, required this.shoppingList});

  final ShoppingList shoppingList;

  static Route<void> route({required ShoppingList shoppingList}) {
    return MaterialPageRoute<void>(
      builder: (_) => ListUsersPage(shoppingList: shoppingList),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListUsersBloc(
        shoppingList: shoppingList,
        userRepository: context.read<UserRepository>(),
        shoppingListRepository: context.read<ShoppingListRepository>(),
      )..add(const ListUsersGetUsersDetails()),
      child: const ListUsersView(),
    );
  }
}
