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
    return WillPopScope(
      onWillPop: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(),
          ),
        );
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('${item.name} Details'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                );
              },
            ),
            actions: [_editButton(context), _deleteButton(context)],
          ),
          body: _detailCard(context)),
    );
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
          deleteGroceryItem(context, item);
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
              builder: (context) => SubmissionForm(item: item),
            ),
          );
          itemBloc.removeItem.add(item);
        },
      );

  void deleteGroceryItem(BuildContext context, GroceryItem item) {
    final itemBloc = ItemProvider.of(context);
    itemBloc.removeItem.add(item);
  }

  void restoreGroceryItem(BuildContext context, GroceryItem item) {
    final itemBloc = ItemProvider.of(context);
    itemBloc.addItem.add(item);
  }
}
