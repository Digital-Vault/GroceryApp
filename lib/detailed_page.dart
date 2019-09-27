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
        body: DetailCard(
          item: item,
        ));
  }
}
