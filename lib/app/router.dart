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
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const SignupPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
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
