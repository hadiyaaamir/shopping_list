part of 'authentication_repository.dart';

class AuthenticationRepositoryHardcoded implements AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
      () => _controller.add(AuthenticationStatus.authenticated),
    );
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();

  @override
  Future<void> signUp({required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  AuthUser? get currentAuthUser => throw UnimplementedError();

  @override
  Future<void> sendEmailVerification() {
    throw UnimplementedError();
  }

  @override
  Future<bool> get isEmailVerfied => throw UnimplementedError();
}
