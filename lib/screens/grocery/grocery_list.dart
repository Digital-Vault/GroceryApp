import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/settings/settings_page.dart';
import '../../widgets/custom_localization.dart';
import '../../widgets/expiryDialog.dart';
import '../../widgets/firestore_provider.dart';
import '../../models/grocery_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/grocery_item_modification.dart';
import '../../util/notification_util.dart';
import '../../widgets/auth.dart';
import '../../widgets/search.dart';

enum MenuItems { store, addedDate, logout, settings }

class GroceryList extends StatefulWidget {
  GroceryList({this.onSignedOut, this.auth});

  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    return _GroceryList(
      onSignedOut: onSignedOut,
      auth: auth,
    );
  }
}

class _GroceryList extends State<GroceryList> {
  _GroceryList({this.onSignedOut, this.auth});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  String _order = 'addedDate';
  String _groceryCollectionName;
  String _fridgeCollectionName;
  var _documents = <DocumentSnapshot>[];

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) async {
      await _findGroceryCollectionName(user.uid);
      await _findFridgeCollectionName(user.uid);
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // TODO temperory remove this function
    // It needs to be fixed
    // _documents = await getData(context, _groceryCollectionName);
  }

  Future<void> _findGroceryCollectionName(String id) async {
    final firestore = FirestoreProvider.of(context);

    firestore
        .collection('user_information')
        .where('uid', isEqualTo: id)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _groceryCollectionName = snapshot.documents.first.data['groceryList'];
      });
    });
  }

  Future<void> _findFridgeCollectionName(String id) async {
    final firestore = FirestoreProvider.of(context);

    firestore
        .collection('user_information')
        .where('uid', isEqualTo: id)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _fridgeCollectionName = snapshot.documents.first.data['fridgeList'];
      });
    });
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  //determine text color based on how far away expiry date is
  Text getExpiryIndicatorColor(DateTime expiryDate, String itemName) {
    Text expiryInfo;
    if (expiryDate == null) {
      expiryInfo = Text("● Expiry date was not entered for this item.");
      return expiryInfo;
    }
    DateTime today = DateTime.now();
    int daysTillExpiry = expiryDate.difference(today).inDays;
    String expirySentence =
        "● $itemName expires in $daysTillExpiry days. (${expiryDate.day}-${expiryDate.month}-${expiryDate.year})";

    if (daysTillExpiry < 0) {
      expiryInfo = Text("● $itemName has expired!",
          style: TextStyle(color: Colors.brown[700]));
    }
    if (daysTillExpiry == 0) {
      expiryInfo = Text(expirySentence, style: TextStyle(color: Colors.red));
    }
    if (daysTillExpiry >= 1) {
      expiryInfo =
          Text(expirySentence, style: TextStyle(color: Colors.deepOrange));
    }
    if (daysTillExpiry >= 5) {
      expiryInfo = Text(expirySentence, style: TextStyle(color: Colors.orange));
    }
    if (daysTillExpiry >= 10) {
      expiryInfo = Text(expirySentence, style: TextStyle(color: Colors.green));
    }
    return expiryInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CustomLocalizations.of(context).homeTitle),
        actions: [
          IconButton(
              tooltip: "Search for grocery Item",
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: DataSearch(documents: _documents));
              }),
          PopupMenuButton<MenuItems>(
            tooltip: "Menu Button for sorting grocery items and logging out",
            onSelected: (MenuItems result) {
              if (result == MenuItems.logout) {
                _signOut(context);
              } else if (result == MenuItems.store) {
                setState(() {
                  _order = 'store';
                });
              } else if (result == MenuItems.addedDate) {
                setState(() {
                  _order = 'addedDate';
                });
              } else if (result == MenuItems.settings) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItems>>[
              PopupMenuItem<MenuItems>(
                value: MenuItems.store,
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text(CustomLocalizations.of(context).sortAdded),
                ),
              ),
              PopupMenuItem<MenuItems>(
                value: MenuItems.addedDate,
                child: Text(CustomLocalizations.of(context).sortStore),
              ),
              PopupMenuItem<MenuItems>(
                value: MenuItems.logout,
                child: Text(CustomLocalizations.of(context).logout),
              ),
              PopupMenuItem<MenuItems>(
                value: MenuItems.settings,
                child: Text('Settings'),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_groceryCollectionName != null) {
      final firestore = FirestoreProvider.of(context);

      return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection(_groceryCollectionName)
            .orderBy(_order)
            .snapshots(),
        builder: _builder,
      );
    }

    return CircularProgressIndicator();
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

  Future<GroceryItem> _showDialog(
      BuildContext context, DocumentSnapshot document) async {
    // flutter defined function
    // final groceryItem = item;

    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ExpiryDialog(item: document);
      },
    );
  }

  Widget _buildItemRow(BuildContext context, DocumentSnapshot document) {
    final groceryItem = GroceryItem.fromJson(document.data);
    final firestore = FirestoreProvider.of(context);
    return Dismissible(
      key: Key(document.documentID),
      background: _dismissibleBackground(),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) async {
        if (groceryItem.expiryDate == null) {
          await _showDialog(context, document);
        } else {
          var docRef = await firestore
              .collection(_fridgeCollectionName)
              .add(groceryItem.toJson());
          await scheduleExpiryNotification(groceryItem.notifyDate,
              groceryItem.expiryDate, groceryItem.name, docRef.documentID);
        }
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Moved ${groceryItem.name} to Fridge!'),
          ),
        );
      },
      child: Container(
        child: ListTile(
          leading: returnLogo(groceryItem),
          title: Text(
            groceryItem.name,
            //style: getExpiryIndicatorColor2(groceryItem.expiryDate),
          ),
          trailing: Text('${groceryItem.quantity}x'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    GroceryItemModification(document: document),
              ),
            );
          },
        ),
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

  Widget returnLogo(GroceryItem item) {
    if (item.store == 'Walmart') {
      return ImageIcon(
        AssetImage('assets/walmart.png'),
        color: Colors.blue,
        size: 70,
      );
    } else if (item.store == 'Shoppers') {
      return ImageIcon(
        AssetImage('assets/Shoppers.png'),
        color: Colors.red,
        size: 70,
      );
    } else if (item.store == 'Sobeys') {
      return ImageIcon(
        AssetImage('assets/Sobeys.png'),
        color: Colors.green,
        size: 70,
      );
    } else if (item.store == 'Shoppers') {
      return ImageIcon(
        AssetImage('assets/Shoppers.png'),
        color: Colors.green,
        size: 70,
      );
    } else if (item.store == 'Lablaw') {
      return ImageIcon(
        AssetImage('assets/l.png'),
        color: Colors.black,
        size: 70,
      );
    } else if (item.store == 'Metro') {
      return ImageIcon(
        AssetImage('assets/Metro.png'),
        color: Colors.red,
        size: 70,
      );
    } else {
      return ImageIcon(
        AssetImage('assets/cart.png'),
        color: Colors.red,
        size: 70,
      );
    }
  }

  Future<List<DocumentSnapshot>> getData(
      BuildContext context, String collectionName) async {
    var documents = <DocumentSnapshot>[];
    documents.clear();
    QuerySnapshot queryList =
        await Firestore.instance.collection(collectionName).getDocuments();
    var GroceryItems = queryList.documents;
    for (int i = 0; i < GroceryItems.length; i++) {
      documents.add(GroceryItems[i]);
    }
    return documents;
  }
}
