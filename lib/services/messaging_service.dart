part of 'services.dart';

typedef RemoteMessageHandler = void Function(RemoteMessage message);

abstract class MessagingHandler {
  void getInitialMessage();

  void onMessage();

  void onMessageOpenedApp();
}

class MessagingService {
  MessagingService._();

  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<String?>? getToken() {
    try {
      return _firebaseMessaging.getToken();
    } catch (e) {
      return null;
    }
  }

  static Future<NotificationSettings> requestPermission() async {
    _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    return await _firebaseMessaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      provisional: false,
    );
  }

  static void getInitialMessage(RemoteMessageHandler handler) {
    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        handler(message);
      }
    });
  }

  static void onMessage(RemoteMessageHandler handler) {
    FirebaseMessaging.onMessage.listen(handler, cancelOnError: true);
  }

  static void onMessageOpenedApp(RemoteMessageHandler handler) {
    FirebaseMessaging.onMessageOpenedApp.listen(handler, cancelOnError: true);
  }

  static void onBackgroundMessage(BackgroundMessageHandler handler) {
    FirebaseMessaging.onBackgroundMessage(handler);
  }

  static Future<void> deleteToken() {
    return _firebaseMessaging.deleteToken();
  }
}
