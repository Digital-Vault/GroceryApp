import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:grocery_app/grocery_card.dart';
import 'package:grocery_app/grocery_item.dart';
import 'package:grocery_app/item_provider.dart';

void main() {
  runApp(
    ItemProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List data;

  @override
  Widget build(BuildContext context) {
    final itemBloc = ItemProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Grocery List",
          style: TextStyle(color: Colors.white),
        ),
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
    );
  }
}
