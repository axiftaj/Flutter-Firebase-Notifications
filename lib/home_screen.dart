

import 'dart:convert';

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
    //notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value){
      print('device token');
      print(value);
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Flutter Notifications'),
      ),
      body: Center(
        child: TextButton(
          onPressed: ()async{

            notificationServices.getDeviceToken().then((value) async {{
              print(value.toString());
              Map data =  {
                "message":{
                  "token" :  value.toString(),
                  "priority": "high",
                  "mutable_content": true,
                  "notification":{
                    "title":"FCM Message",
                    "body":"This is an FCM notification message!",
                  }
                }
              };
              var response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                  body: json.encode(data),
                  headers: {
                    'Content-Type': 'application/json' ,
                    'Authorization': 'key=AAAAU9Lgttw:APA91bHYsa-K8NSyj_t7QYmNScsevaLFAY66I-AjnhePaTt9exBplGVDyvVCL0W22h1cZnBQ5b-BCnA1qzXrBSyl3OsTI0-PKNLTuGyci9mi_pEYkgSROHeiKqlQLcpdJS21Eu68SHr7'
                  }
              );

              print(response.statusCode.toString());
            }
            });

          },
          child: Text('Send'),
        ),
      ),
    );
  }
}
