part of 'user_repository.dart';

class UserRepositoryHardcoded extends UserRepository {
  User? _user;

  Future<User> getUser({String? userId, String? email}) async {
    if (_user != null) return _user!;

    return Future.delayed(
      const Duration(milliseconds: 300),
      () => _user = User(
        id: 'id',
        firstName: 'Hadiya',
        lastName: 'Aamir',
        email: 'h.aamir@gmail.com',
        username: 'hadiya',
      ),
    );
  }

  @override
  Future<void> updateUser({required User user, required String userId}) {
    throw UnimplementedError();
  }

  @override
  void resetUser() {
    _user = null;
  }

  @override
  Future<void> createUser({required String userId, required User user}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> userProfileCreated(
      {required String userId, required String email}) {
    throw UnimplementedError();
  }

  @override
  Future<List<User>> getUsersById(List<String> userIds) {
    throw UnimplementedError();
  }

  @override
  Future<User?> getUserByIdentifier({required String identifier}) {
    throw UnimplementedError();
  }
}
