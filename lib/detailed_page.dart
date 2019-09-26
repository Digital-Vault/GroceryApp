import 'package:flutter/material.dart';
import 'package:grocery_app/grocery_item.dart';

class DetailedPage extends StatelessWidget {
  final GroceryItem item;
  DetailedPage({this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detailed Page'),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            child: Text(item.name),
          ),
          Expanded(
            child: Text(item.quantity.toString()),
          ),
          Expanded(
            child: Text(item.expiryDate.toString()),
          )
        ],
      ),
    );
  }
}
