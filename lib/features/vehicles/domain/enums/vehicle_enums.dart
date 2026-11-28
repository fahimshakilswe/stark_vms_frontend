// ignore_for_file: constant_identifier_names, dangling_library_doc_comments

/// Exact enums strictly matching the Spring Boot backend contract.

enum VehicleType {
  CAR,
  SUV,
  MICROBUS,
  VAN,
  TRUCK,
  PICKUP;

  String get displayName {
    switch (this) {
      case VehicleType.CAR:
        return 'Car';
      case VehicleType.SUV:
        return 'SUV';
      case VehicleType.MICROBUS:
        return 'Microbus';
      case VehicleType.VAN:
        return 'Van';
      case VehicleType.TRUCK:
        return 'Truck';
      case VehicleType.PICKUP:
        return 'Pickup';
    }
  }

  static VehicleType? fromString(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final clean = value.trim().toUpperCase().replaceAll('-', '_').replaceAll(' ', '_');
    for (final v in VehicleType.values) {
      if (v.name == clean) return v;
    }
    return null;
  }
}

enum FuelType {
  OCTANE,
  PETROL,
  DIESEL,
  CNG,
  LPG;

  String get displayName {
    switch (this) {
      case FuelType.OCTANE:
        return 'Octane';
      case FuelType.PETROL:
        return 'Petrol';
      case FuelType.DIESEL:
        return 'Diesel';
      case FuelType.CNG:
        return 'CNG';
      case FuelType.LPG:
        return 'LPG';
    }
  }

  static FuelType? fromString(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final clean = value.trim().toUpperCase();
    for (final f in FuelType.values) {
      if (f.name == clean) return f;
    }
    return null;
  }
}

enum VehicleStatus {
  AVAILABLE,
  ACTIVE,
  INACTIVE,
  MAINTENANCE;

  String get displayName {
    switch (this) {
      case VehicleStatus.AVAILABLE:
        return 'Available';
      case VehicleStatus.ACTIVE:
        return 'Active';
      case VehicleStatus.INACTIVE:
        return 'Inactive';
      case VehicleStatus.MAINTENANCE:
        return 'Maintenance';
    }
  }

  /// Parses backend status strings including legacy or mixed-case variants.
  static VehicleStatus? fromString(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final clean = value.trim().toUpperCase();
    switch (clean) {
      case 'AVAILABLE':
        return VehicleStatus.AVAILABLE;
      case 'ACTIVE':
        return VehicleStatus.ACTIVE;
      case 'INACTIVE':
        return VehicleStatus.INACTIVE;
      case 'MAINTENANCE':
      case 'MAINTENCE':
        return VehicleStatus.MAINTENANCE;
      default:
        return null;
    }
  }
}
