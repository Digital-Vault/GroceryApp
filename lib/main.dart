import 'package:flutter/material.dart';
import 'package:grocery_app/grocery_item.dart';
import 'package:grocery_app/item_provider.dart';
import 'package:grocery_app/submission_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Grocery List"),
      ),
      body: _buildBody(),
      floatingActionButton: _buildAddFab(context),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('grocery_items').snapshots(),
      builder: _builder,
    );
  }

  Widget _builder(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasError) {
      return _error();
    } else if (_waiting(snapshot)) {
      return _loading();
    } else {
      return _buildList(snapshot.data.documents);
    }
  }

  Widget _error() {
    return Center(child: Text('Failed to retrieve data from our servers!'));
  }

  bool _waiting(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.connectionState == ConnectionState.waiting;
  }

  Widget _loading() {
    return CircularProgressIndicator();
  }

  Widget _buildList(List<DocumentSnapshot> data) {
    List<Widget> itemRows = _buildItemRows(data);

    return ListView.builder(
      itemCount: itemRows.length,
      itemBuilder: (BuildContext _context, int position) {
        return itemRows[position];
      },
    );
  }

  List<Widget> _buildItemRows(List<DocumentSnapshot> data) {
    List<Widget> items = [];

    for (final itemInfo in data) {
      final groceryItem = GroceryItem.fromJson(itemInfo.data);
      final row = ListTile(
        title: Text(groceryItem.name),
        trailing: Text("${groceryItem.quantity}x"),
      );
      items.add(row);
    }

    return items;
  }

  Widget _buildAddFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SubmissionForm()),
        );
      },
      child: Icon(Icons.add),
    );
  }
}
