import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/detailed_page.dart';
import 'package:grocery_app/grocery_item.dart';

class GroceryList extends StatelessWidget {
  final List<GroceryItem> grocery;
  GroceryList({Key key, this.grocery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: grocery == null ? 0 : grocery.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DetailedPage(item: grocery[index])));
              },
              child: Container(
                child: Center(
                    child: Column(
                  // Stretch the cards in horizontal axis
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      // Read the name field value and set it in the Text widget
                      grocery[index].name,
                      // set some style to text
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                    Text(
                      // Read the name field value and set it in the Text widget
                      "Quantity: " + grocery[index].quantity.toString(),
                      // set some style to text
                      style: TextStyle(fontSize: 20.0, color: Colors.grey),
                    ),
                  ],
                )),
                padding: const EdgeInsets.all(15.0),
              ),
            ),
          );
        });
  }
}
