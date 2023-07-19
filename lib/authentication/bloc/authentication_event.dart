part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

final class _AuthenticationStatusChanged extends AuthenticationEvent {
  const _AuthenticationStatusChanged(this.status);
  final AuthenticationStatus status;
}

final class AuthenticationLogoutRequested extends AuthenticationEvent {}

final class AuthenticationUserChanged extends AuthenticationEvent {}

final class AuthenticationSendVerificationEmail extends AuthenticationEvent {}

final class AuthenticationCheckEmail extends AuthenticationEvent {}
