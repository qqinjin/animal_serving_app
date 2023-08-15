import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class YourFirebaseMessagingService {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); 

  Future<void> initialize(BuildContext context) async {
    // 알림 수신 권한 요청
    await _firebaseMessaging.requestPermission();

    // FCM 토큰 수신 및 토큰 업데이트 시 처리할 로직 설정
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      // 토큰이 업데이트될 때 호출되는 로직을 추가합니다.
      // 필요한 경우 토큰을 서버에 등록하거나 처리합니다.
    });

    // 백그라운드에서 수신한 메시지 처리를 위한 설정
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // 알림 수신 처리를 위한 설정
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // 알림 메시지를 수신하고 처리하는 로직을 구현합니다.
      // 원하는 알림 처리 동작을 추가합니다.
      _showNotification(message, context);
    });

    // 앱이 실행 중이고 알림을 터치하여 앱이 포그라운드로 복귀한 경우 처리를 위한 설정
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // 알림을 터치하여 앱이 포그라운드로 복귀했을 때 호출되는 로직을 추가합니다.
      _handleNotificationTap(message, context);
    });
  }

  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    // 백그라운드에서 수신한 메시지 처리를 원하는 방식으로 구현합니다.
    // 알림을 표시하거나 백그라운드 작업을 수행할 수 있습니다.

 
  }

  void _showNotification(RemoteMessage message, BuildContext context) {
    // 알림을 표시하는 로직을 구현합니다.
    // 예를 들어, flutter_local_notifications 패키지를 사용하여 알림을 표시할 수 있습니다.
    // 이 부분은 원하는 방식으로 알림을 처리하는 코드로 변경하면 됩니다.
  }

  void _handleNotificationTap(RemoteMessage message, BuildContext context) {
    // 알림 터치에 대한 처리 로직을 구현합니다.
    // 예를 들어, 특정 화면으로 이동하거나 특정 작업을 수행하는 등의 동작을 추가할 수 있습니다.
  }
}
