import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

/// This is an InheritedWidget that wraps around [Firestore].
class FirestoreProvider extends InheritedWidget {
  /// Creates provider that passes [Firestore].
  FirestoreProvider({
    @required Widget child,
    @required this.firestore,
    Key key,
  })  : assert(firestore != null),
        super(key: key, child: child);

  final Firestore firestore;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  /// Returns the [Firestore].
  static Firestore of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(FirestoreProvider)
              as FirestoreProvider)
          .firestore;
}
