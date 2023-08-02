import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_list/authentication/authentication.dart';
import 'package:shopping_list/login/login.dart';
import 'package:shopping_list/profile/profile.dart';
import 'package:shopping_list/shopping_lists/shopping_lists.dart';
import 'package:shopping_list/signup/view/view.dart';

import 'package:shopping_list/splash/splash.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/signup',
        builder: (BuildContext context, GoRouterState state) {
          return const SignupPage();
        },
      ),
      GoRoute(
        path: '/createProfile',
        builder: (BuildContext context, GoRouterState state) {
          return const CreateProfilePage();
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (BuildContext context, GoRouterState state) {
          return const ProfilePage();
        },
      ),
      GoRoute(
        path: '/verifyEmail',
        builder: (BuildContext context, GoRouterState state) {
          return const VerifyEmailPage();
        },
      ),
      GoRoute(
        path: '/shoppingLists',
        builder: (BuildContext context, GoRouterState state) {
          return const ShoppingListsPage();
        },
      ),
    ],
  );

  static GoRouter get router => _router;
}
