import 'package:flutter/material.dart';
import 'package:grocery_app/grocery_item.dart';
import 'package:grocery_app/card.dart';
import 'data.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.blue,
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List data;

  @override
  Widget build(BuildContext context) {
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
              child: GroceryList(
            grocery: groceryListItems,
          )),
        ));
  }
}
