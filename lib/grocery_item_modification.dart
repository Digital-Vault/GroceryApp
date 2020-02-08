import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/custom_localization.dart';
import 'package:grocery_app/firestore_provider.dart';
import 'package:grocery_app/grocery_item.dart';

class GroceryItemModification extends StatefulWidget {
  GroceryItemModification({this.document});

  final DocumentSnapshot document;

  @override
  _GroceryItemModificationState createState() =>
      _GroceryItemModificationState(document: document);
}

class _GroceryItemModificationState extends State<GroceryItemModification> {
  _GroceryItemModificationState({this.document});

  TextEditingController _nameTextFieldController = TextEditingController();
  TextEditingController _qtyTextFieldController = TextEditingController();
  IconButton _nameClearIcon;
  IconButton _qtyClearIcon;
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

    super.initState();
  }

  void _loadTextValues() {
    _nameTextFieldController.text = _item.name;
    _qtyTextFieldController.text = _item.quantity.toString();
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
            _namePadding(),
            _itemQuantityInput(),
            _quantityPadding(),
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

  Padding _namePadding() {
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

  Padding _quantityPadding() {
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
