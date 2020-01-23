import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'detailed_page.dart';
import 'firestore_provider.dart';
import 'grocery_item.dart';

class FridgeList extends StatelessWidget {
  const FridgeList({this.sortOrder});
  final String sortOrder;

  //determine text color based on how far away expiry date is
  TextStyle getExpiryIndicatorColor(DateTime expiryDate) {
    TextStyle expiryColour;
    if (expiryDate == null) {
      expiryColour = TextStyle(color: Colors.black);
      return expiryColour;
    }

    DateTime today = DateTime.now();
    int daysTillExpiry = expiryDate.difference(today).inDays;

    if (daysTillExpiry < 0) {
      expiryColour = TextStyle(color: Colors.brown[700]);
    }
    if (daysTillExpiry == 0) {
      expiryColour = TextStyle(color: Colors.red);
    }
    if (daysTillExpiry >= 1) {
      expiryColour = TextStyle(color: Colors.deepOrange);
    }
    if (daysTillExpiry >= 5) {
      expiryColour = TextStyle(color: Colors.orange[600]);
    }
    if (daysTillExpiry >= 10) {
      expiryColour = TextStyle(color: Colors.green);
    }
    return expiryColour;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final firestore = FirestoreProvider.of(context);

    return StreamBuilder<QuerySnapshot>(
      stream:
          firestore.collection('fridge_list').orderBy(sortOrder).snapshots(),
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
      title: Text(
        groceryItem.name,
        style: getExpiryIndicatorColor(groceryItem.expiryDate),
      ),
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
}
