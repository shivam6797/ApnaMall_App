class Validators {
  static String? validateName(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

 static String? validatePhone(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Phone number is required';
  }
  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
    return 'Phone number must be 10 digits';
  }
  return null;
}


  static String? validateDOB(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Date of birth is required';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) {
      return 'Confirm your password';
    }
    if (value != original) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateCity(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'City is required';
  }
  if (value.trim().length < 2) {
    return 'City must be at least 2 characters';
  }
  return null;
}

static String? validateState(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'State is required';
  }
  if (value.trim().length < 2) {
    return 'State must be at least 2 characters';
  }
  return null;
}
static String? validatePinCode(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Pin code is required';
  }
  if (!RegExp(r'^\d{6}$').hasMatch(value)) {
    return 'Pin code must be 6 digits';
  }
  return null;
}
}
