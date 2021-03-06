import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_localization.dart';
import 'submission_form.dart';
import '../../widgets/firestore_provider.dart';
import '../../models/grocery_item.dart';

class FridgeList extends StatelessWidget {
  const FridgeList({this.collectionName, this.sortOrder});
  final String collectionName;
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
          firestore.collection(collectionName).orderBy(sortOrder).snapshots(),
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
        child: Container(
            decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                        color: borderColor(groceryItem.expiryDate), width: 4))),
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
                    builder: (context) => SubmissionForm(document: document),
                  ),
                );
              },
            )));
  }

  MaterialColor borderColor(DateTime expiryDate) {
    if (expiryDate == null) {
      return null;
    }
    DateTime today = DateTime.now();
    int daysTillExpiry = expiryDate.difference(today).inDays;
    MaterialColor colors;
    if (daysTillExpiry < 0) {
      colors = Colors.red;
    } else if (daysTillExpiry < 5 && daysTillExpiry >= 0) {
      colors = Colors.orange;
    } else {
      colors = Colors.green;
    }
    return colors;
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
      expiryInfo = Text("● $itemName has expired!");
    }
    if (daysTillExpiry < 5 && daysTillExpiry >= 0) {
      expiryInfo = Text(expirySentence);
    }
    return expiryInfo;
  }
}
