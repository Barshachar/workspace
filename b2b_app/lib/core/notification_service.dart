import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'router/app_router.dart';

class NotificationService {
  static final _messaging = FirebaseMessaging.instance;
  static final bannerKey = GlobalKey<ScaffoldMessengerState>();

  static Future<void> init() async {
    await _messaging.requestPermission();
    FirebaseMessaging.onMessage.listen((m) {
      final text = m.notification?.body ?? '';
      bannerKey.currentState?.showSnackBar(SnackBar(content: Text(text)));
    });
    FirebaseMessaging.onMessageOpenedApp.listen((m) {
      final id = m.data['order_id'];
      if (id != null) {
        router.go('/orders/$id');
      }
    });
  }

  static Future<void> subscribeTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }
}
