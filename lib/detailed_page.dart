import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/detail_card.dart';
import 'package:grocery_app/grocery_item.dart';
import 'package:grocery_app/submission_form.dart';

class DetailedPage extends StatelessWidget {
  DetailedPage({this.documentReference}) : assert(documentReference != null);

  final DocumentReference documentReference;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: documentReference.snapshots(),
      builder: _builder,
    );
  }

  Widget _builder(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    if (snapshot.hasError) {
      return Center(
        child: Text('Failed to retrieve item details1'),
      );
    }
    if (snapshot.hasData && snapshot.data.data != null) {
      final item = GroceryItem.fromJson(snapshot.data.data);

      return Scaffold(
          appBar: AppBar(
            title: Text('${item.name} Details'),
            actions: [
              _editButton(context, snapshot.data),
              _deleteButton(context)
            ],
          ),
          body: _detailCard(context, item));
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget _detailCard(BuildContext context, GroceryItem item) {
    return DetailCard(item: item);
  }

  Widget _deleteButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete_forever),
      onPressed: () {
        documentReference.delete();
        Navigator.pop(context);
      },
    );
  }

  Widget _editButton(BuildContext context, DocumentSnapshot document) =>
      IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubmissionForm(
                document: document,
              ),
            ),
          );
        },
      );
}
