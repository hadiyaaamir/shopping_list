import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

part 'authentication_hardcoded.dart';
part 'authentication_firebase.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

abstract class AuthenticationRepository {
  Stream<AuthenticationStatus> get status;

  Future<void> logIn({required String email, required String password});
  Future<void> signUp({required String email, required String password});

  void logOut();
  void dispose();

  AuthUser? get currentAuthUser;
}
