import 'package:flutter/material.dart';
import 'package:grocery_app/detail_card.dart';
import 'package:grocery_app/grocery_item.dart';

class DetailedPage extends StatelessWidget {
  final GroceryItem item;
  DetailedPage({this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${item.name} Details'),
        ),
        body: Column(children: <Widget>[
          DetailCard(
            item: item,
          ),
          RaisedButton(
            child: Text(
              "Delete Item",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.red,
            onPressed: () {
              confirmItemDeletion(context);
            },
          )
        ]));
  }

  void confirmItemDeletion(BuildContext context) {
    var confirmationDialog = AlertDialog(
      title: Text("Delete This Item?"),
      content: Text(
          "Are you sure you want to delete this item? ${item.name} Quantity: ${item.quantity}x"),
      actions: <Widget>[
        FlatButton(
          child: Text("Yes", style: TextStyle(color: Colors.green),),
          onPressed: () {
            //delete functionality here...
          },
        ),
        FlatButton(
            child: Text("No", style: TextStyle(color: Colors.red),),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return confirmationDialog;
        });
  }
}
