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
        child: _buildTile(),
      ),
    );
  }

  Widget _buildTile() {
    return ListTile(
      trailing: Text("${item.quantity}x"),
      title: Text(
        item.name,
      ),
    );
  }
}
