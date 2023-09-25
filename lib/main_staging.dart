import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_repository/messaging_repository.dart';
import 'package:shopping_list/app/app.dart';
import 'package:shopping_list/parent_list/parent_list.dart';

import 'firebase_options_stg.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  MessagingRepository messagingRepository = MessagingRepositoryFirebase(
    notificationNavigation: () => ParentListPage.navigateToScreen(),
  );
  await messagingRepository.initNotifications();

  runApp(
    RepositoryProvider.value(
      value: messagingRepository,
      child: const ShoppingApp(),
    ),
  );
}
