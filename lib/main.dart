import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:grocery_app/grocery_card.dart';
import 'package:grocery_app/grocery_item.dart';
import 'package:grocery_app/item_provider.dart';
import 'package:grocery_app/submission_form.dart';
import 'auth.dart';
import 'root.dart';
void main() {
  runApp(
    ItemProvider(
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:  RootPage(auth: Auth()),
      ),
    ),
  );
}




class MyApp extends StatelessWidget {
  const MyApp({this.onSignedOut, this.auth});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  Future<void> _signOut(BuildContext context) async {
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }
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
            actions: [
              FlatButton(
                child: Text('Logout', style: TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: () => _signOut(context),
              )
            ],
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
