import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

typedef void VoidCallback();

class ExpiryDialog extends StatelessWidget {
  ExpiryDialog({this.onSubmitButton});

  final void Function(DateTime, int) onSubmitButton;

  @override
  Widget build(BuildContext context) {
    DateTime expiryDate;
    int notifyDays;

    return AlertDialog(
      title: Text("Alert Dialog title"),
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
                  "No expiry date",
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
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
              )
            ]),
            Row(children: <Widget>[
              Text(
                'Enter in expiry date: ',
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
            onSubmitButton(expiryDate, notifyDays);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
