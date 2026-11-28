class DashboardMetricsEntity {
  final int totalVehicles;
  final int availableVehicles;
  final int activeVehicles;
  final int inactiveVehicles;
  final int underMaintenance;

  const DashboardMetricsEntity({
    required this.totalVehicles,
    required this.availableVehicles,
    required this.activeVehicles,
    required this.inactiveVehicles,
    required this.underMaintenance,
  });

  const DashboardMetricsEntity.empty()
      : totalVehicles = 0,
        availableVehicles = 0,
        activeVehicles = 0,
        inactiveVehicles = 0,
        underMaintenance = 0;
}
