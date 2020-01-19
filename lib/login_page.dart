import 'package:flutter/material.dart';
import 'loading_screen.dart';
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
  //form key
  final formKey = GlobalKey<FormState>();
<<<<<<< HEAD
=======
  bool _loading = false;
  String _email;
  String _password;
  String _error = "";
>>>>>>> new login page ui
  FormType _formType = FormType.login;

  //members
  bool _loading = false;
  String _email = "";
  String _password = "";
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

  void validateAndSubmit(BuildContext context) async {
    if (validateAndSave()) {
      try {
        setState(() {
          _loading = true;
        });
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
        //print('Login Error: $e');
        setState(() {
          _error = e.message;
          _loading = false;
        });
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
    return _loading
        ? Loading()
        : SingleChildScrollView(
<<<<<<< HEAD
            reverse: true,
=======
>>>>>>> new login page ui
            child: (SizedBox(
              width: 500.0,
              height: 800.0,
              child: Scaffold(
<<<<<<< HEAD
                  resizeToAvoidBottomInset: false,
=======
>>>>>>> new login page ui
                  resizeToAvoidBottomPadding: false,
                  body: Center(
                    child: Builder(
                      builder: (context) => Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/login_screen.png'),
<<<<<<< HEAD
                                  fit: BoxFit.cover)),
=======
                                  fit: BoxFit.fill)),
>>>>>>> new login page ui
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
      _buildText(),
      SizedBox(height: 15),
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
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
      SizedBox(height: 15),
      TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        initialValue: _password,
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),
      SizedBox(
        height: 22.0,
      ),
      Text(
        _error,
        style: TextStyle(color: Colors.red, fontSize: 14.0),
      )
    ];
  }

  List<Widget> buildSubmitButtons(BuildContext context) {
    if (_formType == FormType.login) {
      return [
        SizedBox(height: 10),
        RaisedButton(
            color: Colors.blue,
            textColor: Colors.white,
<<<<<<< HEAD
            child: Text(
              'Login',
              style: TextStyle(fontSize: 16.0),
            ),
            onPressed: () {
              validateAndSubmit(context);
              //Scaffold.of(context).showSnackBar(SnackBar(
              //content: Text('Processing'), duration: Duration(seconds: 1)));
=======
            child: Text('Login', style: TextStyle(fontSize: 16.0),),
            onPressed: () {
              validateAndSubmit(context);

              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Processing'), duration: Duration(seconds: 1)));
>>>>>>> new login page ui
            }),
        FlatButton(
          child: Text(' Create an account'),
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return [
        SizedBox(height: 10),
        RaisedButton(
            color: Colors.blue,
            textColor: Colors.white,
<<<<<<< HEAD
            child: Text(
              'Create an account',
              style: TextStyle(fontSize: 16.0),
            ),
=======
            child: Text('Create an account', style: TextStyle(fontSize: 16.0),),
>>>>>>> new login page ui
            onPressed: () {
              validateAndSubmit(context);
            }),
        FlatButton(
          child: Text('Have an account? Login'),
          onPressed: moveToLogin,
        ),
      ];
    }
  }

  Widget _buildIcon(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 5;
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Icon(
        Icons.local_grocery_store,
        size: size,
        color: Colors.blue,
      ),
    );
  }



  Widget _buildText() => const Padding(
        padding: EdgeInsets.only(top: 20, bottom: 10),
        child: Text(
          'Grocery App',
          textAlign: TextAlign.center,
<<<<<<< HEAD
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w700, color: Colors.blue),
=======
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.blue),
>>>>>>> new login page ui
        ),
      );
}
