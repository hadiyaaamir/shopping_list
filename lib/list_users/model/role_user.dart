part of 'model.dart';

class RoleUser extends Equatable {
  const RoleUser({required this.user, required this.listUser});

  final User user;
  final ListUser listUser;

  RoleUser copyWith({User? user, ListUser? listUser}) =>
      RoleUser(user: user ?? this.user, listUser: listUser ?? this.listUser);

  @override
  List<Object?> get props => [user, listUser];
}
