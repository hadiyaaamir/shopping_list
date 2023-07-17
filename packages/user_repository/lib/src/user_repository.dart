import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_repository/src/models/models.dart';
part 'user_hardcoded.dart';
part 'user_firebase.dart';

abstract class UserRepository {
  Future<User> getUser({String? userId, String? email});
  Future<void> updateUser({required String userId, required User user});
  Future<void> createUser({required String userId, required User user});
  Future<bool> userProfileCreated(
      {required String userId, required String email});
  void resetUser();
}
