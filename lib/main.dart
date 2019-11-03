import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:grocery_app/grocery_card.dart';
import 'package:grocery_app/grocery_item.dart';
import 'package:grocery_app/item_provider.dart';
import 'package:grocery_app/submission_form.dart';

void main() {
  runApp(
    ItemProvider(
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final itemBloc = ItemProvider.of(context);
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Grocery List",
              style: TextStyle(color: Colors.white),
            ),
            leading: Container(),
          ),
          body: Container(
            child: Center(
              // Use future builder and DefaultAssetBundle to load the local JSON file
              child: StreamBuilder<UnmodifiableListView<GroceryItem>>(
                stream: itemBloc.items,
                initialData: UnmodifiableListView<GroceryItem>([]),
                builder: (context, snapshot) {
                  return ListView(
                    children:
                        snapshot.data.map((i) => GroceryCard(item: i)).toList(),
                  );
                },
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SubmissionForm()),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
          ),
        ));
  }
}
