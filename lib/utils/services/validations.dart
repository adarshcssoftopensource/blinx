import 'package:blinx_mobile/utils/services/regex_constants.dart';

import '../screens/string_constants.dart';

String? emptyStringValidation({String? value, String? msg, int? stringLength}) {
  if (value?.isEmpty ?? false) {
    return msg;
  }
  if ((value?.length ?? 0) > (stringLength ?? 300)) {
    return "Maximum ${stringLength.toString()} characters allowed";
  }
  return null;
}

String? emptySpaceStringValidation({
  String? value,
  String? msg,
  int? stringLength,
}) {
  if (value?.isEmpty ?? false) {
    return msg;
  }
  if (value != null && value.trimLeft().length < value.length) {
    return "Leading spaces are not allowed";
  }
  if ((value?.length ?? 0) > (stringLength ?? 300)) {
    return "Maximum ${stringLength.toString()} characters allowed";
  }
  return null;
}

String? emptyDigitValidation({String? value, String? msg, int? stringLength}) {
  if (value?.isEmpty ?? false) {
    return msg;
  }
  if ((value?.length ?? 0) > (stringLength ?? 40)) {
    return "Maximum ${stringLength.toString()} digits allowed";
  }
  return null;
}

String? emptyDigitMinValidation({
  String? value,
  String? msg,
  int? stringLength,
}) {
  if (value?.isEmpty ?? false) {
    return msg;
  }
  if ((value?.length ?? 0) < (stringLength ?? 4)) {
    return 'Please Enter 4 digit verification code';
  }
  if ((value?.length ?? 0) > (stringLength ?? 40)) {
    return "Maximum ${stringLength.toString()} digits allowed";
  }
  return null;
}

String? summaryValidation({
  String? value,
  required String errorMessage,
  int maxLength = 100,
}) {
  if (value?.isEmpty ?? false) {
    return errorMessage;
  } else if ((value?.length ?? 0) > maxLength) {
    return "Maximum ${maxLength.toString()} characters allowed";
  }
  return null;
}

String? postTextValidation({String? value, int maxLength = 100}) {
  if ((value?.length ?? 0) > maxLength) {
    return "Maximum ${maxLength.toString()} characters allowed";
  }
  return null;
}

String? linkValidation(String? value, String? msg) {
  if (value?.isEmpty ?? false) {
    return msg;
  } else if (!RegExp(RegexConstants.link).hasMatch(value ?? '')) {
    return msg;
  }
  return null;
}

String? newEmailValidation(String? value) {
  if (value?.isEmpty ?? false) {
    return AppConstants.requiredEmail;
  } else if (!RegExp(RegexConstants.emailRegex).hasMatch(value ?? '')) {
    return AppConstants.validEmailError;
  }
  return null;
}

//
String? passwordValidation(String? value) {
  if (value?.isEmpty ?? false) {
    return AppConstants.requiredPassword;
  } else if (!RegExp(RegexConstants.passwordRegex).hasMatch(value ?? '')) {
    return AppConstants.requiredPasswordInPattern;
  }
  return null;
}

String? oldPasswordValidation(String? value) {
  if (value?.isEmpty ?? false) {
    return AppConstants.requiredOldPassword;
  }
  return null;
}

String? newPasswordValidation(String? value) {
  if (value?.isEmpty ?? false) {
    return AppConstants.requiredNewPassword;
  } else if (!RegExp(RegexConstants.passwordRegex).hasMatch(value ?? '')) {
    return AppConstants.requiredPasswordInPattern;
  }
  return null;
}

String? confPasswordValidation(String password, String confPassword) {
  if (password.trim() != confPassword.trim()) {
    return AppConstants.passwordDoesNotMatch;
  }
  return null;
}
