// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grocery_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroceryItem _$GroceryItemFromJson(Map<String, dynamic> json) {
  return GroceryItem(
    name: json['name'] as String,
    quantity: json['quantity'] as int,
    expiryDate: json['expiryDate'] == null
        ? null
        : DateTime.parse(json['expiryDate'] as String),
    purchased: json['purchased'] as bool,
  );
}

Map<String, dynamic> _$GroceryItemToJson(GroceryItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'purchased': instance.purchased,
    };
