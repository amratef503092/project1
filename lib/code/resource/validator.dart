
import 'package:form_field_validator/form_field_validator.dart';

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'password is required'),
  MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
  PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'passwords must have at least one special character')
]);
final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'Email is required'),
  EmailValidator(errorText: 'enter a valid email address',),
]);
final phoneValidator = MultiValidator([
  RequiredValidator(errorText: 'phone is required'),
  PatternValidator(r'(^(?:[+0]9)?[0-9]{10,12}$)', errorText: 'phone Number is Not valid')
]);
final numberValidator = MultiValidator([
  RequiredValidator(errorText: 'age is required'),
  PatternValidator(r'(^(?:[+0]9)?[0-9]{10,12}$)'
, errorText: 'age must be number')
]);
