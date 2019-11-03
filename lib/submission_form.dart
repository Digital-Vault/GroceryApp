import 'package:flutter/material.dart';
import 'package:grocery_app/grocery_item.dart';
import 'package:grocery_app/item_provider.dart';

class SubmissionForm extends StatefulWidget {
  final GroceryItem item;
  SubmissionForm({this.item});

  @override
  _SubmissionFormState createState() =>
      _SubmissionFormState(item: item, title: _appBarTitle());

  String _appBarTitle() {
    if (item == null) {
      return 'Add New Item';
    } else {
      return 'Edit ${item.name}';
    }
  }
}

class _SubmissionFormState extends State<SubmissionForm> {
  _SubmissionFormState({this.item, this.title});

  GroceryItem item;
  final title;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (!itemExist()) {
      item = GroceryItem(name: '');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: _formBody(),
    );
  }

  bool itemExist() {
    return item != null;
  }

  Widget _formBody() {
    return Padding(
      padding: EdgeInsets.only(top: 32, left: 32, right: 32),
      child: _form(),
    );
  }

  Widget _form() => Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            _itemNameInput(),
            _namePadding(),
            _itemQuantityInput(),
            _quantityPadding(),
            _saveButton(),
          ],
        ),
      );

  Widget _itemNameInput() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Milk',
        labelText: 'Name',
      ),
      initialValue: item.name,
      validator: _nameValid,
      onSaved: _onNameSaved,
    );
  }

  String _nameValid(String inputValue) {
    if (inputValue.isEmpty) {
      return 'Name must be entered';
    } else {
      return null;
    }
  }

  void _onNameSaved(String inputValue) {
    item.name = inputValue;
  }

  Padding _namePadding() {
    return Padding(
      padding: EdgeInsets.only(bottom: 32),
    );
  }

  Widget _itemQuantityInput() => TextFormField(
        decoration: const InputDecoration(
          hintText: '5',
          labelText: 'Quantity',
        ),
        initialValue: _itemInitialValue(),
        validator: _quantityValid,
        onSaved: _onQuantitySaved,
      );

  String _itemInitialValue() {
    if (item.quantity == null) {
      return '';
    } else {
      return item.quantity.toString();
    }
  }

  String _quantityValid(String inputValue) {
    if (inputValue.isEmpty) {
      return 'Quantity cannot be empty';
    } else if ((int.parse(inputValue) <= 0)) {
      return 'Quantity has to be more than 0';
    } else {
      return null;
    }
  }

  void _onQuantitySaved(String inputValue) {
    item.quantity = int.parse(inputValue);
  }

  Padding _quantityPadding() {
    return Padding(
      padding: EdgeInsets.only(bottom: 64),
    );
  }

  Widget _saveButton() {
    return ButtonTheme(
      minWidth: double.infinity,
      padding: const EdgeInsets.all(16),
      child: RaisedButton(
        onPressed: _submitForm,
        child: const Text('SAVE',
            style: TextStyle(fontSize: 23, color: Colors.white)),
      ),
    );
  }

  void _submitForm() {
    if (_formValid()) {
      _formKey.currentState.save();

      final itemBloc = ItemProvider.of(_formKey.currentContext);
      itemBloc.addItem.add(item);

      Navigator.pop(_formKey.currentContext);
    }
  }

  bool _formValid() {
    return _formKey.currentState.validate();
  }
}
