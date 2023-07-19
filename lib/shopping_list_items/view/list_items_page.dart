part of 'view.dart';

class ListItemsPage extends StatelessWidget {
  const ListItemsPage({super.key, required this.shoppingList});

  final ShoppingList shoppingList;

  static Route<void> route({required ShoppingList shoppingList}) {
    return MaterialPageRoute<void>(
      builder: (_) => ListItemsPage(shoppingList: shoppingList),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShoppingListItemsBloc(
        shoppingList: shoppingList,
        shoppingListRepository: context.read<ShoppingListRepository>(),
      )..add(const ShoppingListItemsSubscriptionRequested()),
      child: const ListItemsView(),
    );
  }
}
