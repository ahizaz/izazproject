import 'package:flutter/material.dart';
import 'package:izazproject/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 NotificationService notificationService =NotificationService();
 
@override
  void initState() {
  
    super.initState();
    notificationService.requestNotificationPermission();
    notificationService.firebaseInit();
    notificationService.isTokenRefresh();
    notificationService.getDeviceToken().then((value){
     print('device token');
     print(value);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Izaz Ahmed'),
      ),
      body: const Center(
        child: Text('Firebase Notification Demo'),
      ),
    );
  }
}
