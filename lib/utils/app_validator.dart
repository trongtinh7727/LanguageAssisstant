import 'package:intl/intl.dart';

class Validator {
  static String? min(
      {required int min, required int value, String message = ""}) {
    if (value < min) {
      return message.isNotEmpty ? message : "Giá trị không được nhỏ hơn $min";
    }
    return null;
  }

  static String? max(
      {required int max, required int value, String message = ""}) {
    if (value > max) {
      return message.isNotEmpty ? message : "Giá trị không được lớn hơn $max";
    }
    return null;
  }

  static String? required({dynamic value, String message = ""}) {
    if (value == null || value == '') {
      return message.isNotEmpty ? message : "Trường này là bắt buộc";
    }
    return null;
  }

  static String? requiredTrue(dynamic value) {
    if (value != true) {
      return "Giá trị phải là true";
    }
    return null;
  }

  static String? email({required String? value, String message = ""}) {
    if (value == null || value == '') {
      return message.isNotEmpty ? message : "Trường này là bắt buộc";
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return message.isNotEmpty ? message : "Email không hợp lệ";
    }
    return null;
  }

  static String? minLength(
      {required int minLength, required String value, String message = ""}) {
    if (value.length < minLength) {
      return message.isNotEmpty
          ? message
          : "Độ dài không được nhỏ hơn $minLength ký tự";
    }
    return null;
  }

  static String? maxLength(
      {required int maxLength, required String value, String message = ""}) {
    if (value.length > maxLength) {
      return message.isNotEmpty
          ? message
          : "Độ dài không được lớn hơn $maxLength ký tự";
    }
    return null;
  }

  static String? pattern(
      {required String pattern, required String? value, String message = ""}) {
    if (value == null) {
      return 'Không được để trống';
    }
    if (!RegExp(pattern).hasMatch(value)) {
      return message.isNotEmpty ? message : "Không khớp với mẫu";
    }
    return null;
  }

  static String? isValidDate({required String? value, String message = ""}) {
    final String regex =
        r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$';
    return pattern(pattern: regex, value: value, message: message);
  }

  static String? validatePassword(
      {required String? password, String message = ""}) {
    if (password == null || password.isEmpty) {
      return message.isNotEmpty ? message : "Mật khẩu không được để trống";
    }
    if (password.length < 6) {
      return "Mật khẩu phải có ít nhất 6 ký tự";
    }

    return null;
  }

  static String? validatePasswordConfirm({
    required String? password,
    required String? confirmPassword,
    String message = "",
  }) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return message.isNotEmpty
          ? message
          : "Xác nhận mật khẩu không được để trống";
    }

    if (password != confirmPassword) {
      return message.isNotEmpty
          ? message
          : "Mật khẩu và xác nhận mật khẩu không khớp";
    }

    return null;
  }

  static String? compose(
      {required List<String Function(dynamic)> validators,
      dynamic value,
      String message = ""}) {
    for (var validator in validators) {
      final error = validator(value);
      if (error != null) {
        return message.isNotEmpty ? message : error;
      }
    }
    return null;
  }
}
