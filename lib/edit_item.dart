import 'package:flutter/material.dart';
import 'package:grocery_app/detailed_page.dart';
import 'package:grocery_app/grocery_item.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:grocery_app/item_provider.dart';
class EditForm extends StatefulWidget {
  final GroceryItem item;
  EditForm({this.item});
  @override
  _EditFormState createState() =>  _EditFormState(item: item);
}


class _EditFormState extends State<EditForm> {
  final GroceryItem item;
  _EditFormState({this.item});
  final formKey = GlobalKey<FormState>();
  String _name;
  num _quantity;
  final format = DateFormat("yyyy-MM-dd");
  DateTime _date;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text('Update Item '),

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
                    decoration: InputDecoration(
                        labelText: 'Item Name:'
                    ),
                    onSaved: (input) => _name = input,
                  ),
                  TextFormField(
                    initialValue: item.quantity.toString(),
                    decoration: InputDecoration(
                        labelText: 'Quantity:'
                    ),
                    onSaved: (input) => _quantity = int.parse(input),
                  ),
                  DateTimeField(
                    format: format,
                    initialValue: item.expiryDate,
                    decoration: InputDecoration(
                      labelText: 'Date'
                    ),
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                    },
                    onSaved: (input) => _date = input,
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

  void _submit(){
    formKey.currentState.save();
    final itemBloc = ItemProvider.of(context);

    GroceryItem EditedItem = GroceryItem(
      name: _name,
      expiryDate: _date,
      quantity: _quantity,
      purchased: false,
    );
    itemBloc.addItem.add( EditedItem);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedPage(item: EditedItem),
      ),
    );

  }
}
