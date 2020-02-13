import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/custom_localization.dart';
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
  TextEditingController _notifyTextFieldController = TextEditingController();
  IconButton _nameClearIcon;
  IconButton _qtyClearIcon;
  IconButton _notifyClearIcon;
  DocumentSnapshot document;
  GroceryItem _item;
  final _formKey = GlobalKey<FormState>();
  Firestore _firestore;

  @override
  void initState() {
    if (_newItem()) {
      _item = GroceryItem();
    } else {
      _item = GroceryItem.fromJson(document.data);
      _nameTextFieldController.text = _item.name;
      _qtyTextFieldController.text = _item.quantity.toString();
      _notifyTextFieldController.text = _item.notifyDate.toString();
    }

    _nameTextFieldController.addListener(() {
      showNameIconButton();
    });

    _qtyTextFieldController.addListener(() {
      showQtyIconButton();
    });

    _notifyTextFieldController.addListener(() {
      showNotifyIconButton();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _firestore = FirestoreProvider.of(context);

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
            _expiryDateInput(),
            _namePadding(),
            _notifyDaysBeforeExpiry(),
            _quantityPadding(),
            _saveButton(),
          ],
        ),
      );

/////////////////////////////////////////////////////////////
  /// ******** Item Name Input Functionalities ******** ///
/////////////////////////////////////////////////////////////
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

/////////////////////////////////////////////////////////////
  /// ****** Item Quantity Input Functionalities ******** ///
/////////////////////////////////////////////////////////////

  Widget _itemQuantityInput() {
    return TextFormField(
      validator: _quantityValid,
      onSaved: _onQuantitySaved,
      controller: _qtyTextFieldController,
      decoration: InputDecoration(
        hintText: CustomLocalizations.of(context).addItemQuantityHint,
        labelText: CustomLocalizations.of(context).addItemQuantityLabel,
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
      return CustomLocalizations.of(context).addItemQuantityEmpty;
    } else if ((int.parse(inputValue) <= 0)) {
      return CustomLocalizations.of(context).addItemQuantityZero;
    } else {
      return null;
    }
  }

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

/////////////////////////////////////////////////////////////
  /// ****** Item Expiry Input Functionalities ******** ///
/////////////////////////////////////////////////////////////

  Widget _expiryDateInput() {
    return DateTimeField(
      decoration: InputDecoration(
        labelText: CustomLocalizations.of(context).addItemExpiry,
      ),
      format: DateFormat.yMMMd(),
      initialValue: _item.expiryDate ?? DateTime.now(),
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

  void _onExpirySaved(DateTime inputValue) {
    _item.expiryDate = inputValue;
  }

////////////////////////////////////////////////////////////////////
  /// *** Notify Days Before Expiry Input Functionalities **** ///
////////////////////////////////////////////////////////////////////

// TODO: provide default values notifyDaysBeforeExpiry

  Widget _notifyDaysBeforeExpiry() {
    return TextFormField(
      onSaved: _onNotifySaved,
      controller: _notifyTextFieldController,
      decoration: InputDecoration(
        hintText: '5',
        labelText: CustomLocalizations.of(context).addItemNotification,
        suffixIcon: _notifyClearIcon,
      ),
    );
  }

  // String _notifyDaysBeforeExpiryValid(String inputValue) {
  //   if (inputValue.isEmpty) {
  //     return CustomLocalizations.of(context).addItemQuantityEmpty;
  //   } else if ((int.parse(inputValue) <= 0)) {
  //     return CustomLocalizations.of(context).addItemQuantityZero;
  //   } else {
  //     return null;
  //   }
  // }

  void showNotifyIconButton() {
    void _onClear() {
      setState(() {
        _notifyTextFieldController.text = "";
        _notifyClearIcon = null;
      });
    }

    if (_notifyTextFieldController.text != "") {
      setState(() {
        _notifyClearIcon = IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => _onClear(),
        );
      });
    }
  }

  void _onNotifySaved(String inputValue) {
    _item.notifyDate = int.parse(inputValue);
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

      Navigator.pop(_formKey.currentContext, setState(() {}));
    }
  }

  bool _formValid() {
    return _formKey.currentState.validate();
  }

  void _updateDatabase() async {
    final jsonItem = _item.toJson();
    if (_newItem()) {
      bool isDup = await _isDuplicateItem(jsonItem["name"]);
      if (!isDup) {
        await _firestore.collection('user1_list').add(jsonItem);
      }
    } else {
      await document.reference.updateData(jsonItem);
    }
  }

  Future<bool> _isDuplicateItem(String itemName) async {
    QuerySnapshot queryList =
        await _firestore.collection('user1_list').getDocuments();
    var GroceryItems = queryList.documents;
    for (int i = 0; i < GroceryItems.length; i++) {
      if (GroceryItems[i].data["name"] == itemName) {
        return true;
      }
    }
    return false;
  }
}
