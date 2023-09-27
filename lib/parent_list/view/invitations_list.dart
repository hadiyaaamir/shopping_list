part of 'view.dart';

class InvitationsList extends StatelessWidget {
  const InvitationsList({super.key, required this.filteredList});

  final List<ShoppingList> filteredList;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentListBloc, ParentListState>(
      builder: (context, state) {
        if (filteredList.isEmpty) {
          return (state.status == ParentListStatus.loading)
              ? const CustomProgressIndicator()
              : (state.status != ParentListStatus.success)
                  ? const SizedBox()
                  : const _EmptyInvitationsList();
        }
        return _NonEmptyInvitationsList(filteredList: filteredList);
      },
    );
  }
}

class _NonEmptyInvitationsList extends StatelessWidget {
  const _NonEmptyInvitationsList({required this.filteredList});

  final List<ShoppingList> filteredList;

  @override
  Widget build(BuildContext context) {
    final ParentListStatus status =
        context.select((ParentListBloc bloc) => bloc.state.status);

    return status == ParentListStatus.loading
        ? const Center(child: CustomProgressIndicator())
        : Scrollbar(
            radius: const Radius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 10,
                ),
                itemCount: filteredList.length,
                itemBuilder: (context, index) => InvitationsListTile(
                  shoppingList: filteredList[index],
                ),
              ),
            ),
          );
  }
}

class _EmptyInvitationsList extends StatelessWidget {
  const _EmptyInvitationsList();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 35),
      child: Center(
        child: Text(
          'You don\'t have any invitations at the moment ',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
