import 'package:flutter/material.dart';
import 'package:grocery_app/screens/share_accounts/share_account_page.dart';

class SettingsItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildShareAccounts(context),
      ],
    );
  }

  Widget _buildShareAccounts(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text('Share Accounts'),
        leading: Icon(Icons.people),
        onTap: () {
          final result = Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShareAccountPage(),
            ),
          );
          result.then((success) {
            if (success) {
              final snackbar = SnackBar(
                content: Text('A confirmation email has been sent'),
              );
              Scaffold.of(context).showSnackBar(snackbar);
            }
          });
        },
      ),
    );
  }
}
