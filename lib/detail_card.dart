import 'package:flutter/material.dart';
import 'package:grocery_app/grocery_item.dart';

class DetailCard extends StatelessWidget {
  DetailCard({@required this.item}) : assert(item != null);

  final GroceryItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildName(),
            _buildQuantity(),
            _buildExpiryInfo()
          ],
        ),
      ),
    );
  }

  Widget _buildName() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Text(
        '${item.name}',
        style: TextStyle(
          fontSize: 48,
          letterSpacing: 0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildQuantity() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        'Quantity: ${item.quantity}',
        style: TextStyle(
          fontSize: 24,
          letterSpacing: 0,
        ),
      ),
    );
  }

  Widget _buildExpiryInfo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: getExpiryIndicatorColor(item.expiryDate, item.name),
    );
  }

  Text getExpiryIndicatorColor(DateTime expiryDate, String itemName) {
    Text expiryInfo;
    if (expiryDate == null) {
      expiryInfo = Text("Expiry date was not entered for $itemName.",
          style: TextStyle(color: Colors.black, fontSize: 20));
      return expiryInfo;
    }
    DateTime today = DateTime.now();
    int daysTillExpiry = expiryDate.difference(today).inDays;
    String expirySentence =
        "Expires in $daysTillExpiry days. (${expiryDate.day}-${expiryDate.month}-${expiryDate.year})";

    if (daysTillExpiry < 0) {
      expiryInfo = Text("Expired ${-1 * daysTillExpiry} days ago.",
          style: TextStyle(color: Colors.brown[700], fontSize: 20));
    }
    if (daysTillExpiry == 0) {
      expiryInfo = Text(expirySentence,
          style: TextStyle(color: Colors.red, fontSize: 20));
    }
    if (daysTillExpiry >= 1) {
      expiryInfo = Text(expirySentence,
          style: TextStyle(color: Colors.deepOrange, fontSize: 20));
    }
    if (daysTillExpiry >= 5) {
      expiryInfo = Text(expirySentence,
          style: TextStyle(color: Colors.orange, fontSize: 20));
    }
    if (daysTillExpiry >= 10) {
      expiryInfo = Text(expirySentence,
          style: TextStyle(color: Colors.green, fontSize: 20));
    }
    return expiryInfo;
  }
}
