import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/custom_localization.dart';
import 'package:grocery_app/firestore_provider.dart';
import 'package:grocery_app/grocery_item.dart';
import 'package:intl/intl.dart';

import 'date_util.dart';

class SubmissionForm extends StatefulWidget {
  SubmissionForm({this.document});

  final DocumentSnapshot document;

  @override
  _SubmissionFormState createState() =>
      _SubmissionFormState(document: document);
}

class _SubmissionFormState extends State<SubmissionForm> {
  _SubmissionFormState({this.document});

  TextEditingController _nameTextFieldController = TextEditingController();
  TextEditingController _qtyTextFieldController = TextEditingController();
  TextEditingController _notifyTextFieldController = TextEditingController();
  IconButton _nameClearIcon;
  IconButton _qtyClearIcon;
  IconButton _notifyClearIcon;
  DocumentSnapshot document;
  GroceryItem _item;
  CustomLocalizations _translator;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (_newItem()) {
      _item = GroceryItem();
    } else {
      _item = GroceryItem.fromJson(document.data);
      _loadTextValues();
    }

    _nameTextFieldController.addListener(_showNameIconButton);
    _qtyTextFieldController.addListener(_showQtyIconButton);
    _notifyTextFieldController.addListener(_showNotifyIconButton);

    super.initState();
  }

  void _loadTextValues() {
    _nameTextFieldController.text = _item.name;
    _qtyTextFieldController.text = _item.quantity.toString();

    if (_item.notifyDate != null) {
      log(_item.toString());
      _notifyTextFieldController.text = _item.notifyDate.toString();
    }
  }

  @override
  void didChangeDependencies() {
    _translator = CustomLocalizations.of(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
      return _translator.addItemNewTile;
    } else {
      return '${_translator.addItemExistingTile} ${_item.name}';
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
            _padding(),
            _itemQuantityInput(),
            _padding(),
            dateInput(label: "Expiry Date", onSaved: _onExpirySaved),
            _padding(),
            _notifyDaysBeforeExpiry(),
            _extraPadding(),
            _saveButton(),
          ],
        ),
      );

  Widget _itemNameInput() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: _translator.addItemNameHint,
        labelText: _translator.addItemNameLabel,
        suffixIcon: _nameClearIcon,
      ),
      controller: _nameTextFieldController,
      validator: _nameValid,
      onSaved: _onNameSaved,
    );
  }

  String _nameValid(String inputValue) {
    if (inputValue.isEmpty) {
      return _translator.addItemNameEmpty;
    } else {
      return null;
    }
  }

  void _onNameSaved(String inputValue) {
    _item.name = inputValue;
  }

  Padding _padding() {
    return Padding(
      padding: EdgeInsets.only(bottom: 32),
    );
  }

  void _showNameIconButton() {
    void _onClear() {
      setState(() {
        _nameTextFieldController.text = "";
        _nameClearIcon = null;
      });
    }

    if (_nameTextFieldController.text.isNotEmpty) {
      setState(() {
        _nameClearIcon = IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => _onClear(),
        );
      });
    }
  }

  Widget _itemQuantityInput() {
    return TextFormField(
      validator: _quantityValid,
      onSaved: _onQuantitySaved,
      controller: _qtyTextFieldController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: _translator.addItemQuantityHint,
        labelText: _translator.addItemQuantityLabel,
        suffixIcon: _qtyClearIcon,
      ),
    );
  }

  void _onQuantitySaved(String inputValue) {
    _item.quantity = int.parse(inputValue);
  }

  Padding _extraPadding() {
    return Padding(
      padding: EdgeInsets.only(bottom: 64),
    );
  }

  String _quantityValid(String inputValue) {
    if (inputValue.isEmpty) {
      return _translator.addItemQuantityEmpty;
    } else if ((int.parse(inputValue) <= 0)) {
      return _translator.addItemQuantityZero;
    } else {
      return null;
    }
  }

  void _showQtyIconButton() {
    void _onClear() {
      setState(() {
        _qtyTextFieldController.text = "";
        _qtyClearIcon = null;
      });
    }

    if (_qtyTextFieldController.text.isNotEmpty) {
      setState(() {
        _qtyClearIcon = IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => _onClear(),
        );
      });
    }
  }

  Widget _expiryDateInput() {
    return DateTimeField(
      decoration: InputDecoration(
        labelText: _translator.addItemExpiry,
      ),
      format: DateFormat.yMMMd(),
      initialValue: _item.expiryDate,
      onShowPicker: (context, currentValue) async {
        final today = DateTime.now();

        return showDatePicker(
          context: context,
          firstDate: currentValue ?? today,
          initialDate: currentValue ?? today,
          lastDate: DateTime(2100),
        );
      },
      onSaved: _onExpirySaved,
    );
  }

  void _onExpirySaved(DateTime inputValue) {
    _item.expiryDate = inputValue;
  }

// TODO: provide default values notifyDaysBeforeExpiry

  Widget _notifyDaysBeforeExpiry() {
    return TextFormField(
      onSaved: _onNotifySaved,
      controller: _notifyTextFieldController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: '5',
        labelText: _translator.addItemNotification,
        suffixIcon: _notifyClearIcon,
      ),
    );
  }

  void _showNotifyIconButton() {
    void _onClear() {
      setState(() {
        _notifyTextFieldController.text = "";
        _notifyClearIcon = null;
      });
    }

    if (_notifyTextFieldController.text.isNotEmpty) {
      setState(() {
        _notifyClearIcon = IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => _onClear(),
        );
      });
    }
  }

  void _onNotifySaved(String inputValue) {
    _item.notifyDate = int.tryParse(inputValue);
  }

  Widget _saveButton() {
    return ButtonTheme(
      minWidth: double.infinity,
      padding: const EdgeInsets.all(16),
      child: RaisedButton(
        onPressed: _submitForm,
        child: Text(
          _translator.addItemSave.toUpperCase(),
          style: TextStyle(fontSize: 23, color: Colors.white),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formValid()) {
      _formKey.currentState.save();

      _updateDatabase();

      Navigator.pop(_formKey.currentContext, setState(() {}));
    }
  }

  bool _formValid() {
    return _formKey.currentState.validate();
  }

  void _updateDatabase() {
    final firestore = FirestoreProvider.of(context);
    final jsonItem = _item.toJson();

    if (_newItem()) {
      firestore.collection('user1_list').add(jsonItem);
    } else {
      document.reference.updateData(jsonItem);
    }
  }
}
