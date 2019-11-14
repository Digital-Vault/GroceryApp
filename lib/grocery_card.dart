import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/grocery_item.dart';
import 'package:grocery_app/item_provider.dart';

class GroceryCard extends StatelessWidget {
  final DocumentSnapshot item;

  GroceryCard({Key key, @required this.item})
      : assert(item != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => DetailedPage(item: item),
          //   ),
          // );
        },
        child: _buildTile(context),
      ),
    );
  }

  Widget _buildTile(BuildContext context) {
    return Dismissible(
      key: ObjectKey(item['name']),
      background: deleteGroceryBackground(),
      child: ListTile(
        trailing: Text("${item['quantity']}x"),
        title: Text(
          item['name'],
        ),
      ),
      onDismissed: (direction) {
        // deleteGroceryItem(context, item);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Deleted ${item['name']}!"),
          action: SnackBarAction(
            label: "UNDO",
            onPressed: () {
              // restoreGroceryItem(context, item);
            },
          ),
        ));
      },
    );
  }

  Widget deleteGroceryBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  void deleteGroceryItem(BuildContext context, GroceryItem item) {
    final itemBloc = ItemProvider.of(context);
    itemBloc.removeItem.add(item);
  }

  void restoreGroceryItem(BuildContext context, GroceryItem item) {
    final itemBloc = ItemProvider.of(context);
    itemBloc.addItem.add(item);
  }
}
