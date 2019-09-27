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
            _buildExpiryDate(),
            _buildDetailedExpiryDate(),
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

  Widget _buildExpiryDate() {
    Duration difference = item.expiryDate.difference(DateTime.now());

    String message;
    if (_expired(difference.inDays)) {
      message = 'Expired ${difference.abs().inDays} day(s) ago';
    } else {
      message = 'Expires in ${difference.inDays} day(s)';
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 24,
          letterSpacing: 0,
        ),
      ),
    );
  }

  bool _expired(int days) {
    return days < 0;
  }

  Widget _buildDetailedExpiryDate() {
    return Text(
      '${item.expiryDate.day}-${item.expiryDate.month}-${item.expiryDate.year}',
      style: TextStyle(
        color: Colors.black87,
        fontSize: 16,
        letterSpacing: 0.15,
      ),
    );
  }
}
