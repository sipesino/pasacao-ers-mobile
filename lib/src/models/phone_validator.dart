import 'package:form_field_validator/form_field_validator.dart';

class PhoneValidator extends TextFieldValidator {
  // pass the error text to the super constructor
  PhoneValidator({String errorText = 'Enter a valid PH phone number'})
      : super(errorText);

  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String? value) {
    // return true if the value is valid according the your condition
    return hasMatch(r'^(09|\+639)\d{9}$', value!);
  }
}
