import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/grocery_item.dart';

import 'grocery_card.dart';

class GroceryList extends StatelessWidget {
  final List<GroceryItem> grocery;
  GroceryList({Key key, this.grocery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: grocery == null ? 0 : grocery.length,
        itemBuilder: (BuildContext context, int index) {
          return GroceryCard(item: grocery[index]);
        });
  }
}
