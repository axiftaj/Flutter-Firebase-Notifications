

import 'dart:io';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {

  FirebaseMessaging messaging = FirebaseMessaging.instance ;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin() ;


  initLocalNotifications(BuildContext context, RemoteMessage message)async{
    var initilizationSettingAndroid  = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initilizationSettingIOS = const DarwinInitializationSettings();

    var initializationSettings  = InitializationSettings(android:initilizationSettingAndroid, iOS: initilizationSettingIOS );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings ,
      onDidReceiveNotificationResponse: (payload){

      }
    );
  }

  void requestNotificationPermission()async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true ,
      announcement: true ,
      badge: true ,
      carPlay:  true ,
      criticalAlert: true ,
      provisional: true ,
      sound: true
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('user granted permission');
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('user granted provisional permission');

    }else {
      AppSettings.openNotificationSettings();
      print('user denied permission');

    }
  }




  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh()async{
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print('refresh');
    });
  }



  void firebaseInit(BuildContext context){

    FirebaseMessaging.onMessage.listen((event) {
      if (kDebugMode) {
        print(event.notification!.title.toString());
        print(event.notification!.body.toString());
        print(event.messageId.toString());
        print(event.data.toString());
      }


      if(Platform.isAndroid){
        initLocalNotifications(context, event);
      }

      showNotifications(event);


    });
  }


  Future<void> showNotifications(RemoteMessage message)async{

     AndroidNotificationChannel channel = AndroidNotificationChannel(
       Random.secure().nextInt(10000).toString(), // id
      'High Importance Notifications', // title
      importance: Importance.max,
    );
     AndroidNotificationDetails androidNotificationDetails =  AndroidNotificationDetails(
        channel.id,
        channel.name.toString(),
        channelDescription: 'your channel description',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker'

    );


    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentSound: true ,
      presentBadge: true ,
      presentAlert: true
    );

     NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails
    );

    Future.delayed(Duration.zero , (){
      _flutterLocalNotificationsPlugin.show(
          1,
          message.notification!.title.toString(),
          message.notification!.title.toString(),
          notificationDetails
      );
    });
  }
}