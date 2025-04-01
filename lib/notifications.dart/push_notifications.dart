import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hptracker/main.dart';

class PushNotification {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  // void getFCMToken(String cpf) async {
  //   await messaging.requestPermission(
  //     announcement: true,
  //   );

  //   String? token = await messaging.getToken();
  //   saveTokenToDatabase(token, cpf);
  //   }

  void saveTokenToDatabase(String token, String cpf) {
    FirebaseFirestore.instance.collection('users').doc(cpf).set({
      'fcmToken': token,
    }, SetOptions(merge: true));
  }

  void firebaseForegroundMessages(RemoteMessage message) async {
    if (message.notification != null) {
      print("Notification recieved");
    }
  }

  void handleMessage(RemoteMessage message) {
    try {
      print(message.data);
      navigatorKey.currentState!.pushNamed("/splashScreen");
    } catch (e) {
      print("Message Error : $e");
    }
  }

  void initPushNotifications() async {
    await messaging.requestPermission();

    final token = await messaging.getToken();

    print("token : $token");

    // messaging.getInitialMessage().then(handleMessage);
  }
}
