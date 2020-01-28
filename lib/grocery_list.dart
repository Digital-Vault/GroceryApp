import 'package:flutter/material.dart';
import 'package:grocery_app/custom_localization.dart';
import 'package:grocery_app/firestore_provider.dart';
import 'package:grocery_app/grocery_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/notification_util.dart';
import 'search.dart';
import 'auth.dart';
import 'detailed_page.dart';

enum MenuItems { alphabetically, expiryDate, logout }

class GroceryList extends StatefulWidget {
  GroceryList({this.onSignedOut, this.auth});

  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    return _GroceryList(
      onSignedOut: onSignedOut,
      auth: auth,
    );
  }
}

class _GroceryList extends State<GroceryList> {
  _GroceryList({this.onSignedOut, this.auth});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  String _order = 'name';
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
    getData(context, 'user1_list').then((list) {
      _documents = list;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(CustomLocalizations.of(context).homeTitle),
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
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final firestore = FirestoreProvider.of(context);

    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('user1_list').orderBy(_order).snapshots(),
      builder: _builder,
    );
  }

  Widget _builder(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasError) {
      return _error();
    } else if (_waiting(snapshot)) {
      return _loading();
    } else {
      return _buildList(context, snapshot.data.documents);
    }
  }

  Widget _error() {
    return Center(child: Text('Failed to retrieve data from our servers!'));
  }

  bool _waiting(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.connectionState == ConnectionState.waiting;
  }

  Widget _loading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildList(
      BuildContext context, List<DocumentSnapshot> availableDocuments) {
    return ListView.builder(
      itemCount: availableDocuments.length,
      itemBuilder: (BuildContext _context, int index) {
        return _buildItemRow(context, availableDocuments[index]);
      },
    );
  }

  Widget _buildItemRow(BuildContext context, DocumentSnapshot document) {
    final groceryItem = GroceryItem.fromJson(document.data);
    final firestore = FirestoreProvider.of(context);
    print(groceryItem.expiryDate);
    return Dismissible(
      key: Key(document.documentID),
      background: _dismissibleBackground(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        scheduleExpiryNotification(5, groceryItem.expiryDate, groceryItem.name);
        firestore.collection('fridge_list').add(groceryItem.toJson());
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Moved ${groceryItem.name} to Fridge!'),
          ),
        );
      },
      child: ListTile(
        title: Text(
          groceryItem.name,
          //style: getExpiryIndicatorColor2(groceryItem.expiryDate),
        ),
        trailing: Text('${groceryItem.quantity}x'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DetailedPage(documentReference: document.reference),
            ),
          );
        },
      ),
    );
  }

  Widget _dismissibleBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.green,
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  Future<List<DocumentSnapshot>> getData(
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
