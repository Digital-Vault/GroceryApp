import 'package:flutter/material.dart';
import 'package:grocery_app/detailed_page.dart';
import 'package:grocery_app/grocery_item.dart';
import 'package:grocery_app/main.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:grocery_app/item_provider.dart';

class SubmissionForm extends StatefulWidget {
  final GroceryItem item;
  SubmissionForm({this.item});
  @override
  _SubmissionFormState createState() => _SubmissionFormState(item: item);
}

class _SubmissionFormState extends State<SubmissionForm> {
  GroceryItem item;
  _SubmissionFormState({this.item});
  final formKey = GlobalKey<FormState>();
  String _name;
  final format = DateFormat("yyyy-MM-dd");
  DateTime _date;
  String _appBarTitle;
  var sliderValue = 1.0;
  @override
  Widget build(BuildContext context) {
    if (item == null) {
      _appBarTitle = "Add Item";
      item = GroceryItem(name: "", expiryDate: DateTime.now());
    } else {
      _appBarTitle = "Update Item";
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(_appBarTitle),
        ),
        body: Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(

                    initialValue: item.name,
                    decoration: InputDecoration(labelText: 'Item Name:'),
                    validator: (input) => input.isEmpty ? 'Name must be entered' : null,
                    onSaved: (input) => _name = input,
                  ),

              DateTimeField(
                    format: format,
                    initialValue: item.expiryDate,
                    decoration: InputDecoration(labelText: 'Date'),
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                    },
                    validator: (input) => input.toString() == "null" ? 'Date must be entered' : null,
                    onSaved: (input) => _date = input,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:  Slider(
                      min: 1.0,
                      max: 50.0,
                      divisions: 100,
                      value: sliderValue,
                      label: 'Quantity',
                      onChanged: (newValue){
                        setState(() {
                          sliderValue = newValue;
                        });

                      },
                    ),
                  ),


                  Text("Quantity : ${sliderValue.round()}",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: _submit,
                          child: Text('Save'),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void _submit() {
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      final itemBloc = ItemProvider.of(context);

      GroceryItem EditedItem = GroceryItem(
        name: _name,
        expiryDate: _date,
        quantity: sliderValue.round(),
        purchased: false,
      );
      itemBloc.addItem.add(EditedItem);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyApp(),
        ),
      );
    }

  }
}
