import 'package:flutter/widgets.dart';
import 'package:grocery_app/item_bloc.dart';

/// This is an InheritedWidget that wraps around [ItemBloc].
class ItemProvider extends InheritedWidget {
  /// Creates provider that passes [ItemBloc].
  ItemProvider({
    @required Widget child,
    Key key,
    ItemBloc bookBloc,
  })  : _bookBloc = bookBloc ?? ItemBloc(),
        super(key: key, child: child);

  final ItemBloc _bookBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  /// Returns the [ItemBloc].
  static ItemBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ItemProvider) as ItemProvider)
          ._bookBloc;
}
