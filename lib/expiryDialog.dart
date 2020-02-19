import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:grocery_app/custom_localization.dart';
import 'package:grocery_app/date_util.dart';
import 'package:grocery_app/grocery_item.dart';
import 'package:grocery_app/firestore_provider.dart';
import 'package:intl/intl.dart';

import 'firestore_provider.dart';
import 'notification_util.dart';

class ExpiryDialog extends StatefulWidget {
  ExpiryDialog({@required this.item});
  final DocumentSnapshot item;

  @override
  _ExpiryDialogState createState() => _ExpiryDialogState(item: item);
}

class _ExpiryDialogState extends State<ExpiryDialog> {
  _ExpiryDialogState({this.item});
  TextEditingController _notifyTextFieldController = TextEditingController();
  IconButton _notifyClearIcon;
  DateTime _expiryDate;
  int _notifyDays;
  DocumentSnapshot item;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _notifyTextFieldController.addListener(_showNotifyIconButton);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(CustomLocalizations.of(context).dateDialogTitle),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: dateInput(label: "Expiry Date", onSaved: _onExpirySaved),
            ),
            Padding(
                padding: EdgeInsets.all(8.0), child: _notifyDaysBeforeExpiry()),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(CustomLocalizations.of(context).dateDialogSubmit),
          onPressed: _submitForm,
        ),
      ],
    );
  }

  void _onExpirySaved(DateTime date) {
    this._expiryDate = date;
  }

  Widget _notifyDaysBeforeExpiry() {
    return TextFormField(
      onSaved: _onNotifySaved,
      controller: _notifyTextFieldController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: '5',
        labelText: "Notify days before",
        suffixIcon: _notifyClearIcon,
      ),
    );
  }

  void _onNotifySaved(String notifyDays) {
    _notifyDays = int.tryParse(notifyDays);
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

  void _submitForm() async {
    final firestore = FirestoreProvider.of(context);
    if (_formValid()) {
      _formKey.currentState.save();
      GroceryItem updatedItem = GroceryItem.fromJson(item.data);

      updatedItem.expiryDate = _expiryDate;
      updatedItem.notifyDate = _notifyDays;
      var docRef =
          await firestore.collection('fridge_list').add(updatedItem.toJson());

      await scheduleExpiryNotification(updatedItem.notifyDate,
          updatedItem.expiryDate, updatedItem.name, docRef.documentID);
      Navigator.pop(_formKey.currentContext);
    }
  }

  bool _formValid() {
    return _formKey.currentState.validate();
  }
}
