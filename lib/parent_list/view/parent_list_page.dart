part of 'view.dart';

class ParentListPage extends StatelessWidget {
  const ParentListPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ParentListPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ParentListBloc(
        userId: context.read<AuthenticationRepository>().currentAuthUser!.id,
        shoppingListRepository: context.read<ShoppingListRepository>(),
        messagingRepository: context.read<MessagingRepository>(),
      )..add(const ParentListSubscriptionRequested()),
      child: const ParentListView(),
    );
  }
}
