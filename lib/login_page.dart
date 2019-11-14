import 'package:flutter/material.dart';
import 'auth.dart';

class loginPage extends StatefulWidget {
  loginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<loginPage> {
  final formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  FormType _formType = FormType.login;
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit(BuildContext context) async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId =
              await widget.auth.SignInWithEmailAndPassword(_email, _password);
          print('Signed in: $userId');
        } else {
          String userId = await widget.auth
              .createUserWithEmailAndPassword(_email, _password);
          print('Registered user: $userId');
        }
        widget.onSignedIn();
      } catch (e) {
        print('Login Error: $e');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: (SizedBox(
        width: 500.0,
        height: 800.0,
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Builder(
              builder: (context) => Container(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: buildInputs() + buildSubmitButtons(context),
                      ))),
            )),
      )),
    );
  }

  List<Widget> buildInputs() {
    return [
      _buildIcon(context),
      _buildText(),
      SizedBox(height: 15),
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
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
      SizedBox(height: 15),
      TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons(BuildContext context) {
    if (_formType == FormType.login) {
      return [
        SizedBox(height: 50),
        RaisedButton(
            child: Text('Login'),
            onPressed: () {
              validateAndSubmit(context);
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Processing'), duration: Duration(seconds: 1)));
            }),
        FlatButton(
          child: Text(' Create an account'),
          onPressed: moveToRegister,
        )
      ];
    } else {
      return [
        SizedBox(height: 50),
        RaisedButton(
            child: Text('Create an account'),
            onPressed: () {
              validateAndSubmit(context);
            }),
        FlatButton(
          child: Text('Have an account? Login'),
          onPressed: moveToLogin,
        )
      ];
    }
  }

  Widget _buildIcon(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 5;
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Icon(
        Icons.restaurant,
        size: size,
      ),
    );
  }

  Widget _buildText() => const Padding(
        padding: EdgeInsets.only(top: 20, bottom: 10),
        child: Text(
          'Grocery App',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
      );
}
