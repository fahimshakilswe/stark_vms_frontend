/// Domain entity representing a vehicle record in Stark Group VMS.
class VehicleEntity {
  final int id;
  final String vehicleNumber;
  final String vehicleType;
  final String brand;
  final String model;
  final int? manufacturingYear;
  final String? color;
  final String fuelType;
  final int? seatingCapacity;
  final String? driverName;
  final String? driverPhone;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const VehicleEntity({
    required this.id,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.brand,
    required this.model,
    this.manufacturingYear,
    this.color,
    required this.fuelType,
    this.seatingCapacity,
    this.driverName,
    this.driverPhone,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          vehicleNumber == other.vehicleNumber;

  @override
  int get hashCode => id.hashCode ^ vehicleNumber.hashCode;
}
