/// Comprehensive input validation utilities matching backend validation rules.
class Validators {
  Validators._();

  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  static final RegExp _hasUppercase = RegExp(r'[A-Z]');
  static final RegExp _hasLowercase = RegExp(r'[a-z]');
  static final RegExp _hasDigit = RegExp(r'[0-9]');
  static final RegExp _hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>\-_=+]');
  static final RegExp _hasWhitespace = RegExp(r'\s');

  /// Validates full name (2-100 characters)
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'Full name must be at least 2 characters';
    }
    if (trimmed.length > 100) {
      return 'Full name cannot exceed 100 characters';
    }
    return null;
  }

  /// Validates email address (max 150 characters, standard email pattern)
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final trimmed = value.trim();
    if (trimmed.length > 150) {
      return 'Email cannot exceed 150 characters';
    }
    if (!_emailRegExp.hasMatch(trimmed)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates password according to backend @StrongPassword specification:
  /// - 8 to 64 characters
  /// - No whitespace
  /// - At least 1 uppercase letter
  /// - At least 1 lowercase letter
  /// - At least 1 digit
  /// - At least 1 special character
  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (value.length > 64) {
      return 'Password cannot exceed 64 characters';
    }
    if (_hasWhitespace.hasMatch(value)) {
      return 'Password cannot contain spaces';
    }
    if (!_hasUppercase.hasMatch(value)) {
      return 'Password must contain at least one uppercase letter (A-Z)';
    }
    if (!_hasLowercase.hasMatch(value)) {
      return 'Password must contain at least one lowercase letter (a-z)';
    }
    if (!_hasDigit.hasMatch(value)) {
      return 'Password must contain at least one digit (0-9)';
    }
    if (!_hasSpecialChar.hasMatch(value)) {
      return 'Password must contain at least one special character (!@#\$%...)';
    }
    return null;
  }

  /// Validates login password (presence check)
  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  /// Validates confirm password matches password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates vehicle number (max 50 chars)
  static String? validateVehicleNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vehicle number is required';
    }
    if (value.trim().length > 50) {
      return 'Vehicle number cannot exceed 50 characters';
    }
    return null;
  }

  /// Validates vehicle company (max 100 chars)
  static String? validateCompany(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Company is required';
    }
    if (value.trim().length > 100) {
      return 'Company cannot exceed 100 characters';
    }
    return null;
  }

  /// Validates vehicle type (max 50 chars)
  static String? validateType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Type is required';
    }
    if (value.trim().length > 50) {
      return 'Type cannot exceed 50 characters';
    }
    return null;
  }

  /// Validates vehicle brand (max 50 chars)
  static String? validateBrand(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Brand is required';
    }
    if (value.trim().length > 50) {
      return 'Brand cannot exceed 50 characters';
    }
    return null;
  }

  /// Validates vehicle model (max 50 chars)
  static String? validateModel(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Model is required';
    }
    if (value.trim().length > 50) {
      return 'Model cannot exceed 50 characters';
    }
    return null;
  }

  /// Validates vehicle status (max 30 chars)
  static String? validateStatus(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Status is required';
    }
    if (value.trim().length > 30) {
      return 'Status cannot exceed 30 characters';
    }
    return null;
  }
}
