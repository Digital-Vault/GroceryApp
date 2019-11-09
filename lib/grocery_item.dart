import 'package:json_annotation/json_annotation.dart';

part 'grocery_item.g.dart';

/// A grocery item.
@JsonSerializable()
class GroceryItem {
  GroceryItem(
      {this.name, this.expiryDate, this.quantity, this.purchased = false});

  @JsonKey(nullable: false)
  String name;

  @JsonKey(nullable: false)
  int quantity;
  DateTime expiryDate;
  bool purchased;

  factory GroceryItem.fromJson(Map<String, dynamic> json) =>
      _$GroceryItemFromJson(json);

  Map<String, dynamic> toJson() => _$GroceryItemToJson(this);
}
