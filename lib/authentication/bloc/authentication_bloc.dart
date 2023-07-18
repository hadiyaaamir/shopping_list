import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthenticationState.unknown()) {
    on<_AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    on<AuthenticationUserChanged>(_onAuthenticationUserChanged);
    on<AuthenticationSendVerificationEmail>(
        _onAuthenticationSendVerificationEmail);
    on<AuthenticationEmailVerified>(_onAuthenticationEmailVerified);

    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(_AuthenticationStatusChanged(status)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(
    _AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unknown:
        return emit(const AuthenticationState.unknown());

      case AuthenticationStatus.unauthenticated:
        print('unauthenticated user');
        return emit(const AuthenticationState.unauthenticated());

      case AuthenticationStatus.authenticated:
        final authUser = _authenticationRepository.currentAuthUser;
        final profileCreated = await _getUserProfileCreated(authUser: authUser);
        final emailVerified = _authenticationRepository.isEmailVerfied;

        print('authenticated user: $authUser');
        return emit(
          authUser != null
              ? AuthenticationState.authenticated(
                  user: authUser,
                  profileCreated: profileCreated,
                  emailVerified: emailVerified,
                )
              : const AuthenticationState.unauthenticated(),
        );
    }
  }

  _getUserProfileCreated({AuthUser? authUser}) async {
    return authUser == null
        ? false
        : await _userRepository.userProfileCreated(
            email: authUser.email,
            userId: authUser.id,
          );
  }

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.logOut();
    _userRepository.resetUser();
  }

  Future<void> _onAuthenticationUserChanged(
    AuthenticationUserChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    final user = _authenticationRepository.currentAuthUser;

    return emit(
      user != null
          ? AuthenticationState.authenticated(user: user)
          : const AuthenticationState.unauthenticated(),
    );
  }

  Future<void> _onAuthenticationSendVerificationEmail(
    AuthenticationSendVerificationEmail event,
    Emitter<AuthenticationState> emit,
  ) async {
    final authUser = _authenticationRepository.currentAuthUser;
    if (authUser != null) {
      await _authenticationRepository.sendEmailVerification();
    }
  }

  void _onAuthenticationEmailVerified(
    AuthenticationEmailVerified event,
    Emitter<AuthenticationState> emit,
  ) {
    final currentState = state;
    if (currentState.status == AuthenticationStatus.authenticated) {
      final user = _authenticationRepository.currentAuthUser;
      return emit(
        user != null
            ? AuthenticationState.authenticated(user: user, emailVerified: true)
            : const AuthenticationState.unauthenticated(),
      );
    }
  }
}
