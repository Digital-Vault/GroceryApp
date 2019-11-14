import 'package:flutter/material.dart';
import 'auth.dart';
import 'fridge_list.dart';

class MyFridge extends StatelessWidget {
  const MyFridge({this.onSignedOut, this.auth});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

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
    return Scaffold(
      appBar: AppBar(
        title: Text("My Fridge"),
        actions: [
          FlatButton(
            child: Text('Logout',
                style: TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: () => _signOut(context),
          )
        ],
      ),
      body: FridgeList(),
    );
  }
}
