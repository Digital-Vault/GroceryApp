import 'package:flutter/material.dart';
import '../../widgets/custom_localization.dart';
import 'loading_screen.dart';
import '../../widgets/auth.dart';

class resetPasswordPage extends StatefulWidget {
  resetPasswordPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  State<StatefulWidget> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<resetPasswordPage> {
  //form key
  final formKey = GlobalKey<FormState>();

  //members
  bool _loading = false;
  String _email = "";
  String _success = "";
  String _error = "";

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      setState(() {
        _loading = false;
      });
      return false;
    }
  }

  void sendPasswordResetEmail(BuildContext context) async {
    if (validateAndSave()) {
      try {
        await widget.auth.resetPassword(_email);
        setState(() {
          _success = "✓ Email successfully sent. Check your inbox.";
          _error = "";
        });
      } catch (e) {
        setState(() {
          _success = "";
          _error = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : SingleChildScrollView(
            reverse: true,
            child: (SizedBox(
              width: 500.0,
              height: 800.0,
              child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  resizeToAvoidBottomPadding: false,
                  body: Center(
                    child: Builder(
                      builder: (context) => Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/login_screen.png'),
                                  fit: BoxFit.cover)),
                          padding: EdgeInsets.all(16.0),
                          child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children:
                                    buildInputs() + buildSubmitButtons(context),
                              ))),
                    ),
                  )),
            )),
          );
  }

  List<Widget> buildInputs() {
    return [
      SizedBox(height: 100),
      _buildIcon(context),
      _buildText(context),
      SizedBox(height: 15),
      TextFormField(
        decoration: InputDecoration(
            labelText: CustomLocalizations.of(context).loginEmailLabel),
        initialValue: _email,
        validator: (value) {
          if (value.isEmpty) {
            return ('Email can\'t be empty');
          } else if (!value.contains('@')) {
            return ('Not a valid email');
          } else {
            return null;
          }
        },
        onSaved: (value) => _email = value,
      ),
      SizedBox(
        height: 22.0,
      ),
      Text(
        _error,
        style: TextStyle(color: Colors.red, fontSize: 14.0),
      ),
      Text(
        _success,
        style: TextStyle(color: Colors.green, fontSize: 14.0),
      )
    ];
  }

  List<Widget> buildSubmitButtons(BuildContext context) {
    return [
      SizedBox(height: 10),
      RaisedButton(
          color: Colors.blue,
          textColor: Colors.white,
          child: Text(
            "Send Password Reset Email",
            style: TextStyle(fontSize: 16.0),
          ),
          onPressed: () {
            sendPasswordResetEmail(context);
          }),
      FlatButton(
        child: Text("Go back"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ];
  }

  Widget _buildIcon(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 5;
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Icon(
        Icons.lock_open,
        size: size,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildText(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: 20, bottom: 10),
        child: Text(
          "Reset Password",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.blue,
          ),
        ),
      );
}
