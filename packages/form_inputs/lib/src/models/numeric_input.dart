part of 'models.dart';

enum NumericInputValidationError { empty, invalid }

class NumericInput extends FormzInput<String, NumericInputValidationError> {
  final bool allowEmpty;

  const NumericInput.pure({this.allowEmpty = false}) : super.pure('');
  const NumericInput.dirty({this.allowEmpty = false, String value = ''})
      : super.dirty(value);

  @override
  NumericInputValidationError? validator(String value) {
    RegExp numericRegExp = RegExp(r'^(?:\d+(\.\d+)?|\d*\.\d+|\d+/\d*)?$');

    return value.isEmpty && !allowEmpty
        ? NumericInputValidationError.empty
        : !numericRegExp.hasMatch(value)
            ? NumericInputValidationError.invalid
            : null;
  }
}
