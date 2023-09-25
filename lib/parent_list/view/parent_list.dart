part of 'view.dart';

class ParentList extends StatelessWidget {
  const ParentList({super.key, required this.initialIndex});

  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ParentListFilter.values.length,
      initialIndex: initialIndex,
      child: Column(
        children: [
          TabBar(
            tabs: ParentListFilter.values
                .map((filter) => Tab(text: filter.text))
                .toList(),
            onTap: (index) => context.read<ParentListBloc>().add(
                  ParentListFilterChanged(
                    filter: ParentListFilter.values[index],
                  ),
                ),
          ),
          Expanded(
            child: BlocBuilder<ParentListBloc, ParentListState>(
              builder: (context, state) {
                final filteredList = context.select(
                  (ParentListBloc bloc) => bloc.state.filteredLists(
                    bloc.userId,
                  ),
                );

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: state.filter == ParentListFilter.accepted
                      ? AcceptedList(
                          key: const Key('accepted_lists'),
                          filteredList: filteredList.toList(),
                        )
                      : InvitationsList(
                          key: const Key('invitations'),
                          filteredList: filteredList.toList(),
                        ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
