import 'dart:async';
import 'dart:collection';

import 'package:grocery_app/data.dart';
import 'package:grocery_app/grocery_item.dart';
import 'package:rxdart/subjects.dart';

/// This is the business logic component that handles all business
/// logic about grocery items.
class ItemBloc {
  /// Creates a bloc.
  ItemBloc() {
    _itemSubject.add(UnmodifiableListView(_items));

    _addItemController.stream.listen(_addItem);
    _removeItemController.stream.listen(_removeItem);
  }

  final _items = groceryListItems;
  final _itemSubject = BehaviorSubject<UnmodifiableListView<GroceryItem>>();
  final _addItemController = StreamController<GroceryItem>();
  final _removeItemController = StreamController<GroceryItem>();

  /// All grocery items.
  Stream<UnmodifiableListView<GroceryItem>> get items => _itemSubject.stream;

  /// Adds item to grocery list.
  Sink<GroceryItem> get addItem => _addItemController.sink;

  /// Removes item from grocery list.
  Sink<GroceryItem> get removeItem => _removeItemController.sink;

  void _addItem(GroceryItem item) {
    _items.add(item);
    _itemSubject.add(UnmodifiableListView(_items));
  }

  void _removeItem(GroceryItem item) {
    _items.remove(item);
    _itemSubject.add(UnmodifiableListView(_items));
  }

  /// Closes all the Sinks and Streams.
  void dispose() {
    _itemSubject.close();
    _addItemController.close();
    _removeItemController.close();
  }
}
