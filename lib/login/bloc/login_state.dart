part of 'login_bloc.dart';

final class LoginState extends Equatable {
  const LoginState({
    this.status = FormzSubmissionStatus.initial,
    this.email = const StringInput.pure(),
    this.password = const StringInput.pure(),
    this.isValid = false,
    this.errorMessage,
  });

  final FormzSubmissionStatus status;
  final StringInput email;
  final StringInput password;
  final bool isValid;
  final String? errorMessage;

  LoginState copyWith({
    FormzSubmissionStatus? status,
    StringInput? email,
    StringInput? password,
    bool? isValid,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, email, password];
}
