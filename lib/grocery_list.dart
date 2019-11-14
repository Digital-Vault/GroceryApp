import 'package:flutter/material.dart';
import 'package:grocery_app/firestore_provider.dart';
import 'package:grocery_app/grocery_item.dart';
import 'package:grocery_app/submission_form.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';
import 'root.dart';
import 'detailed_page.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({this.onSignedOut, this.auth});
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Grocery List"),
        actions: [
          FlatButton(
            child: Text('Logout',
                style: TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: () => _signOut(context),
          )
        ],
      ),
      body: _buildBody(context),
      floatingActionButton: _buildAddFab(context),
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

    return ListTile(
      title: Text(groceryItem.name),
      trailing: Text("${groceryItem.quantity}x"),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailedPage(documentReference: document.reference),
          ),
        );
      },
    );
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
