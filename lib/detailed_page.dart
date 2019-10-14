import 'package:flutter/material.dart';
import 'package:grocery_app/detail_card.dart';
import 'package:grocery_app/grocery_item.dart';
import 'package:grocery_app/submission_form.dart';
import 'package:grocery_app/item_provider.dart';
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
        } ,
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
              actions: [
                IconButton(
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
                )
              ],
            ),
            body: DetailCard(
              item: item,
            )));
  }
}
