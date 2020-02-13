import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/custom_localization.dart';
import 'detailed_page.dart';
import 'firestore_provider.dart';
import 'grocery_item.dart';

class FridgeList extends StatelessWidget {
  const FridgeList({this.sortOrder});
  final String sortOrder;

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
    final firestore = FirestoreProvider.of(context);
    return Dismissible(
        key: Key(document.documentID),
        background: _dismissibleBackground(),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          firestore.collection('user1_list').add(groceryItem.toJson());
          document.reference.delete();
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Moved ${groceryItem.name} to Grocery List!'),
            ),
          );
        },
        child: ListTile(
          title: Text(
            groceryItem.name,
            //style: getExpiryIndicatorColor(groceryItem.expiryDate),
          ),
          subtitle: getExpiryIndicatorColor(
              context, groceryItem.expiryDate, groceryItem.name),
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
        ));
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

  //determine text color based on how far away expiry date is
  Text getExpiryIndicatorColor(
      BuildContext context, DateTime expiryDate, String itemName) {
    Text expiryInfo;
    if (expiryDate == null) {
      return null;
    }
    DateTime today = DateTime.now();
    int daysTillExpiry = expiryDate.difference(today).inDays;
    String expirySentence =
        "● $itemName ${CustomLocalizations.of(context).fridgeExpiryDateFirstPart} $daysTillExpiry ${CustomLocalizations.of(context).fridgeExpiryDateSecondPart}.";

    if (daysTillExpiry < 0) {
      expiryInfo = Text("● $itemName has expired!",
          style: TextStyle(color: Colors.red[700]));
    }
    if (daysTillExpiry < 5 && daysTillExpiry >= 0) {
      expiryInfo = Text(expirySentence, style: TextStyle(color: Colors.red));
    }
    return expiryInfo;
  }
}
