part of 'services.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static FlutterLocalNotificationsPlugin? _localNotificationsPlugin;
  static final math.Random _random = math.Random();

  static void initialize() {
    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var androidInitialize = const AndroidInitializationSettings('ic_launcher');
    var iosInitialize = const IOSInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);
    _localNotificationsPlugin?.initialize(initializationsSettings);

    _localNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    _localNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static Future<void> showNotification(
      {required String? title, required String? body}) async {
    var _androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      importance: _channel.importance,
      priority: Priority.high,
    );

    var _iOSDetails = const IOSNotificationDetails();

    var _generalNotificationDetails =
        NotificationDetails(android: _androidDetails, iOS: _iOSDetails);

    return _localNotificationsPlugin?.show(
      _random.nextInt(9999),
      title,
      body,
      _generalNotificationDetails,
    );
  }

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    appName,
    'Notifications',
    importance: Importance.high,
  );
}
