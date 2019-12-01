import 'package:flutter/material.dart';
import 'package:grocery_app/firestore_provider.dart';
import 'package:grocery_app/grocery_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'search.dart';
import 'auth.dart';
import 'detailed_page.dart';

class GroceryList extends StatelessWidget {
  GroceryList({this.onSignedOut, this.auth});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  var _items = <GroceryItem>[];
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
    getData(context).then((list){
        _items = list;
    });
    return Scaffold(

      appBar: AppBar(
        title: Text("Grocery List"),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {
            showSearch(context: context, delegate: DataSearch(items: _items, documents: _documents));
          }),
          FlatButton(
            child: Text('Logout',
                style: TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: () => _signOut(context),
          )
        ],
      ),
      body: _buildBody(context),
    );
  }


  Widget _buildBody(BuildContext context) {
    final firestore = FirestoreProvider.of(context);

    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('user1_list').snapshots(),
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

    return Dismissible(
      key: Key(document.documentID),
      background: _dismissibleBackground(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        firestore.collection('fridge_list').add(groceryItem.toJson());

        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Moved ${groceryItem.name} to Fridge!'),
          ),
        );
      },
      child: ListTile(
        title: Text(groceryItem.name),
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
  Future<List<GroceryItem>> getData(BuildContext context) async {
    var items = <GroceryItem>[];
    _documents.clear();
    items.clear();
    QuerySnapshot queryList = await Firestore.instance.collection('user1_list').getDocuments();
    var GroceryItems = queryList.documents;
    for(int i =0; i < GroceryItems.length; i++){
      items.add(GroceryItem.fromJson(GroceryItems[i].data));
      _documents.add(GroceryItems[i]);
    }
    return items;
  }

}

