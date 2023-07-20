part of 'view.dart';

class ListItemsOverviewPage extends StatelessWidget {
  const ListItemsOverviewPage({super.key, required this.shoppingList});

  final ShoppingList shoppingList;

  static Route<void> route({required ShoppingList shoppingList}) {
    return MaterialPageRoute<void>(
      builder: (_) => ListItemsOverviewPage(shoppingList: shoppingList),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListItemsOverviewBloc(
        shoppingList: shoppingList,
        shoppingListRepository: context.read<ShoppingListRepository>(),
      )..add(const ListItemsOverviewSubscriptionRequested()),
      child: const ListItemsOverviewView(),
    );
  }
}
