part of 'model.dart';

class RoleUser extends Equatable {
  const RoleUser({required this.user, required this.listUser});

  final User user;
  final ListUser listUser;

  @override
  List<Object?> get props => [user, listUser];
}
