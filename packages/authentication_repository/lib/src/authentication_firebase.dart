part of 'authentication_repository.dart';

class AuthenticationRepositoryFirebase extends AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  @override
  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((_) => _controller.add(AuthenticationStatus.authenticated));
    } on firebase_auth.FirebaseAuthException catch (e) {
      _controller.add(AuthenticationStatus.unauthenticated);
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      _controller.add(AuthenticationStatus.unauthenticated);
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  @override
  Future<void> logIn({required String email, required String password}) async {
    try {
      await _firebaseAuth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (value) {
          _controller.add(AuthenticationStatus.authenticated);
        },
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      _controller.add(AuthenticationStatus.unauthenticated);
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (e) {
      _controller.add(AuthenticationStatus.unauthenticated);
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]).then((_) => _controller.add(AuthenticationStatus.unauthenticated));
    } catch (e) {
      throw LogOutFailure();
    }
  }

  @override
  void dispose() => _controller.close();

  @override
  AuthUser? get currentAuthUser => _firebaseAuth.currentUser != null
      ? AuthUser(
          id: _firebaseAuth.currentUser!.uid,
          email: _firebaseAuth.currentUser!.email!,
        )
      : null;
}

class SignUpWithEmailAndPasswordFailure implements Exception {
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  final String message;

  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
          'An account already exists for this email.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
          'Please enter a stronger password.',
        );
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }
}

class LogInWithEmailAndPasswordFailure implements Exception {
  const LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  final String message;

  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure(
          'Incorrect credentials, please try again.',
        );
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailure(
          'Incorrect credentials, please try again.',
        );
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }
}

class LogOutFailure implements Exception {}
