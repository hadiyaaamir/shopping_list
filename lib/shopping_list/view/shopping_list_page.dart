part of 'view.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({super.key, required this.shoppingList});

  final ShoppingList shoppingList;

  static Route<void> route({required ShoppingList shoppingList}) {
    return MaterialPageRoute<void>(
      builder: (_) => ShoppingListPage(shoppingList: shoppingList),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShoppingListBloc(
        shoppingList: shoppingList,
        shoppingListRepository: context.read<ShoppingListRepository>(),
      )..add(const ShoppingListSubscriptionRequested()),
      child: const ShoppingListView(),
    );
  }
}
