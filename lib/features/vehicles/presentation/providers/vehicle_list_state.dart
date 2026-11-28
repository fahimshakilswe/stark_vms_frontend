import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';

class VehicleListState {
  static const int defaultPageSize = 10;

  final List<VehicleEntity> vehicles;
  final int currentPage;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool isLast;
  final bool isLoading;
  final bool hasLoadedOnce;
  final String? errorMessage;

  // Active search & filter parameters
  final String searchQuery;
  final String? statusFilter;
  final String? vehicleTypeFilter;
  final String? fuelTypeFilter;
  final String sortBy;
  final String sortDir;

  const VehicleListState({
    this.vehicles = const [],
    this.currentPage = 0,
    this.pageSize = defaultPageSize,
    this.totalElements = 0,
    this.totalPages = 0,
    this.isLast = true,
    this.isLoading = false,
    this.hasLoadedOnce = false,
    this.errorMessage,
    this.searchQuery = '',
    this.statusFilter,
    this.vehicleTypeFilter,
    this.fuelTypeFilter,
    this.sortBy = 'createdAt',
    this.sortDir = 'desc',
  });

  bool get isInitialLoading => isLoading && !hasLoadedOnce;
  bool get isPageLoading => isLoading && hasLoadedOnce;

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      statusFilter != null ||
      vehicleTypeFilter != null ||
      fuelTypeFilter != null;

  int get startItem =>
      (totalElements == 0 || vehicles.isEmpty) ? 0 : (currentPage * pageSize) + 1;

  int get endItem => (totalElements == 0 || vehicles.isEmpty)
      ? 0
      : (currentPage * pageSize) + vehicles.length;

  int get displayPage => currentPage + 1;
  int get displayTotalPages => totalPages > 0 ? totalPages : 1;

  bool get canGoPrevious => !isLoading && currentPage > 0;
  bool get canGoNext =>
      !isLoading && !isLast && (currentPage + 1 < totalPages);

  VehicleListState copyWith({
    List<VehicleEntity>? vehicles,
    int? currentPage,
    int? pageSize,
    int? totalElements,
    int? totalPages,
    bool? isLast,
    bool? isLoading,
    bool? hasLoadedOnce,
    String? errorMessage,
    bool clearError = false,
    String? searchQuery,
    String? Function()? statusFilter,
    String? Function()? vehicleTypeFilter,
    String? Function()? fuelTypeFilter,
    String? sortBy,
    String? sortDir,
  }) {
    return VehicleListState(
      vehicles: vehicles ?? this.vehicles,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalElements: totalElements ?? this.totalElements,
      totalPages: totalPages ?? this.totalPages,
      isLast: isLast ?? this.isLast,
      isLoading: isLoading ?? this.isLoading,
      hasLoadedOnce: hasLoadedOnce ?? this.hasLoadedOnce,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter != null ? statusFilter() : this.statusFilter,
      vehicleTypeFilter: vehicleTypeFilter != null
          ? vehicleTypeFilter()
          : this.vehicleTypeFilter,
      fuelTypeFilter:
          fuelTypeFilter != null ? fuelTypeFilter() : this.fuelTypeFilter,
      sortBy: sortBy ?? this.sortBy,
      sortDir: sortDir ?? this.sortDir,
    );
  }
}
