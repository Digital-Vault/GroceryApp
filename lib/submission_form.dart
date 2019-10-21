import 'package:flutter/material.dart';
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
  _SubmissionFormState({this.item});

  GroceryItem item;
  String _itemName;
  num _itemQty;
  DateTime _itemExpDate;
  bool _datePicked = false;
  final String _dateFormat = "yyyy-MM-dd";
  String _appBarTitle;
  final myController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var _sliderValue = 1.0;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

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
        body: _formCard(context));
  }

  Widget _formCard(BuildContext context) => Card(
        child: Padding(padding: EdgeInsets.all(8.0), child: _form()),
      );

  Widget _form() => Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _itemNameInput(),
            _itemQuantityInput(),
            _itemExpiryDate(),
            _saveButtonRow(),
          ],
        ),
      );

  Widget _itemNameInput() => TextFormField(
        initialValue: item.name,
        decoration: InputDecoration(hintText: 'Item Name:'),
        validator: (input) => input.isEmpty ? 'Name must be entered' : null,
        onSaved: (input) => _itemName = input,
      );

  Widget _itemQuantityInput() => TextFormField(
        initialValue: item.quantity.toString(),
        decoration: InputDecoration(hintText: 'Quantity:'),
        validator: (input) {
          if (input.isEmpty) {
            return ('Quantity cannot be empty');
          } else if (int.parse(input) <= 0) {
            return ("Quantity has to be more than 0");
          } else {
            return null;
          }
        },
        onSaved: (input) => _itemQty = int.parse(input),
      );

  Widget _itemExpiryDate() {
    if (!_datePicked) {
      _itemExpDate = item.expiryDate;
    }
    myController.text = DateFormat(_dateFormat).format(_itemExpDate);

    Future _selectDate() async {
      DateTime picked = await showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          initialDate: DateTime.now(),
          lastDate: DateTime(2100));
      if (picked != null) {
        setState(() {
          _itemExpDate = picked;
          _datePicked = true;
        });
      }
    }

    print(_itemExpDate);
    InkWell inkWell = InkWell(
      onTap: _selectDate,
      child: IgnorePointer(
        child: TextFormField(
          controller: myController,
          // initialValue: DateFormat(_dateFormat).format(_itemExpDate),
          decoration: InputDecoration(hintText: "Expiry date"),
          onSaved: (String val) {},
        ),
      ),
    );

    return inkWell;
  }

  Widget _saveButtonRow() => Row(
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
      );

  void _submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      final itemBloc = ItemProvider.of(context);

      GroceryItem EditedItem = GroceryItem(
        name: _itemName,
        expiryDate: _itemExpDate,
        quantity: _itemQty,
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
