

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

            try {
              final response =
              await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization':
                    'key=AAAAU9Lgttw:APA91bHYsa-K8NSyj_t7QYmNScsevaLFAY66I-AjnhePaTt9exBplGVDyvVCL0W22h1cZnBQ5b-BCnA1qzXrBSyl3OsTI0-PKNLTuGyci9mi_pEYkgSROHeiKqlQLcpdJS21Eu68SHr7',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'priority': 'high',
                    'data': <String, dynamic>{
                      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                      'status': 'done',
                      "title": 'title',
                      "body": 'body',
                    },
                    'notification': <String, dynamic>{
                      "title": 'title',
                      "body": 'body',
                      "android_channel_id": "dbfood"
                    },
                    "to": 'fUT-4rnQRGOCz14f1bvTAS:APA91bHvWt-bPfWhtJ0wcR5KdsM_8X53XnrIya4Gv0QeVGVQf04JoUapc7IHQ10H75brkU9tPpNVUMi4gxMrPJi23N3n78EadQkNy1haZG4i1oxpXg_GZwMOJ8ppU_uOCHlwvFSdrhTD',
                  }));
              print(response.body.toString());
              print(response.statusCode.toString());

            } catch (e) {
              print(e);
              if (kDebugMode) {
                print("error push notifications");
              }
            }

            // notificationServices.getDeviceToken().then((value) async {{
            //   print(value.toString());
            //   Map data =  {
            //     "message":{
            //       "token" :  value.toString(),
            //       "priority": "high",
            //       "mutable_content": true,
            //       "notification":{
            //         "title":"FCM Message",
            //         "body":"This is an FCM notification message!",
            //       }
            //     }
            //   };
            //   var response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            //       body: json.encode(data),
            //       headers: {
            //         'Content-Type': 'application/json' ,
            //         'Authorization': 'key=AAAAU9Lgttw:APA91bHYsa-K8NSyj_t7QYmNScsevaLFAY66I-AjnhePaTt9exBplGVDyvVCL0W22h1cZnBQ5b-BCnA1qzXrBSyl3OsTI0-PKNLTuGyci9mi_pEYkgSROHeiKqlQLcpdJS21Eu68SHr7'
            //       }
            //   );
            //
            //   print(response.statusCode.toString());
            // }
            // });

          },
          child: Text('Send'),
        ),
      ),
    );
  }
}
