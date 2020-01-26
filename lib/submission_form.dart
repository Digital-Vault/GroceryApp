import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/custom_localization.dart';
import 'package:grocery_app/date_util.dart';
import 'package:grocery_app/firestore_provider.dart';
import 'package:grocery_app/grocery_item.dart';
import 'package:intl/intl.dart';

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
  IconButton _nameClearIcon;
  IconButton _qtyClearIcon;
  DocumentSnapshot document;
  GroceryItem _item;
  final _formKey = GlobalKey<FormState>();
  Firestore _firestore;

  @override
  void initState() {
    _qtyTextFieldController.addListener(() {
      showQtyIconButton();
    });

    _nameTextFieldController.addListener(() {
      showNameIconButton();
    });
    super.initState();
  }

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
      return CustomLocalizations.of(context).addItemNewTile;
    } else {
      return '${CustomLocalizations.of(context).addItemExistingTile} ${_item.name}';
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
            _namePadding(),
            _expiryDate(),
            _quantityPadding(),
            _saveButton(),
          ],
        ),
      );

  Widget _itemNameInput() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: CustomLocalizations.of(context).addItemNameHint,
        labelText: CustomLocalizations.of(context).addItemNameLabel,
        suffixIcon: _nameClearIcon,
      ),
      controller: _nameTextFieldController,
      validator: _nameValid,
      onSaved: _onNameSaved,
    );
  }

  String _nameValid(String inputValue) {
    if (inputValue.isEmpty) {
      return CustomLocalizations.of(context).addItemNameEmpty;
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
        decoration: InputDecoration(
          hintText: CustomLocalizations.of(context).addItemQuantityHint,
          labelText: CustomLocalizations.of(context).addItemQuantityLabel,
          suffixIcon: _qtyClearIcon,
        ),
        controller: _qtyTextFieldController,
        validator: _quantityValid,
        onSaved: _onQuantitySaved,
      );

  void showQtyIconButton() {
    void _onClear() {
      setState(() {
        _qtyTextFieldController.text = "";
        _qtyClearIcon = null;
      });
    }

    if (_qtyTextFieldController.text != "") {
      setState(() {
        _qtyClearIcon = IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => _onClear(),
        );
      });
    }
  }

  void showNameIconButton() {
    void _onClear() {
      setState(() {
        _nameTextFieldController.text = "";
        _nameClearIcon = null;
      });
    }

    if (_nameTextFieldController.text != "") {
      setState(() {
        _nameClearIcon = IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => _onClear(),
        );
      });
    }
  }

  // Widget _expiryDate() => BasicDateField();
  Widget _expiryDate() {
    DateTime picked;
    return DateTimeField(
      decoration: const InputDecoration(
        labelText: 'Expiry Date',
      ),
      format: DateFormat.yMMMd(),
      onShowPicker: (context, currentValue) async {
        return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
      },
      onSaved: (val) => {_onExpirySaved(val)},
    );
  }

  String _itemInitialValue() {
    if (_item.quantity == null) {
      return '';
    } else {
      return _item.quantity.toString();
    }
  }

  String _quantityValid(String inputValue) {
    if (inputValue.isEmpty) {
      return CustomLocalizations.of(context).addItemQuantityEmpty;
    } else if ((int.parse(inputValue) <= 0)) {
      return CustomLocalizations.of(context).addItemQuantityZero;
    } else {
      return null;
    }
  }

  void _onQuantitySaved(String inputValue) {
    _item.quantity = int.parse(inputValue);
  }

  void _onExpirySaved(DateTime inputValue) {
    _item.expiryDate = inputValue;
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
        child: Text(
          CustomLocalizations.of(context).addItemSave.toUpperCase(),
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
