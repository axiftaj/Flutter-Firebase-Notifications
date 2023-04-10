

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_notifications/notification_services.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  NotificationServices notificationServices = NotificationServices();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value){
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Notifications'),
      ),
      body: Center(
        child: TextButton(onPressed: (){

          // send notification from one device to another
          notificationServices.getDeviceToken().then((value)async{

            // this functions is for firebase team to fix the error with android key
            // var data = {
            //   'to' : value.toString(),
            //   'priority' : 'high' ,
            //   'android' : {
            //     'notification' : {
            //       'title' : 'Asif' ,
            //       'body' : 'Subscribe to my channel' ,
            //       'android_channel_id': "Messages" ,
            //       'count' : 10 ,
            //       'notification_count' : 12,
            //       'badge' : 12,
            //       "click_action": 'asif',
            //       'color' : '#eeeeee' ,
            //     },
            //   },
            //   'data' : {
            //     'type' : 'msj' ,
            //     'id' : 'asif1245' ,
            //   }
            // };

            // use this function for sending notification

            var data = {
              'to' : value.toString(),
              'priority' : 'high' ,
              'notification' : {
                'title' : 'Asif' ,
                'body' : 'Subscribe to my channel' ,
                'android_channel_id': "Messages" ,
                "click_action": 'asif',
                'color' : '#eeeeee' ,
                //  "image": "https://thenounproject.com/api/private/icons/3689664/edit/?backgroundShape=SQUARE&backgroundShapeColor=%23000000&backgroundShapeOpacity=0&exportSize=752&flipX=false&flipY=false&foregroundColor=%23000000&foregroundOpacity=1&imageFormat=png&rotation=0&token=gAAAAABkHsA94b5pKR5LehBItBteXKuyINT-tsnY1GXXWF7BQgfpnw9LuXqcAGuWMSP3O1CN2io4htufEDwNvCL7n8PAi9K_1Q%3D%3D"
            },
              'android': {
                'notification': {
                  'notification_count': 23,
                },
              },
              'data' : {
                'type' : 'msj' ,
                'id' : 'asif1245' ,
              }
            };

            await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            body: jsonEncode(data) ,
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization' : 'key=AAAAp9pXDFM:APA91bGhBeMCUABE2PXjl9UqodAZ2WdV_UI6PoiwdCzYaT8KeZmBKZszc01CD1GgN0OAJ1w3sNw9IVISyKhrrxQLASHizenGJUr2hjzoPjbjFu0HAx1CTk0l8Ut95ZENAQyRKm6hrltV'
              }
            ).then((value){

            });
          });
        },
            child: Text('Send Notifications')),
      ),
    );
  }
}
