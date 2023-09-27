import 'dart:convert';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list_repository/shopping_list_repository.dart';
import 'package:user_repository/user_repository.dart';

import 'keys.dart';

part 'messaging_repository_firebase.dart';

abstract class MessagingRepository {
  Future<void> initNotifications();

  MessagingRepository({required this.notificationNavigation});

  Function() notificationNavigation;

  void sendPushMessage({
    required String token,
    String title = '',
    String body = '',
    String? listId,
  });

  Future<void> setupToken(String userId);
}
