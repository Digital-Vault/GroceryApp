import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';

class ShareAccountPage extends StatefulWidget {
  @override
  _ShareAccountPageState createState() => _ShareAccountPageState();
}

class _ShareAccountPageState extends State<ShareAccountPage> {
  final _formKey = GlobalKey<FormState>();
  String _emailAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Accounts'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        autovalidate: true,
        child: ListView(
          children: <Widget>[
            _emailInput(),
            _sendButton(),
          ],
        ),
      ),
    );
  }

  Widget _emailInput() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'abc@example.com',
        labelText: 'Email',
        icon: Icon(Icons.email),
      ),
      validator: _emailValid,
      onSaved: _onEmailSaved,
    );
  }

  String _emailValid(String enteredEmail) {
    final emailRegex =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    final regExp = RegExp(emailRegex, caseSensitive: false);
    if (regExp.hasMatch(enteredEmail)) {
      return null;
    } else {
      return 'Please enter a valid email address';
    }
  }

  void _onEmailSaved(String enteredEmail) {
    _emailAddress = enteredEmail;
  }

  Widget _sendButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 64),
      child: ButtonTheme(
        minWidth: double.infinity,
        padding: const EdgeInsets.all(16),
        child: RaisedButton(
          onPressed: _submitForm,
          child: Text(
            'Send Request'.toUpperCase(),
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final function = CloudFunctions.instance
          .getHttpsCallable(functionName: 'sendSharingConfirmation')
            ..timeout = const Duration(seconds: 30);
      ;

      unawaited(function.call(
        <String, dynamic>{
          'email': _emailAddress,
        },
      ));

      Navigator.pop(_formKey.currentContext, true);
    }
  }
}
