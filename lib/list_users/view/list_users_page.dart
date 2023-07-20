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
        shoppingListRepository: context.read<ShoppingListRepository>(),
        userRepository: context.read<UserRepository>(),
      )..add(const ListUsersSubscriptionRequested()),
      child: const ListUsersView(),
    );
  }
}
