part of 'view.dart';

class ParentListPage extends StatelessWidget {
  const ParentListPage({super.key, required this.openInvitationTab});

  final bool openInvitationTab;

  static Route<void> route({bool openInvitationTab = false}) {
    return MaterialPageRoute<void>(
      builder: (_) => ParentListPage(
        openInvitationTab: openInvitationTab,
      ),
    );
  }

  static void navigateToScreen({bool openInvitationTab = true}) {
    navigatorKey.currentState?.push(
      ParentListPage.route(openInvitationTab: openInvitationTab),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ParentListBloc(
        userId: context.read<AuthenticationRepository>().currentAuthUser!.id,
        shoppingListRepository: context.read<ShoppingListRepository>(),
        messagingRepository: context.read<MessagingRepository>(),
      )
        ..add(const ParentListSubscriptionRequested())
        ..add(
          ParentListFilterChanged(
            filter: openInvitationTab
                ? ParentListFilter.invitations
                : ParentListFilter.accepted,
          ),
        ),
      child: ParentListView(initialIndex: openInvitationTab ? 1 : 0),
    );
  }
}
