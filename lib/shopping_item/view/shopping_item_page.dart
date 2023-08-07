part of 'view.dart';

class ShoppingItemPage extends StatelessWidget {
  const ShoppingItemPage(
      {super.key, required this.shoppingList, this.listItem});

  final ShoppingList shoppingList;
  final ShoppingListItem? listItem;

  static Route<void> route(
      {ShoppingListItem? listItem, required ShoppingList shoppingList}) {
    return PageRouteBuilder(
      fullscreenDialog: true,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BlocProvider(
          create: (context) => ShoppingItemBloc(
            shoppingListRepository: context.read<ShoppingListRepository>(),
            shoppingList: shoppingList,
            listItem: listItem,
            userId:
                context.read<AuthenticationRepository>().currentAuthUser!.id,
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: ShoppingItemPage(
              shoppingList: shoppingList,
              listItem: listItem,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShoppingItemBloc, ShoppingItemState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == ShoppingItemStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const ShoppingItemView(),
    );
  }
}
