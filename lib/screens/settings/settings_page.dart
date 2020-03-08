import 'package:flutter/material.dart';
import 'package:grocery_app/screens/settings/settings_items.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SettingsItems(),
    );
  }
}
