import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.id,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String id;

  @override
  List<Object?> get props => [firstName, lastName, email, username, id];

  User copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? username,
    String? id,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      username: username ?? this.username,
      id: id ?? this.id,
    );
  }

  static const empty = User(
    firstName: '',
    lastName: '',
    email: '',
    username: '',
    id: '',
  );

  bool get profileCreated => this != empty.copyWith(email: this.email);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['username'] = username;
    data['id'] = id;
    return data;
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      username: json['username'],
      id: json['id'],
    );
  }
}
