import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grocery_app/custom_localization.dart';
import 'package:grocery_app/firestore_provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/submission_form.dart';
import 'package:rxdart/rxdart.dart';

import 'auth.dart';
import 'grocery_list.dart';
import 'my_fridge.dart';
import 'root.dart';
import 'fab_bottom_app.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification(
      {@required this.id,
      @required this.title,
      @required this.body,
      @required this.payload});
}

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

  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
    didReceiveLocalNotificationSubject.add(ReceivedNotification(
        id: id, title: title, body: body, payload: payload));
  });

  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });

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
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RootPage()),
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
          child: const Icon(Icons.add),
          onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SubmissionForm()),
              )),
    );
  }
}
