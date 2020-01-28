import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/custom_localization.dart';

import 'auth.dart';
import 'fridge_list.dart';
import 'search.dart';
import 'grocery_list.dart';

class MyFridge extends StatefulWidget {
  MyFridge({this.onSignedOut, this.auth});

  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    return _MyFridge(auth: auth, onSignedOut: onSignedOut);
  }
}

class _MyFridge extends State<MyFridge> {
  _MyFridge({this.onSignedOut, this.auth});

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  var _documents = <DocumentSnapshot>[];
  var _order = 'name';

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
    _getData(context, 'fridge_list').then((list) {
      _documents = list;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(CustomLocalizations.of(context).fridgeTitle),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: DataSearch(documents: _documents));
              }),
          PopupMenuButton<MenuItems>(
            onSelected: (MenuItems result) {
              if (result == MenuItems.logout) {
                _signOut(context);
              } else if (result == MenuItems.alphabetically) {
                setState(() {
                  _order = 'name';
                });
              } else if (result == MenuItems.expiryDate) {
                setState(() {
                  _order = 'expiryDate';
                });
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItems>>[
              PopupMenuItem<MenuItems>(
                value: MenuItems.alphabetically,
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title:
                      Text(CustomLocalizations.of(context).sortAlphabetically),
                ),
              ),
              PopupMenuItem<MenuItems>(
                value: MenuItems.expiryDate,
                child: Text(CustomLocalizations.of(context).sortExpiry),
              ),
              PopupMenuItem<MenuItems>(
                value: MenuItems.logout,
                child: Text(CustomLocalizations.of(context).logout),
              ),
            ],
          ),
        ],
      ),
      body: FridgeList(sortOrder: _order),
    );
  }

  Future<List<DocumentSnapshot>> _getData(
      BuildContext context, String collectionName) async {
    var documents = <DocumentSnapshot>[];
    documents.clear();
    QuerySnapshot queryList =
        await Firestore.instance.collection(collectionName).getDocuments();
    var GroceryItems = queryList.documents;
    for (int i = 0; i < GroceryItems.length; i++) {
      documents.add(GroceryItems[i]);
    }
    return documents;
  }
}
