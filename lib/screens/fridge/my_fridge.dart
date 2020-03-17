import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/widgets/firestore_provider.dart';
import '../../widgets/custom_localization.dart';
import '../../widgets/auth.dart';
import 'fridge_list.dart';
import '../../widgets/search.dart';
import '../grocery/grocery_list.dart';

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
  String _fridgeCollectionName;

  Future<void> _signOut(BuildContext context) async {
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) async {
      await _findFridgeCollectionName(user.uid);
    });
  }

  Future<void> _findFridgeCollectionName(String id) async {
    final firestore = FirestoreProvider.of(context);

    firestore
        .collection('user_information')
        .where('uid', isEqualTo: id)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _fridgeCollectionName = snapshot.documents.first.data['fridgeList'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO temporarily removes search
    // _getData(context, 'fridge_list').then((list) {
    //   _documents = list;
    // });

    if (_fridgeCollectionName == null) {
      return CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(CustomLocalizations.of(context).fridgeTitle),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              tooltip: "Search for Grocery Items",
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: DataSearch(documents: _documents));
              }),
          PopupMenuButton<MenuItems>(
            tooltip: "Menu button for sorting items and logging out",
            onSelected: (MenuItems result) {
              if (result == MenuItems.logout) {
                _signOut(context);
              } else if (result == MenuItems.store) {
                setState(() {
                  _order = 'store';
                });
              } else if (result == MenuItems.addedDate) {
                setState(() {
                  _order = 'addedDate';
                });
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItems>>[
              PopupMenuItem<MenuItems>(
                value: MenuItems.store,
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title:
                      Text(CustomLocalizations.of(context).sortAdded),
                ),
              ),
              PopupMenuItem<MenuItems>(
                value: MenuItems.addedDate,
                child: Text(CustomLocalizations.of(context).sortStore),
              ),
              PopupMenuItem<MenuItems>(
                value: MenuItems.logout,
                child: Text(CustomLocalizations.of(context).logout),
              ),
            ],
          ),
        ],
      ),
      body:
          FridgeList(collectionName: _fridgeCollectionName, sortOrder: _order),
    );
  }

  // TODO dont remove
  // Future<List<DocumentSnapshot>> _getData(
  //     BuildContext context, String collectionName) async {
  //   var documents = <DocumentSnapshot>[];
  //   documents.clear();
  //   QuerySnapshot queryList =
  //       await Firestore.instance.collection(collectionName).getDocuments();
  //   var GroceryItems = queryList.documents;
  //   for (int i = 0; i < GroceryItems.length; i++) {
  //     documents.add(GroceryItems[i]);
  //   }
  //   return documents;
  // }
}
