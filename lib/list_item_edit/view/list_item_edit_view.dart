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
            _QuantityInput(),
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

class _QuantityInput extends StatelessWidget {
  const _QuantityInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListItemEditBloc, ListItemEditState>(
      buildWhen: (previous, current) => previous.quantity != current.quantity,
      builder: (context, state) {
        return Stack(
          children: [
            CustomTextField(
              key: const Key('editItemForm_quantityInput_textField'),
              label: 'Quantity',
              initialValue: state.quantity.value,
              errorText: state.quantity.displayError != null
                  ? 'field cannot be empty'
                  : null,
              onChanged: (quantity) => context
                  .read<ListItemEditBloc>()
                  .add(ListItemEditQuantityChanged(quantity: quantity)),
            ),
            const Positioned(right: 15, bottom: 7, child: _QuantityUnitInput()),
          ],
        );
      },
    );
  }
}

class _QuantityUnitInput extends StatelessWidget {
  const _QuantityUnitInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListItemEditBloc, ListItemEditState>(
      buildWhen: (previous, current) =>
          previous.quantityUnit != current.quantityUnit,
      builder: (context, state) {
        return DropdownButton<String>(
          value: state.quantityUnit.value,
          onChanged: (newValue) {
            context.read<ListItemEditBloc>().add(
                ListItemEditQuantityUnitChanged(quantityUnit: newValue ?? ''));
          },
          items: cQuantityUnits.map((unit) {
            return DropdownMenuItem<String>(value: unit, child: Text(unit));
          }).toList(),
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
      buildWhen: (previous, current) =>
          previous.description != current.description,
      builder: (context, state) {
        return CustomTextField(
          key: const Key('editItemForm_descriptionInput_textField'),
          label: 'Description',
          maxLines: 3,
          initialValue: state.description.value,
          errorText: state.quantity.displayError != null
              ? 'field cannot be empty'
              : null,
          onChanged: (description) => context
              .read<ListItemEditBloc>()
              .add(ListItemEditDescriptionChanged(description: description)),
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
              ? const CustomProgressIndicator()
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
