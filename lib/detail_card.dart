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
}
