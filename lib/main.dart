import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grocery_app/util/notification_util.dart';
import 'widgets/custom_localization.dart';
import 'widgets/firestore_provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/grocery_item_modification.dart';

import 'widgets/auth.dart';
import 'screens/grocery/grocery_list.dart';
import 'screens/fridge/my_fridge.dart';
import 'root.dart';
import 'widgets/fab_bottom_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'app',
    options: const FirebaseOptions(
      googleAppID: '1:498366100462:android:1af1d802ede9d55fc614ff',
      apiKey: 'AIzaSyBL6UHw8CgVpFvsHTKthWSZ8O4jhx248vQ',
      projectID: 'group2-2afd3',
    ),
  );
  final Firestore firestore = Firestore(app: app);
  initializeNotification();

  runApp(
    FirestoreProvider(
      firestore: firestore,
      child: MaterialApp(
        onGenerateTitle: (BuildContext context) =>
            CustomLocalizations.of(context).title,
        localizationsDelegates: [
          const CustomLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('fr', ''),
          const Locale.fromSubtags(languageCode: 'zh'), // generic Chinese 'zh'
          const Locale.fromSubtags(
              languageCode: 'zh',
              scriptCode: 'Hans'), // generic simplified Chinese 'zh_Hans'
          const Locale.fromSubtags(
              languageCode: 'zh',
              scriptCode: 'Hant'), // generic traditional Chinese 'zh_Hant'
          const Locale.fromSubtags(
              languageCode: 'zh',
              scriptCode: 'Hans',
              countryCode: 'CN'), // 'zh_Hans_CN'
          const Locale.fromSubtags(
              languageCode: 'zh',
              scriptCode: 'Hant',
              countryCode: 'TW'), // 'zh_Hant_TW'
          const Locale.fromSubtags(
              languageCode: 'zh',
              scriptCode: 'Hant',
              countryCode: 'HK'), // 'zh_Hant_HK'
          const Locale('es', ''),
        ],
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RootPage(auth: Auth()),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({this.onSignedOut, this.auth});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    return _MyAppState(
      onSignedOut: onSignedOut,
      auth: auth,
    );
  }
}

class _MyAppState extends State<MyApp> {
  _MyAppState({this.onSignedOut, this.auth});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  int selectedPage = 0;

  void _selectedTab(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  void initState() {
    super.initState();
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RootPage(),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
    selectNotificationSubject.stream.listen((String payload) async {
      var firebase = FirestoreProvider.of(context);
      var docRef = firebase.collection("fridge_list").document(payload);
      var docSnap = await docRef.get();

      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GroceryItemModification(document: docSnap)),
      );
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageOptions = [
      GroceryList(onSignedOut: onSignedOut, auth: auth),
      MyFridge(onSignedOut: onSignedOut, auth: auth)
    ];

    return Scaffold(
      body: pageOptions[selectedPage],
      bottomNavigationBar: FABBottomAppBar(
        onTabSelected: _selectedTab,
        selectedColor: Colors.lightBlue,
        items: [
          FABBottomAppBarItem(
              iconData: Icons.home,
              text: CustomLocalizations.of(context).navbarHome),
          FABBottomAppBarItem(
              iconData: Icons.list,
              text: CustomLocalizations.of(context).navbarFridge),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          tooltip: "Add grocery Item",
          child: const Icon(Icons.add),
          onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GroceryItemModification()),
              )),
    );
  }
}
