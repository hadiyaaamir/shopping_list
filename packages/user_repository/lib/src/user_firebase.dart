part of 'user_repository.dart';

class UserRepositoryFirebase extends UserRepository {
  User? _user;

  final usersCollection = FirebaseFirestore.instance.collection("Users");

  Future<User> getUser({String? userId, String? email}) async {
    // if (_user != null) return _user!;

    if (userId != null) {
      await usersCollection.doc(userId).get().then((snapshot) async {
        if (snapshot.exists) {
          _user = User.fromJson(snapshot.data()!);
        } else if (email != null) {
          _user = User.empty.copyWith(email: email);
        }
      });
    } else {
      _user = User.empty;
    }
    return _user!;
  }

  Future<List<User>> getUsersById(List<String> userIds) async {
    try {
      final List<User> users = [];

      for (String userId in userIds) {
        final snapshot = await usersCollection.doc(userId).get();
        if (snapshot.exists) {
          final user = User.fromJson(snapshot.data()!);
          users.add(user);
        } else {
          // If the document doesn't exist, add a default empty User
          users.add(User.empty);
        }
      }
      return users;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> userProfileCreated(
      {required String userId, required String email}) async {
    resetUser();
    final user = await getUser(email: email, userId: userId);
    return user != User.empty.copyWith(email: email);
  }

  Future<void> createUser({required String userId, required User user}) async {
    await usersCollection
        .doc(userId)
        .set(user.toJson())
        .then((_) => _user = user);
  }

  @override
  Future<void> updateUser({required String userId, required User user}) async {
    await usersCollection
        .doc(userId)
        .update(user.toJson())
        .then((value) => _user = user);
  }

  void resetUser() => _user = null;
}
