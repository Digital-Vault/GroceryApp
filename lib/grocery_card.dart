import 'package:flutter/material.dart';
import 'package:grocery_app/grocery_item.dart';

import 'detailed_page.dart';

class GroceryCard extends StatelessWidget {
  final GroceryItem item;

  GroceryCard({Key key, @required this.item})
      : assert(item != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailedPage(item: item),
            ),
          );
        },
        child: _buildTile(context),
      ),
    );
  }

  Widget _buildTile(BuildContext context) {
    return ListTile(
      trailing: RaisedButton(
      child: Icon(Icons.delete, color: Colors.white,),
      color: Colors.red,
      shape: CircleBorder(),
      onPressed: () {
        confirmItemDeletion(context);
      },),
      leading: Text("${item.quantity}x"),
      title: Text(
        item.name,
      ),
    );
  }

  void confirmItemDeletion(BuildContext context) {
    var confirmationDialog = AlertDialog(
      title: Text("Delete This Item?"),
      content: Text("Are you sure you want to delete this item? ${item.name} Quantity: ${item.quantity}x"),
      actions: <Widget>[
        FlatButton(
          child: Text("Yeet it"),
          onPressed: () {
            //delete functionality here...
          },
        ),
        FlatButton(
          child: Text("Nah, fam"),
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
      }
    );
  }
}
