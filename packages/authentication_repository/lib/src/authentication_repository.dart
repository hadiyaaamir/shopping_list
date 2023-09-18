import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';

part 'authentication_hardcoded.dart';
part 'authentication_firebase.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  unverified,
}

abstract class AuthenticationRepository {
  Stream<AuthenticationStatus> get status;

  Future<void> logIn({required String email, required String password});
  Future<void> signUp({required String email, required String password});

  void logOut();
  void dispose();

  AuthUser? get currentAuthUser;
  Future<bool> get isEmailVerfied;
  Future<void> sendEmailVerification();
}
