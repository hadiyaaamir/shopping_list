part of 'messaging_repository.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class MessagingRepositoryFirebase extends MessagingRepository {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final UserRepository _userRepository = UserRepositoryFirebase();
  final ShoppingListRepository _shoppingListRepository =
      ShoppingListRepositoryFirebase();

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.defaultImportance,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  MessagingRepositoryFirebase({required super.notificationNavigation});

  Future<void> setupToken(String userId) async {
    String? fcmToken = await _firebaseMessaging.getToken();
    if (fcmToken != null) {
      await _userRepository.saveToken(token: fcmToken, userId: userId);
    }
    FirebaseMessaging.instance.onTokenRefresh.listen(
      (token) => _userRepository.saveToken(token: token, userId: userId),
    );
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    initPushNotifications();
    initLocalNotifications();
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            badgeNumber: 0,
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  void handleMessage(RemoteMessage? message) async {
    if (message == null) return;

    ShoppingList? shoppingList = await _shoppingListRepository.getListFromId(
      message.data['listId'],
    );
    if (shoppingList != null) notificationNavigation();
  }

  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        final message = RemoteMessage.fromMap(jsonDecode(details.payload!));
        handleMessage(message);
      },
    );

    if (Platform.isAndroid) {
      final platform =
          _localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await platform?.createNotificationChannel(_androidChannel);
    } else if (Platform.isIOS) {
      final platform =
          _localNotifications.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      await platform?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  void sendPushMessage({
    required String token,
    String title = '',
    String body = '',
    String? listId,
  }) async {
    if (token.isEmpty) {
      print('token is empty');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$kServerKey'
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
          },
          'data': <String, dynamic>{
            'status': 'done',
            'title': title,
            'body': body,
            'listId': listId,
          },
          'to': token,
        }),
      );

      print('notification sent to $token \n title: $title \n body: $body');
    } catch (e) {
      print("error push notification $e");
    }
  }
}
