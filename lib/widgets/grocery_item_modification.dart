import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'custom_localization.dart';
import 'firestore_provider.dart';
import '../models/grocery_item.dart';

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
  String _storeValue;
  final List<String> _stores = [
    'Walmart',
    'Shoppers',
    'Lablaw',
    'Sobeys',
    'Metro'
  ];
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
    _storeValue = _item.store;
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
      padding: EdgeInsets.all(32),
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
            _storeInput(),
            _lastItemPadding(),
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

  Widget _storeInput() {
    return DropdownButtonFormField(
      value: _storeValue,
      hint: Text('store'),
      icon: Icon(Icons.arrow_downward),
      onSaved: _onStoreSave,
      onChanged: (String newValue) {
        setState(() {
          _storeValue = newValue;
        });
      },
      items: _stores.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  void _onStoreSave(String store) {
    _item.store = store;
  }

  Padding _lastItemPadding() {
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

  void _updateDatabase() async {
    final _firestore = FirestoreProvider.of(context);
    final jsonItem = _item.toJson();
    if (_newItem()) {
      bool isDup = await _isDuplicateItem(jsonItem["name"], jsonItem);
      if (!isDup) {
        final user = await FirebaseAuth.instance.currentUser();
        final collectionName = await _findGroceryCollectionName(user.uid);
        await _firestore.collection(collectionName).add(jsonItem);
      }
    } else {
      await document.reference.updateData(jsonItem);
    }
  }

  Future<bool> _isDuplicateItem(
      String itemName, Map<String, dynamic> jsonItem) async {
    final _firestore = FirestoreProvider.of(context);
    QuerySnapshot queryList =
        await _firestore.collection('user1_list').getDocuments();
    var GroceryItems = queryList.documents;
    for (int i = 0; i < GroceryItems.length; i++) {
      if (GroceryItems[i].data["name"] == itemName) {
        await GroceryItems[i].reference.updateData({
          'quantity': GroceryItems[i].data["quantity"] + jsonItem["quantity"]
        });
        return true;
      }
    }
    return false;
  }

  Future<String> _findGroceryCollectionName(String id) async {
    final firestore = FirestoreProvider.of(_formKey.currentContext);

    var users = await firestore
        .collection('user_information')
        .where('uid', isEqualTo: id)
        .getDocuments();

    var currentUser = users.documents.first;
    return currentUser.data['groceryList'];
  }
}
