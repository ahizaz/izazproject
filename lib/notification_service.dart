import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:izazproject/pages/messagescreen.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initLocalNotifications(BuildContext context) async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null && payload == 'ssdsd') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MessageScreen()),
          );
        }
      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    final channelId = message.notification?.android?.channelId ?? 'high_importance_channel';

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      channelId,
      importance: Importance.max,
      showBadge: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('jetsons_doorbell'), // optional
    );

    // ✅ Register channel
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: 'Your channel description',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      sound: channel.sound,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
      payload: message.data['type'] ?? '',
    );
  }

  void firebaseInit(BuildContext context) {
    initLocalNotifications(context);

    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print("🔔 Foreground Notification:");
        print("Title: ${message.notification?.title}");
        print("Body: ${message.notification?.body}");
        print("Data: ${message.data}");
      }
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(context, message);
    });
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('⚠️ User granted provisional permission');
    } else {
      print('❌ User denied permission');
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    print("📱 Device Token: $token");
    return token!;
  }

  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((token) {
      if (kDebugMode) {
        print('🔄 Token refreshed: $token');
      }
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'ssdsd') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MessageScreen()),
      );
    }
  }
}
