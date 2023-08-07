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
        heroTag: 'listItem_${listItem?.id}',
        title:
            isNewItem ? 'Add List Item' : (listItem?.item ?? 'Edit List Item'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            _ItemInput(),
            SizedBox(height: 20),
            Row(
              children: [
                Flexible(flex: 2, child: _QuantityInput()),
                SizedBox(width: 10),
                Flexible(flex: 1, child: _QuantityUnitInput()),
              ],
            ),
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
        return CustomTextField(
          key: const Key('editItemForm_quantityInput_textField'),
          label: 'Quantity',
          initialValue: state.quantity.value,
          errorText: state.quantity.displayError != null
              ? state.quantity.displayError ==
                      NumericInputValidationError.invalid
                  ? 'Quantity must be numeric'
                  : null
              : null,
          onChanged: (quantity) => context
              .read<ListItemEditBloc>()
              .add(ListItemEditQuantityChanged(quantity: quantity)),
        );
      },
    );
  }
}

class _QuantityUnitInput extends StatefulWidget {
  const _QuantityUnitInput();

  @override
  State<_QuantityUnitInput> createState() => _QuantityUnitInputState();
}

class _QuantityUnitInputState extends State<_QuantityUnitInput> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListItemEditBloc, ListItemEditState>(
      buildWhen: (previous, current) =>
          previous.quantityUnit != current.quantityUnit,
      builder: (context, state) {
        _textEditingController.text = state.quantityUnit.value;

        _textEditingController.selection =
            TextSelection.collapsed(offset: _textEditingController.text.length);

        return TypeAheadField<String>(
          key: const Key('editItemForm_quantityUnitInput_textField'),
          textFieldConfiguration: TextFieldConfiguration(
            decoration: InputDecoration(
              labelText: 'Unit',
              errorText: state.quantityUnit.displayError != null
                  ? 'field cannot be empty'
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 3,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              alignLabelWithHint: true,
            ),
            controller: _textEditingController,
            onChanged: (newValue) {
              context.read<ListItemEditBloc>().add(
                    ListItemEditQuantityUnitChanged(quantityUnit: newValue),
                  );
            },
          ),
          suggestionsCallback: (pattern) async {
            return cQuantityUnits
                .where((unit) => unit.contains(pattern))
                .toList();
          },
          itemBuilder: (context, suggested) => ListTile(title: Text(suggested)),
          onSuggestionSelected: (suggestion) {
            context.read<ListItemEditBloc>().add(
                  ListItemEditQuantityUnitChanged(quantityUnit: suggestion),
                );
          },
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
