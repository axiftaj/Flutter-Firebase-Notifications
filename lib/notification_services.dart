

import 'dart:io';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_notifications/message_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationServices {

  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance ;

  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin  = FlutterLocalNotificationsPlugin();

  // function to request notifications permissions
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


  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications(BuildContext context, RemoteMessage message)async{
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings ,
        iOS: iosInitializationSettings
    );

    await _flutterLocalNotificationsPlugin.initialize(
        initializationSetting,
      onDidReceiveNotificationResponse: (payload){
          // handle interaction when app is active for android
          handleMessage(context, message);
      }
    );
  }

  void firebaseInit(BuildContext context){


    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
        print(message.data.toString());
        print(message.data['type']);
        print(message.data['id']);
      }

      //show notificaiton when app is active
      if(Platform.isAndroid){
        //calling this function to handle internation
        initLocalNotifications(context , message);
        showNotification(message);
      }else {
        showNotification(message);
      }
    });
  }


  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message)async{


    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
      'High Importance Notifications',
      importance: Importance.max
    );


    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString() ,
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high ,
      ticker: 'ticker'
    );

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true ,
      presentBadge: true ,
      presentSound: true
    ) ;

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails
    );

    Future.delayed(Duration.zero , (){
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });

  }


  //function to get device token on which we will send the notifications
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

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context)async{

    // when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if(initialMessage != null){
      handleMessage(context, initialMessage);
    }


    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });

  }


  void handleMessage(BuildContext context, RemoteMessage message) {

    if(message.data['type'] =='msj'){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MessageScreen(
            id: message.data['id'] ,
          )));
    }
  }


}