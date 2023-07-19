part of 'view.dart';

class ShoppingListsPage extends StatelessWidget {
  const ShoppingListsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ShoppingListsPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShoppingListBloc(
        userId: context.read<AuthenticationRepository>().currentAuthUser!.id,
        shoppingListRepository: context.read<ShoppingListRepository>(),
      )..add(const ShoppingListSubscriptionRequested()),
      child: const ShoppingListsView(),
    );
  }
}
