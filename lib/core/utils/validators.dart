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
  static final RegExp _phoneRegExp = RegExp(r'^\+?[0-9\s\-()]{7,30}$');

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

  /// Validates vehicle number (max 50 chars, required)
  static String? validateVehicleNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vehicle number is required';
    }
    final clean = value.trim();
    if (clean.length > 50) {
      return 'Vehicle number cannot exceed 50 characters';
    }
    return null;
  }

  /// Validates vehicle type (required)
  static String? validateVehicleType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vehicle type is required';
    }
    return null;
  }

  /// Validates vehicle brand (required, max 50 chars)
  static String? validateBrand(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Brand is required';
    }
    if (value.trim().length > 50) {
      return 'Brand cannot exceed 50 characters';
    }
    return null;
  }

  /// Validates vehicle model (required, max 50 chars)
  static String? validateModel(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Model is required';
    }
    if (value.trim().length > 50) {
      return 'Model cannot exceed 50 characters';
    }
    return null;
  }

  /// Validates fuel type (required)
  static String? validateFuelType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Fuel type is required';
    }
    return null;
  }

  /// Validates manufacturing year (optional, but if provided must be between 1900 and current year)
  static String? validateManufacturingYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final year = int.tryParse(value.trim());
    if (year == null) {
      return 'Please enter a valid year';
    }
    if (year < 1900) {
      return 'Manufacturing year must be at least 1900';
    }
    final currentYear = DateTime.now().year;
    if (year > currentYear) {
      return 'Manufacturing year cannot be in the future (max $currentYear)';
    }
    return null;
  }

  /// Validates vehicle exterior color (optional, max 50 chars)
  static String? validateColor(String? value) {
    if (value != null && value.trim().length > 50) {
      return 'Color cannot exceed 50 characters';
    }
    return null;
  }

  /// Validates seating capacity (optional, but if provided must be positive integer > 0)
  static String? validateSeatingCapacity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final seats = int.tryParse(value.trim());
    if (seats == null) {
      return 'Please enter a valid number';
    }
    if (seats <= 0) {
      return 'Seating capacity must be greater than 0';
    }
    if (seats > 500) {
      return 'Seating capacity seems invalid (max 500)';
    }
    return null;
  }

  /// Validates driver name (optional, max 100 chars)
  static String? validateDriverName(String? value) {
    if (value != null && value.trim().length > 100) {
      return 'Driver name cannot exceed 100 characters';
    }
    return null;
  }

  /// Validates driver phone (optional, but if provided must match valid pattern and max 30 chars)
  static String? validateDriverPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final clean = value.trim();
    if (clean.length > 30) {
      return 'Driver phone cannot exceed 30 characters';
    }
    if (!_phoneRegExp.hasMatch(clean)) {
      return 'Please enter a valid phone number (e.g. +8801711000001)';
    }
    return null;
  }

  /// Validates vehicle status (required)
  static String? validateStatus(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Status is required';
    }
    return null;
  }
}
