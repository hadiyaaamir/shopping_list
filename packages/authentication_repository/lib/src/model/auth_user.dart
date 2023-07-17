import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.email,
  });

  final String id;
  final String email;

  AuthUser copyWith({String? id, String? email}) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
    );
  }

  static const empty = AuthUser(id: '', email: '');

  @override
  List<Object?> get props => [id, email];
}
