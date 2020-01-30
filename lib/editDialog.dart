import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:grocery_app/grocery_item.dart';

import 'date_util.dart';

class ExpiryDialog extends StatefulWidget {
  ExpiryDialog({@required this.item});
  final GroceryItem item;

  @override
  _ExpiryDialogState createState() => _ExpiryDialogState(item: item);
}

class _ExpiryDialogState extends State<ExpiryDialog> {
  _ExpiryDialogState({this.item});
  String text = "No expiry date";
  DateTime expiryDate;
  int notifyDays;

  GroceryItem item;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Please enter in expiry date and notification time"),
      content: Container(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(children: <Widget>[
              Text(
                'Enter in expiry date: ',
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 0,
                ),
              ),
              RaisedButton(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 0,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                elevation: 4.0,
                color: Colors.blue[200],
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime(2000, 1, 1),
                      maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                    expiryDate = date;
                    setState(() {
                      text = dateFormatYMMDToString(date);
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
              )
            ]),
            Row(children: <Widget>[
              Text(
                'Notify me: ',
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 0,
                ),
              ),
              Expanded(
                child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    onSubmitted: (val) {
                      notifyDays = int.parse(val);
                    }),
              )
            ])
          ],
        ),
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: Text("Submit"),
          onPressed: () {
            item.expiryDate = expiryDate;
            item.notifyDate = notifyDays;
            Navigator.of(context).pop(item);
          },
        ),
      ],
    );
  }
}
