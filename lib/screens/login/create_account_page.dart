import 'package:flutter/material.dart';
import '../../widgets/auth.dart';
import '../../widgets/custom_localization.dart';
import 'login_page.dart';

class createAccountPage extends StatefulWidget {
  createAccountPage({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => _CreateAccountPage();
}

class _CreateAccountPage extends State<createAccountPage> {
  //form key
  final formKey = GlobalKey<FormState>();

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
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      } catch (e) {
        //print('Login Error: $e');
        setState(() {
          _error = e.message;
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                          children: buildInputs() + buildSubmitButtons(context),
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
      SizedBox(height: 15),
      TextFormField(
        decoration: InputDecoration(
            labelText: CustomLocalizations.of(context).loginPasswordLabel),
        initialValue: _password,
        obscureText: true,
        validator: (value) => value.isEmpty
            ? CustomLocalizations.of(context).loginPasswordEmpty
            : null,
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
    return [
      SizedBox(height: 10),
      RaisedButton(
          color: Colors.blue,
          textColor: Colors.white,
          child: Text(
            CustomLocalizations.of(context).loginCreateAccount,
            style: TextStyle(fontSize: 16.0),
          ),
          onPressed: () {
            validateAndSubmit(context);
            //Scaffold.of(context).showSnackBar(SnackBar(
            //content: Text('Processing'), duration: Duration(seconds: 1)));
          }),
      FlatButton(
        child: Text("Have an account? Login"),
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
        Icons.local_grocery_store,
        size: size,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildText(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: 20, bottom: 10),
        child: Text(
          CustomLocalizations.of(context).title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.blue,
          ),
        ),
      );
}
