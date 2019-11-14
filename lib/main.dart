import 'package:flutter/material.dart';
import 'package:grocery_app/firestore_provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';
import 'grocery_list.dart';
import 'my_fridge.dart';
import 'root.dart';

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
        home: RootPage(auth: Auth()),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({this.onSignedOut, this.auth});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    return _MyAppState(
      onSignedOut: onSignedOut,
      auth: auth,
    );
  }
}

class _MyAppState extends State<MyApp> {
  _MyAppState({this.onSignedOut, this.auth});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  int selectedPage = 0;
  final pageOptions = [GroceryList(), MyFridge()];

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
    return MaterialApp(
      home: Scaffold(
        body: pageOptions[selectedPage],
        bottomNavigationBar: _bottomNavBar(),
      ),
    );
  }

  Widget _bottomNavBar() => BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            title: Text(
              "Grocery List",
              style: TextStyle(fontSize: 12),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.assignment_ind,
              size: 30,
            ),
            title: Text(
              "My Fridge",
              style: TextStyle(fontSize: 12),
            ),
          )
        ],
        onTap: _onTapped,
        currentIndex: selectedPage,
      );
  void _onTapped(int index) {
    setState(() {
      selectedPage = index;
    });
  }
}
