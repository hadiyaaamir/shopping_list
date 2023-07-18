part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user = AuthUser.empty,
    this.profileCreated = false,
    this.emailVerified = false,
  });

  final AuthenticationStatus status;
  final AuthUser user;
  final bool profileCreated;
  final bool emailVerified;

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated({
    required AuthUser user,
    bool profileCreated = false,
    bool emailVerified = false,
  }) : this._(
          status: AuthenticationStatus.authenticated,
          user: user,
          profileCreated: profileCreated,
          emailVerified: emailVerified,
        );

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  @override
  List<Object> get props => [status, user, profileCreated, emailVerified];
}
