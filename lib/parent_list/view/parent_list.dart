part of 'view.dart';

class ParentList extends StatelessWidget {
  const ParentList({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ParentListFilter.values.length,
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
                final filteredLists = context.select(
                  (ParentListBloc bloc) => bloc.state.filteredLists(
                    bloc.userId,
                  ),
                );

                return state.filter == ParentListFilter.accepted
                    ? AcceptedParentList(filteredList: filteredLists.toList())
                    : Container();
              },
            ),
          )
        ],
      ),
    );
  }
}
