part of 'view.dart';

class ShoppingListsPage extends StatelessWidget {
  const ShoppingListsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ShoppingListsPage());
  }

  @override
  Widget build(BuildContext context) {
    return const ShoppingListsView();
  }
}
