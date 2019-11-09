import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/firestore_provider.dart';
import 'package:grocery_app/grocery_item.dart';

class SubmissionForm extends StatefulWidget {
  SubmissionForm({this.document});

  final DocumentSnapshot document;

  @override
  _SubmissionFormState createState() =>
      _SubmissionFormState(document: document);
}

class _SubmissionFormState extends State<SubmissionForm> {
  _SubmissionFormState({this.document});

  DocumentSnapshot document;
  GroceryItem _item;
  final _formKey = GlobalKey<FormState>();
  Firestore _firestore;

  @override
  Widget build(BuildContext context) {
    _firestore = FirestoreProvider.of(context);

    if (_newItem()) {
      _item = GroceryItem();
    } else {
      _item = GroceryItem.fromJson(document.data);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle()),
      ),
      body: _formBody(),
    );
  }

  bool _newItem() {
    return document == null;
  }

  String _appBarTitle() {
    if (_newItem()) {
      return 'Add New Item';
    } else {
      return 'Edit ${_item.name}';
    }
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
      initialValue: _item.name,
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
    _item.name = inputValue;
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
    if (_item.quantity == null) {
      return '';
    } else {
      return _item.quantity.toString();
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
    _item.quantity = int.parse(inputValue);
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
        child: const Text(
          'SAVE',
          style: TextStyle(fontSize: 23, color: Colors.white),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formValid()) {
      _formKey.currentState.save();

      _updateDatabase();

      Navigator.pop(_formKey.currentContext);
    }
  }

  bool _formValid() {
    return _formKey.currentState.validate();
  }

  void _updateDatabase() {
    final jsonItem = _item.toJson();

    if (_newItem()) {
      _firestore.collection('user1_list').add(jsonItem);
    } else {
      document.reference.updateData(jsonItem);
    }
  }
}
