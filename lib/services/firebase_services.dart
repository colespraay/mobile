import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> handleBackgroundMessage(RemoteMessage message)async{
  // parameter

}

class FirebaseService{

  final _firebaseMessaging=FirebaseMessaging.instance;
  final _androidChannel=const AndroidNotificationChannel("high_importance_channel", "High Importance Notifications",
      description: "This channel is used for importance notification", importance: Importance.defaultImportance);

  final localNotification=FlutterLocalNotificationsPlugin();

  Future<void> initNotifications()async{
    await _firebaseMessaging.requestPermission();
    // final fcmToken=_firebaseMessaging.getToken();
    // print("token=${fcmToken}");
    initPushNotifications();
    initLocalNotifications();
  }

  Future initPushNotifications()async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true,sound: true);
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((event) {
      final notification=event.notification;
      if(notification==null) return;
      localNotification.show(notification.hashCode, notification.title, notification.body,  NotificationDetails(
          android: AndroidNotificationDetails(_androidChannel.id, _androidChannel.name, channelDescription: _androidChannel.description,
              icon:"@drawable/ic_launcher" )
      ),payload:jsonEncode(event.toMap())
      );
    });
  }

  Future initLocalNotifications()async{
    final DarwinInitializationSettings ios = DarwinInitializationSettings(requestSoundPermission: true,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
        print("onDidReceiveLocalNotificationFromIOS==${payload}");
        // didReceiveLocalNotificationStream.add(
        //   ReceivedNotification(
        //     id: id,
        //     title: title,
        //     body: body,
        //     payload: payload,
        //   ),
        // );
      },
    );

    const android=AndroidInitializationSettings("@drawable/ic_launcher");
   var  settings=InitializationSettings(android: android, iOS: ios);
   await localNotification.initialize(settings,onDidReceiveNotificationResponse: (payload){
     final message=RemoteMessage.fromMap(jsonDecode(payload.payload!));
     handleMessage(message);
   });

    final platform=localNotification.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);

  }

  void handleMessage(RemoteMessage? message){
    //open to a page
  }


}