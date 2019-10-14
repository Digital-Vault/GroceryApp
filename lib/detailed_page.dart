import 'package:flutter/material.dart';
import 'package:grocery_app/detail_card.dart';
import 'package:grocery_app/item_provider.dart';
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
        body: Builder(
          builder: (BuildContext context) {
            return Column(children: <Widget>[
              DetailCard(
                item: item,
              ),
              _buildDeleteButton(context)
            ]);
          },
        )
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return RaisedButton(
      child: Text(
        "Delete Item",
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.red,
      onPressed: () {
        deleteGroceryItem(context, item);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Deleted ${item.name}!"),
          action: SnackBarAction(
            label: "UNDO",
            onPressed: () {
              restoreGroceryItem(context, item);
            },
          ),
        ));
        Navigator.pop(context);
      },
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
