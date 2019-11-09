import 'package:flutter/material.dart';
import 'package:grocery_app/firestore_provider.dart';
import 'package:grocery_app/grocery_item.dart';
import 'package:grocery_app/item_provider.dart';
import 'package:grocery_app/submission_form.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'app',
    options: const FirebaseOptions(
      googleAppID: '1:498366100462:android:1af1d802ede9d55fc614ff',
      apiKey: 'AIzaSyBL6UHw8CgVpFvsHTKthWSZ8O4jhx248vQ',
      projectID: 'group2-2afd3',
    ),
  );
  final Firestore firestore = Firestore(app: app);

  runApp(
    FirestoreProvider(
      firestore: firestore,
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
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<DocumentSnapshot> availableDocuments) {
    return ListView.builder(
      itemCount: availableDocuments.length,
      itemBuilder: (BuildContext _context, int index) {
        return _buildItemRow(availableDocuments[index]);
      },
    );
  }

  Widget _buildItemRow(DocumentSnapshot document) {
    final groceryItem = GroceryItem.fromJson(document.data);

    return ListTile(
      title: Text(groceryItem.name),
      trailing: Text("${groceryItem.quantity}x"),
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
