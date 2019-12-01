import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';
import 'fridge_list.dart';
import 'search.dart';
import 'grocery_list.dart';
class MyFridge extends StatelessWidget {
  MyFridge({this.onSignedOut, this.auth});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  var _documents = <DocumentSnapshot>[];
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
    
    GroceryList().getData(context, 'fridge_list').then((list) {
        _documents = list;
    }
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("My Fridge"),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: DataSearch(documents: _documents));
              }),
          FlatButton(
            child: Text('Logout',
                style: TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: () => _signOut(context),
          )
        ],
      ),
      body: FridgeList(),
    );
  }
}
