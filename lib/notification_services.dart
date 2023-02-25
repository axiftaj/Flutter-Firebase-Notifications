
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationServices {

  FirebaseMessaging messaging = FirebaseMessaging.instance ;

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
}