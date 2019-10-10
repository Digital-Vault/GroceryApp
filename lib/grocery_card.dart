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
    return Dismissible(
      key: ObjectKey(item.name),
      background: deleteGroceryBackground(),
      child: ListTile(
        trailing: Text("${item.quantity}x"),
        title: Text(
          item.name,
        ),
      ),
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
}
