part of 'signup_bloc.dart';

final class SignupState extends Equatable {
  const SignupState({
    this.status = FormzSubmissionStatus.initial,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.isValid = false,
    this.errorMessage,
  });

  final FormzSubmissionStatus status;
  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final bool isValid;
  final String? errorMessage;

  SignupState copyWith({
    FormzSubmissionStatus? status,
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    bool? isValid,
    String? errorMessage,
  }) {
    return SignupState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, email, password, confirmedPassword];
}
