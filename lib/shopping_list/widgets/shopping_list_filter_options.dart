part of 'widgets.dart';

class ShoppingListFilterOptions extends StatelessWidget {
  const ShoppingListFilterOptions({super.key});

  @override
  Widget build(BuildContext context) {
    List filters = ShoppingListFilter.values.map((e) => e).toList();
    return Wrap(
      spacing: 10,
      children: List.generate(
        filters.length,
        (index) => FilterButton(filter: filters[index]),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.filter,
  });

  final ShoppingListFilter filter;

  @override
  Widget build(BuildContext context) {
    final activeFilter =
        context.select((ShoppingListBloc bloc) => bloc.state.filter);
    final colorScheme = Theme.of(context).colorScheme;

    bool isSelected = activeFilter == filter;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Padding(
        key: ValueKey<int>(context.read<ShoppingListBloc>().state.filter.index),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.primary, width: 2),
              color: isSelected ? colorScheme.primary : colorScheme.background,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Text(
                filter.text,
                style: TextStyle(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : Theme.of(context).textTheme.bodyLarge!.color),
              ),
            ),
          ),
          onTap: () => context
              .read<ShoppingListBloc>()
              .add(ShoppingListFilterChanged(filter: filter)),
        ),
      ),
    );
  }
}
