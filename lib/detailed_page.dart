import 'package:flutter/material.dart';
import 'package:grocery_app/detail_card.dart';
import 'package:grocery_app/item_provider.dart';
import 'package:grocery_app/grocery_item.dart';
import 'package:grocery_app/submission_form.dart';
import 'package:grocery_app/main.dart';

class DetailedPage extends StatelessWidget {
  final GroceryItem item;
  DetailedPage({this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${item.name} Details'),
          actions: [_editButton(context), _deleteButton(context)],
        ),
        body: _detailCard(context));
  }

  Widget _detailCard(BuildContext context) => Builder(
        builder: (BuildContext context) {
          return Column(children: <Widget>[
            DetailCard(
              item: item,
            ),
          ]);
        },
      );
  Widget _deleteButton(BuildContext context) => IconButton(
        icon: Icon(Icons.delete_forever),
        onPressed: () {
          _deleteGroceryItem(context, item);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyApp(),
            ),
          );
        },
      );
  Widget _editButton(BuildContext context) => IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          final itemBloc = ItemProvider.of(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubmissionForm(),
            ),
          );
          itemBloc.removeItem.add(item);
        },
      );

  void _deleteGroceryItem(BuildContext context, GroceryItem item) {
    final itemBloc = ItemProvider.of(context);
    itemBloc.removeItem.add(item);
  }
}
