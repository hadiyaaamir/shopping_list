part of 'view.dart';

class HomePagePage extends StatelessWidget {
  const HomePagePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePagePage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShoppingListBloc(
        userId: context.read<AuthenticationRepository>().currentAuthUser!.id,
        shoppingListRepository: context.read<ShoppingListRepository>(),
      )..add(const ShoppingListSubscriptionRequested()),
      child: const HomePageView(),
    );
  }
}
