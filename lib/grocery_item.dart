import 'package:flutter/foundation.dart';

/// A grocery item.
class GroceryItem {
  GroceryItem(
      {@required this.name,
      this.expiryDate,
      this.quantity,
      this.purchased = false})
      : assert(name != null);

  String name;
  int quantity;
  DateTime expiryDate;
  bool purchased;
}
