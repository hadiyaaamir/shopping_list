part of 'view.dart';

class ListItemEditView extends StatelessWidget {
  const ListItemEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final isNewItem = context.select(
      (ListItemEditBloc bloc) => bloc.state.isNewItem,
    );
    final listItem =
        context.select((ListItemEditBloc bloc) => bloc.state.listItem);

    return Scaffold(
      appBar: CustomAppBar(
        title:
            isNewItem ? 'Add List Item' : (listItem?.item ?? 'Edit List Item'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            _ItemInput(),
            SizedBox(height: 20),
            _DescriptionInput(),
          ]),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _EditTodoButton(isNewItem: isNewItem),
    );
  }
}

class _ItemInput extends StatelessWidget {
  const _ItemInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListItemEditBloc, ListItemEditState>(
      buildWhen: (previous, current) => previous.item != current.item,
      builder: (context, state) {
        return CustomTextField(
          key: const Key('editItemForm_itemInput_textField'),
          label: 'Item Name',
          initialValue: state.item.value,
          errorText:
              state.item.displayError != null ? 'field cannot be empty' : null,
          onChanged: (listItem) => context
              .read<ListItemEditBloc>()
              .add(ListItemEditItemChanged(item: listItem)),
        );
      },
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  const _DescriptionInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListItemEditBloc, ListItemEditState>(
      buildWhen: (previous, current) => previous.quantity != current.quantity,
      builder: (context, state) {
        return CustomTextField(
          key: const Key('editItemForm_descriptionInput_textField'),
          label: 'Quantity',
          initialValue: state.quantity.value,
          errorText: state.quantity.displayError != null
              ? 'field cannot be empty'
              : null,
          onChanged: (quantity) => context
              .read<ListItemEditBloc>()
              .add(ListItemEditQuantityChanged(quantity: quantity)),
        );
      },
    );
  }
}

class _EditTodoButton extends StatelessWidget {
  const _EditTodoButton({required this.isNewItem});

  final bool isNewItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      child: BlocBuilder<ListItemEditBloc, ListItemEditState>(
        builder: (context, state) {
          return state.status.isLoadingOrSuccess
              ? const CircularProgressIndicator()
              : Button(
                  key: const Key('editItemForm_button'),
                  onPressed: state.isValid
                      ? () => context
                          .read<ListItemEditBloc>()
                          .add(const ListItemEditSubmitted())
                      : null,
                  label: isNewItem ? 'Add Item' : 'Edit Item',
                );
        },
      ),
    );
  }
}
