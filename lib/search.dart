import 'package:flutter/material.dart';
import 'package:grocery_app/grocery_item.dart';
import 'detailed_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataSearch extends SearchDelegate<String>{
  DataSearch({this.items, this.documents});
  List<DocumentSnapshot> documents;
  List<GroceryItem> items;
  var recentItems = <DocumentSnapshot>[];
  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for app bar
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () {
        query = "";
      } )
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
    //final suggestionList = items.where((n) => n.name.contains(query)).toList();

    final suggest = query.isEmpty
    ? recentItems.where((a){
      final x =GroceryItem.fromJson(a.data);
      final b = x.name;
      return b.contains(query);
    }
    ).toList()
    : documents.where((a){
      final x =GroceryItem.fromJson(a.data);
      final b = x.name;
      return b.contains(query);
    }
    ).toList();

    return ListView(
        children: suggest.map<ListTile>((a) => ListTile(
          onTap: () {
              recentItems.add(a);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailedPage(documentReference: a.reference),
              )
              );
          },
          leading: Icon(Icons.restaurant),
          title: Text(GroceryItem.fromJson(a.data).name),
        )
        ).toList()
    );

//    return ListView.builder(
//      itemBuilder: (context,index)=> ListTile(
//        onTap: () {
//          Navigator.push(
//            context,
//             MaterialPageRoute(
//               builder: (context) =>
//                   DetailedPage(documentReference: documents[index].reference)
//             ),
//          );
//        },
//        leading: Icon(Icons.fastfood),
//        title: RichText(text: TextSpan(
//            text: suggestionList[index].substring(0,query.length),
//            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//            children: [
//              TextSpan(text: suggestionList[index].substring(query.length),
//                style: TextStyle(color: Colors.grey),
//              )
//            ]
//        )),
//      ),
//      itemCount: suggestionList.length,
//    );
  }


}