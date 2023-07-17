import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.designation,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String designation;

  @override
  List<Object?> get props => [firstName, lastName, email, designation];

  User copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? designation,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      designation: designation ?? this.designation,
    );
  }

  static const empty = User(
    firstName: '',
    lastName: '',
    email: '',
    designation: '',
  );

  bool get profileCreated => this != empty.copyWith(email: this.email);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['designation'] = designation;
    return data;
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      designation: json['designation'],
    );
  }
}
