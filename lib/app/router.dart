import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_list/authentication/authentication.dart';
import 'package:shopping_list/login/login.dart';
import 'package:shopping_list/profile/profile.dart';
import 'package:shopping_list/home_page/home_page.dart';
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
            var tween = Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut));
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
            var slideTween =
                Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOut));
            var offsetAnimation = animation.drive(slideTween);

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
          return const HomePagePage();
        },
      ),
    ],
  );

  static GoRouter get router => _router;
}
