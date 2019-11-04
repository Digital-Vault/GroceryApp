import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/main.dart';
import 'login_page.dart';
import 'auth.dart';
class RootPage extends StatefulWidget{
  RootPage({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn
}
class _RootPageState extends State<RootPage>{
  AuthStatus authStatus = AuthStatus.notSignedIn;
  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
       authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }
  void _signedIn() {
      setState(() {
        authStatus = AuthStatus.signedIn;
      });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(authStatus == AuthStatus.signedIn){
      return MyApp(
        auth: widget.auth,
        onSignedOut: _signedOut,
      );
    } else {
      return loginPage(
        auth: widget.auth,
        onSignedIn: _signedIn,
      );
    }
  }
}