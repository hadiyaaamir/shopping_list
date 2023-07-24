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
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  void resetUser() {
    _user = null;
  }

  @override
  Future<void> createUser({required String userId, required User user}) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<bool> userProfileCreated(
      {required String userId, required String email}) {
    // TODO: implement userProfileCreated
    throw UnimplementedError();
  }

  @override
  Future<List<User>> getUsersById(List<String> userIds) {
    // TODO: implement getUsersById
    throw UnimplementedError();
  }

  @override
  Future<User?> getUserByIdentifier({required String identifier}) {
    // TODO: implement getUserByIdentifier
    throw UnimplementedError();
  }
}
