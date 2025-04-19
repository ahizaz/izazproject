import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin();
  void initLocalNotifications(BuildContext context,RemoteMessage message)async{

  var androidInitilazationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
     var iosInitializationSettings = const DarwinInitializationSettings();
     var initializationSetting = InitializationSettings(
       android:androidInitilazationSettings,
       iOS: iosInitializationSettings,
     );
     await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveBackgroundNotificationResponse: (payload){

      }
     );
  }
  Future<void>showNotification(RemoteMessage message)async{
 AndroidNotificationChannel channel = AndroidNotificationChannel(
     message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString() ,
      importance: Importance.max  ,
      showBadge: true ,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('jetsons_doorbell')
 );
 AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(  
      channel.id.toString(),
      channel.name.toString() ,
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high ,
      playSound: true,
      ticker: 'ticker' ,
         sound: channel.sound);
        
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
          message.hashCode, // Unique ID for the notification
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails ,
      );
    });
  
  }
  void firebaseInit(){

    FirebaseMessaging.onMessage.listen((message){
     if(kDebugMode){
      print(message.notification!.title.toString());
     print(message.notification!.body.toString());
     }
     showNotification(message);

    });
  }
  void requestNotificationPermission()async{

    NotificationSettings settings = await messaging.requestPermission(
     alert: true,
     announcement: true,
     badge: true,
     carPlay: true,
     criticalAlert: true,
     provisional: true,
     sound: true
    );
    if(settings.authorizationStatus==AuthorizationStatus.authorized){
      print('user granted permission');
    }else if(settings.authorizationStatus==AuthorizationStatus.provisional){
      print('User granted provisional permission');

    }else{
      print('wrong ...User deined permission');
      
    }
  }
  Future<String>getDeviceToken()async{
            String? token = await messaging.getToken();
             print("Token from service: $token");
            return token!;
  }
   void isTokenRefresh()async{
    messaging.onTokenRefresh.listen((event){
     event.toString();
     if(kDebugMode){
      print('refresh');
     }
    });
   }
 }

