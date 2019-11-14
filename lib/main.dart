import 'package:flutter/material.dart';
import 'package:grocery_app/firestore_provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/submission_form.dart';

import 'auth.dart';
import 'grocery_list.dart';
import 'my_fridge.dart';
import 'root.dart';
import 'fab_bottom_app.dart';

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

  void _selectedTab(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: pageOptions[selectedPage],
        bottomNavigationBar: FABBottomAppBar(
          onTabSelected: _selectedTab,
          selectedColor: Colors.lightBlue,
          items: [
            FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
            FABBottomAppBarItem(iconData: Icons.list, text: 'My Fridge'),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubmissionForm()),
                )),
      ),
    );
  }
}
