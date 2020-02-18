import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String dateFormatYMMDToString(DateTime date) {
  return DateFormat.yMMMd().format(date);
}

Widget dateInput({label, onSaved}) {
  return DateTimeField(
    decoration: InputDecoration(
      labelText: "Expiry Date",
    ),
    format: DateFormat.yMMMd(),
    onShowPicker: (context, currentValue) async {
      final today = DateTime.now();

      return showDatePicker(
        context: context,
        firstDate: currentValue ?? today,
        initialDate: currentValue ?? today,
        lastDate: DateTime(2100),
      );
    },
    onSaved: onSaved,
  );
}
