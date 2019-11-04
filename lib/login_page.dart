import 'package:flutter/material.dart';
import 'auth.dart';
class  loginPage extends StatefulWidget{
  loginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

enum FormType{
  login, register
}
class _LoginPageState extends State<loginPage> {


  final formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  FormType _formType = FormType.login;
  bool validateAndSave() {
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {

    if(validateAndSave()){
    try{
      if(_formType == FormType.login){
        String userId = await widget.auth.SignInWithEmailAndPassword(_email, _password);
        print('Signed in: $userId');
      } else {
        String userId = await widget.auth.createUserWithEmailAndPassword(_email, _password);
        print('Registered user: $userId');
      }
      widget.onSignedIn();
    } catch(e){
      print('Login Error: $e');
    }

    }
  }

  void moveToRegister(){
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
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body:  Container(
          padding: EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children:
                  buildInputs()+ buildSubmitButtons(),


              )
            )
        )
    );
  }

  List<Widget> buildInputs() {
    return [
    _buildIcon(context),
      _buildText(),
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value){
          if (value.isEmpty){
              return('Email can\'t be empty');
          } else if(!value.contains('@')){
            return('Not a valid email');
          } else {
            return null;
          }
        }, 
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Password can\'t be empty': null,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login){
      return [
        RaisedButton(
          child: Text('Login'),
          onPressed: validateAndSubmit,

        ),
        FlatButton(
          child: Text(' Create an account'),
          onPressed: moveToRegister,
        )
      ];
    } else {
      return [
        RaisedButton(
          child: Text('Create an account'),
          onPressed: validateAndSubmit,
        ),
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


