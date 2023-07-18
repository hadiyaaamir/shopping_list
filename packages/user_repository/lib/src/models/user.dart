import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String username;

  @override
  List<Object?> get props => [firstName, lastName, email, username];

  User copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? username,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      username: username ?? this.username,
    );
  }

  static const empty = User(
    firstName: '',
    lastName: '',
    email: '',
    username: '',
  );

  bool get profileCreated => this != empty.copyWith(email: this.email);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['username'] = username;
    return data;
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      username: json['username'],
    );
  }
}
