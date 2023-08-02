part of 'profile_bloc.dart';

final class ProfileState extends Equatable {
  const ProfileState({
    this.status = FormzSubmissionStatus.initial,
    this.firstName = const StringInput.pure(),
    this.lastName = const StringInput.pure(),
    this.username = const StringInput.pure(),
    this.isValid = false,
    this.errorMessage,
  });

  final FormzSubmissionStatus status;
  final StringInput firstName;
  final StringInput lastName;
  final StringInput username;
  final bool isValid;
  final String? errorMessage;

  ProfileState copyWith({
    FormzSubmissionStatus? status,
    StringInput? firstName,
    StringInput? lastName,
    StringInput? username,
    bool? isValid,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, firstName, lastName, username, errorMessage];
}
