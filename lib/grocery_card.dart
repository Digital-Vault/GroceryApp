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
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailedPage(item: item)));
        },
        child: Container(
          child: Center(
              child: Column(
            // Stretch the cards in horizontal axis
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                // Read the name field value and set it in the Text widget
                item.name,
                // set some style to text
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              Text(
                // Read the name field value and set it in the Text widget
                "Quantity: " + item.quantity.toString(),
                // set some style to text
                style: TextStyle(fontSize: 20.0, color: Colors.grey),
              ),
            ],
          )),
          padding: const EdgeInsets.all(15.0),
        ),
      ),
    );
  }
}
