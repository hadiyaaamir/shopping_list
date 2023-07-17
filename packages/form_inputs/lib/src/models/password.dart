part of 'models.dart';

enum PasswordValidationError { empty, invalid }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    return value.isEmpty
        ? PasswordValidationError.empty
        : value.length < 8
            ? PasswordValidationError.invalid
            : null;
  }
}
