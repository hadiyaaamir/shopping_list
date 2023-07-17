part of 'models.dart';

enum StringInputValidationError { empty }

class StringInput extends FormzInput<String, StringInputValidationError> {
  final bool allowEmpty;

  const StringInput.pure({this.allowEmpty = false}) : super.pure('');
  const StringInput.dirty({this.allowEmpty = false, String value = ''})
      : super.dirty(value);

  // const StringInput.dirty([super.value = '']) : super.dirty();

  @override
  StringInputValidationError? validator(String value) {
    return allowEmpty
        ? null
        : value.isEmpty
            ? StringInputValidationError.empty
            : null;
  }
}
