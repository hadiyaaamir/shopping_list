import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.id,
    required this.token,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String id;
  final String token;

  @override
  List<Object?> get props => [firstName, lastName, email, username, id];

  User copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? username,
    String? id,
    String? token,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      username: username ?? this.username,
      id: id ?? this.id,
      token: token ?? this.token,
    );
  }

  static const empty = User(
    firstName: '',
    lastName: '',
    email: '',
    username: '',
    id: '',
    token: '',
  );

  bool get profileCreated => this != empty.copyWith(email: this.email);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['username'] = username;
    data['id'] = id;
    data['token'] = token;
    return data;
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      username: json['username'],
      id: json['id'],
      token: json['token'] ?? '',
    );
  }
}
