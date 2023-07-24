part of 'view.dart';

class ListItemEditPage extends StatelessWidget {
  const ListItemEditPage({super.key, required this.shoppingList});

  final ShoppingList shoppingList;

  static Route<void> route(
      {ShoppingListItem? listItem, required ShoppingList shoppingList}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => ListItemEditBloc(
          shoppingListRepository: context.read<ShoppingListRepository>(),
          shoppingList: shoppingList,
          listItem: listItem,
          userId: context.read<AuthenticationRepository>().currentAuthUser!.id,
        ),
        child: ListItemEditPage(shoppingList: shoppingList),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListItemEditBloc, ListItemEditState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == ListItemEditStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const ListItemEditView(),
    );
  }
}
