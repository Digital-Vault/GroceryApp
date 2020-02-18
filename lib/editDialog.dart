import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:grocery_app/custom_localization.dart';
import 'package:grocery_app/date_util.dart';
import 'package:grocery_app/grocery_item.dart';

class ExpiryDialog extends StatefulWidget {
  ExpiryDialog({@required this.item});
  final GroceryItem item;

  @override
  _ExpiryDialogState createState() => _ExpiryDialogState(item: item);
}

class _ExpiryDialogState extends State<ExpiryDialog> {
  _ExpiryDialogState({this.item});
  TextEditingController _notifyTextFieldController = TextEditingController();
  IconButton _notifyClearIcon;
  DateTime _expiryDate;
  int _notifyDays;
  CustomLocalizations _translator;

  @override
  void initState() {
    _notifyTextFieldController.addListener(_showNotifyIconButton);

    super.initState();
  }

  GroceryItem item;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(CustomLocalizations.of(context).dateDialogTitle),
      content: Container(
          width: double.maxFinite,
          child: ListView(shrinkWrap: true, children: <Widget>[
            dateInput(label: "Expiry Date", onSaved: _onExpirySaved),
            Padding(
              padding: EdgeInsets.only(bottom: 32),
            ),
            _notifyDaysBeforeExpiry()
          ])),
      actions: <Widget>[
        FlatButton(
          child: Text(CustomLocalizations.of(context).dateDialogSubmit),
          onPressed: () {
            item.expiryDate = _expiryDate;
            item.notifyDate = _notifyDays;
            Navigator.of(context).pop(item);
          },
        ),
      ],
    );
  }

  void _onExpirySaved(DateTime date) {
    _expiryDate = date;
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

  void _onNotifySaved(String notifyDays) {
    _notifyDays = int.tryParse(notifyDays);
  }
}
