import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hptracker/constants/colors.dart';
import 'package:hptracker/constants/routes.dart';
import 'package:hptracker/notifications.dart/push_notifications.dart';

// Platform  Firebase App Id
// android   1:46846944906:android:3460cfe16dcb1bcdd9ef73
// ios       1:46846944906:ios:52cc3eaa3479baa7d9ef73

// engineer and operator

final navigatorKey = GlobalKey<NavigatorState>();

Future _firebaseBackgroudMessages (message) async {
    if (message.notification != null) {
      print("Recieved some notification");
    }
  }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );
  

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroudMessages);

  FirebaseMessaging.onMessageOpenedApp.listen((message) async {
    PushNotification().handleMessage(message);
  });

  PushNotification().initPushNotifications();
  runApp(
       const MyApp(),
  );  
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: primary,
          onPrimary: Colors.white,
          secondary: accent,
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          background: background,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
         ),
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: "/splashScreen",
      routes: routes,
    );
  }
}