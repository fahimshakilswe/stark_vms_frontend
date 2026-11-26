/// Domain entity representing a vehicle record in Stark VMS.
class VehicleEntity {
  final int id;
  final String vehicleNumber;
  final String company;
  final String type;
  final String brand;
  final String model;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const VehicleEntity({
    required this.id,
    required this.vehicleNumber,
    required this.company,
    required this.type,
    required this.brand,
    required this.model,
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
