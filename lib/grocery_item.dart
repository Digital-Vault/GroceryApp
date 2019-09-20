import 'package:flutter/foundation.dart';

/// A grocery item.
class GroceryItem {
  GroceryItem(
      {@required this.name,
      @required this.expiryDate,
      this.quantity = 0,
      this.purchased = false})
      : assert(name != null),
        assert(expiryDate != null);

  String name;
  int quantity;
  DateTime expiryDate;
  bool purchased;
}
