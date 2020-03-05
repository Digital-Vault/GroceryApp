import 'package:flutter/material.dart';
import '../models/grocery_item.dart';
import 'grocery_item_modification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataSearch extends SearchDelegate<String> {
  DataSearch({this.items, this.documents});
  List<DocumentSnapshot> documents;
  List<GroceryItem> items;
  var recentItems = <DocumentSnapshot>[];
  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for app bar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading icon on the left of the app bar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Card(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggest = query.isEmpty
        ? recentItems.where((a) {
            final x = GroceryItem.fromJson(a.data);
            final b = x.name;
            return b.toLowerCase().contains(query);
          }).toList()
        : documents.where((a) {
            final x = GroceryItem.fromJson(a.data);
            final b = x.name;
            return b.toLowerCase().contains(query);
          }).toList();

    return ListView(
        children: suggest
            .map<ListTile>((a) => ListTile(
                  onTap: () {
                    recentItems.add(a);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GroceryItemModification(document: a),
                        ));
                  },
                  leading: Icon(Icons.restaurant),
                  title: Text(GroceryItem.fromJson(a.data).name),
                ))
            .toList());
  }
}
