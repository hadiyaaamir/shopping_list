import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.email,
    required this.emailVerified,
  });

  final String id;
  final String email;
  final bool emailVerified;

  AuthUser copyWith({String? id, String? email, bool? emailVerified}) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }

  static const empty = AuthUser(id: '', email: '', emailVerified: false);

  @override
  List<Object?> get props => [id, email, emailVerified];
}
