import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stark_vms_frontend/core/error/failures.dart';
import 'package:stark_vms_frontend/core/network/dio_client.dart';
import 'package:stark_vms_frontend/features/vehicles/data/datasources/vehicle_api_service.dart';
import 'package:stark_vms_frontend/features/vehicles/data/datasources/vehicle_remote_datasource.dart';
import 'package:stark_vms_frontend/features/vehicles/data/repositories/vehicle_repository_impl.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/dashboard_metrics_entity.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/usecases/create_vehicle_usecase.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/usecases/delete_vehicle_usecase.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/usecases/get_dashboard_metrics_usecase.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/usecases/get_vehicle_by_id_usecase.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/usecases/get_vehicles_usecase.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/usecases/update_vehicle_usecase.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/providers/vehicle_form_state.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/providers/vehicle_list_state.dart';

final vehicleApiServiceProvider = Provider<VehicleApiService>((ref) {
  return VehicleApiService(ref.watch(dioProvider));
});

final vehicleRemoteDataSourceProvider = Provider<VehicleRemoteDataSource>((ref) {
  return VehicleRemoteDataSourceImpl(ref.watch(vehicleApiServiceProvider));
});

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return VehicleRepositoryImpl(ref.watch(vehicleRemoteDataSourceProvider));
});

final getVehiclesUseCaseProvider = Provider<GetVehiclesUseCase>((ref) {
  return GetVehiclesUseCase(ref.watch(vehicleRepositoryProvider));
});

final getVehicleByIdUseCaseProvider = Provider<GetVehicleByIdUseCase>((ref) {
  return GetVehicleByIdUseCase(ref.watch(vehicleRepositoryProvider));
});

final createVehicleUseCaseProvider = Provider<CreateVehicleUseCase>((ref) {
  return CreateVehicleUseCase(ref.watch(vehicleRepositoryProvider));
});

final updateVehicleUseCaseProvider = Provider<UpdateVehicleUseCase>((ref) {
  return UpdateVehicleUseCase(ref.watch(vehicleRepositoryProvider));
});

final deleteVehicleUseCaseProvider = Provider<DeleteVehicleUseCase>((ref) {
  return DeleteVehicleUseCase(ref.watch(vehicleRepositoryProvider));
});

final getDashboardMetricsUseCaseProvider =
    Provider<GetDashboardMetricsUseCase>((ref) {
  return GetDashboardMetricsUseCase(ref.watch(vehicleRepositoryProvider));
});

/// Fetches real aggregate metrics directly from backend database.
final dashboardMetricsProvider =
    FutureProvider.autoDispose<DashboardMetricsEntity>((ref) async {
  final useCase = ref.watch(getDashboardMetricsUseCaseProvider);
  return useCase();
});

/// Manages numbered page-based pagination, debounced search, and filtering.
final vehicleListProvider =
    NotifierProvider<VehicleListNotifier, VehicleListState>(
  VehicleListNotifier.new,
);

class VehicleListNotifier extends Notifier<VehicleListState> {
  static const Duration _searchDebounceDuration = Duration(milliseconds: 450);

  Timer? _searchDebounceTimer;
  int _requestSeq = 0;

  @override
  VehicleListState build() {
    ref.onDispose(() {
      _searchDebounceTimer?.cancel();
    });
    Future.microtask(() => loadPage(0));
    return const VehicleListState(isLoading: true);
  }

  /// Loads a specific zero-based page while preventing stale overwrites.
  Future<void> loadPage(int page) async {
    final safePage = page < 0 ? 0 : page;
    final reqId = ++_requestSeq;

    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final getVehiclesUseCase = ref.read(getVehiclesUseCaseProvider);
      final pageData = await getVehiclesUseCase(
        page: safePage,
        size: state.pageSize,
        sortBy: state.sortBy,
        sortDir: state.sortDir,
        search: state.searchQuery,
        vehicleType: state.vehicleTypeFilter,
        fuelType: state.fuelTypeFilter,
        status: state.statusFilter,
      );

      // Discard outdated responses if a newer search/page request started
      if (reqId != _requestSeq) return;

      // If current page became empty after deletion and earlier pages exist, step back
      if (safePage > 0 &&
          pageData.vehicles.isEmpty &&
          pageData.totalElements > 0) {
        final fallbackPage =
            (pageData.totalPages > 0 ? pageData.totalPages - 1 : safePage - 1)
                .clamp(0, safePage - 1);
        await loadPage(fallbackPage);
        return;
      }

      state = state.copyWith(
        vehicles: pageData.vehicles,
        currentPage: pageData.pageNumber,
        totalElements: pageData.totalElements,
        totalPages: pageData.totalPages,
        isLast: pageData.isLast,
        isLoading: false,
        hasLoadedOnce: true,
        clearError: true,
      );
    } on Failure catch (f) {
      if (reqId != _requestSeq) return;
      state = state.copyWith(
        isLoading: false,
        hasLoadedOnce: true,
        errorMessage: f.message,
      );
    } catch (e) {
      if (reqId != _requestSeq) return;
      state = state.copyWith(
        isLoading: false,
        hasLoadedOnce: true,
        errorMessage: 'Failed to load vehicles.',
      );
    }
  }

  void nextPage() {
    if (!state.canGoNext) return;
    loadPage(state.currentPage + 1);
  }

  void previousPage() {
    if (!state.canGoPrevious) return;
    loadPage(state.currentPage - 1);
  }

  /// Debounced search handler (450ms). Trims whitespace and resets to page 0.
  void onSearchChanged(String rawQuery) {
    _searchDebounceTimer?.cancel();
    final trimmed = rawQuery.trim();

    if (trimmed == state.searchQuery &&
        state.hasLoadedOnce &&
        state.errorMessage == null) {
      return;
    }

    _searchDebounceTimer = Timer(_searchDebounceDuration, () {
      state = state.copyWith(
        searchQuery: trimmed,
        currentPage: 0,
      );
      loadPage(0);
    });
  }

  /// Immediately clears search and restores full unfiltered page 0 results.
  void clearSearch() {
    _searchDebounceTimer?.cancel();
    if (state.searchQuery.isEmpty) return;
    state = state.copyWith(
      searchQuery: '',
      currentPage: 0,
    );
    loadPage(0);
  }

  void setStatusFilter(String? status) {
    final cleanStatus =
        (status == null || status.toUpperCase() == 'ALL') ? null : status;
    if (cleanStatus == state.statusFilter) return;
    state = state.copyWith(
      statusFilter: () => cleanStatus,
      currentPage: 0,
    );
    loadPage(0);
  }

  /// Applies a status filter from the Dashboard summary cards.
  void applyStatusFilter(String? status) {
    _searchDebounceTimer?.cancel();
    final cleanStatus =
        (status == null || status.toUpperCase() == 'ALL') ? null : status;
    state = VehicleListState(
      statusFilter: cleanStatus,
      isLoading: true,
      hasLoadedOnce: false,
    );
    loadPage(0);
  }

  void setVehicleTypeFilter(String? type) {
    final cleanType =
        (type == null || type.toUpperCase() == 'ALL') ? null : type;
    if (cleanType == state.vehicleTypeFilter) return;
    state = state.copyWith(
      vehicleTypeFilter: () => cleanType,
      currentPage: 0,
    );
    loadPage(0);
  }

  void setFuelTypeFilter(String? fuelType) {
    final cleanFuel =
        (fuelType == null || fuelType.toUpperCase() == 'ALL') ? null : fuelType;
    if (cleanFuel == state.fuelTypeFilter) return;
    state = state.copyWith(
      fuelTypeFilter: () => cleanFuel,
      currentPage: 0,
    );
    loadPage(0);
  }

  void resetFilters() {
    _searchDebounceTimer?.cancel();
    state = const VehicleListState(isLoading: true, hasLoadedOnce: false);
    loadPage(0);
  }

  Future<void> refresh() => loadPage(state.currentPage);

  Future<void> onVehicleAdded() => loadPage(0);

  Future<void> onVehicleUpdated() => loadPage(state.currentPage);

  Future<void> onVehicleDeleted() {
    if (state.vehicles.length <= 1 && state.currentPage > 0) {
      return loadPage(state.currentPage - 1);
    }
    return loadPage(state.currentPage);
  }
}

/// Notifier managing single vehicle load and create/update/delete mutations.
final vehicleFormNotifierProvider =
    NotifierProvider<VehicleFormNotifier, VehicleFormState>(
  VehicleFormNotifier.new,
);

class VehicleFormNotifier extends Notifier<VehicleFormState> {
  @override
  VehicleFormState build() => const VehicleFormState();

  Future<void> loadVehicle(int id) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearVehicle: true,
    );
    try {
      final getVehicleById = ref.read(getVehicleByIdUseCaseProvider);
      final vehicle = await getVehicleById(id);
      state = state.copyWith(
        isLoading: false,
        vehicle: vehicle,
        clearError: true,
      );
    } on Failure catch (f) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: f.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load vehicle details.',
      );
    }
  }

  Future<bool> createVehicle({
    required String vehicleNumber,
    required String vehicleType,
    required String brand,
    required String model,
    int? manufacturingYear,
    String? color,
    required String fuelType,
    int? seatingCapacity,
    String? driverName,
    String? driverPhone,
    required String status,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final createVehicleUseCase = ref.read(createVehicleUseCaseProvider);
      final created = await createVehicleUseCase(
        vehicleNumber: vehicleNumber,
        vehicleType: vehicleType,
        brand: brand,
        model: model,
        manufacturingYear: manufacturingYear,
        color: color,
        fuelType: fuelType,
        seatingCapacity: seatingCapacity,
        driverName: driverName,
        driverPhone: driverPhone,
        status: status,
      );
      state = state.copyWith(
        isSaving: false,
        isSuccess: true,
        vehicle: created,
        clearError: true,
      );
      ref.invalidate(dashboardMetricsProvider);
      await ref.read(vehicleListProvider.notifier).onVehicleAdded();
      return true;
    } on ConflictFailure catch (f) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: f.message,
        vehicleNumberError: f.message,
      );
      return false;
    } on ValidationFailure catch (f) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: f.message,
        validationErrors: f.errors,
        vehicleNumberError: f.errors['vehicleNumber'],
      );
      return false;
    } on Failure catch (f) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: f.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'An unexpected error occurred while saving the vehicle.',
      );
      return false;
    }
  }

  Future<bool> updateVehicle({
    required int id,
    required String vehicleNumber,
    required String vehicleType,
    required String brand,
    required String model,
    int? manufacturingYear,
    String? color,
    required String fuelType,
    int? seatingCapacity,
    String? driverName,
    String? driverPhone,
    required String status,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final updateVehicleUseCase = ref.read(updateVehicleUseCaseProvider);
      final updated = await updateVehicleUseCase(
        id: id,
        vehicleNumber: vehicleNumber,
        vehicleType: vehicleType,
        brand: brand,
        model: model,
        manufacturingYear: manufacturingYear,
        color: color,
        fuelType: fuelType,
        seatingCapacity: seatingCapacity,
        driverName: driverName,
        driverPhone: driverPhone,
        status: status,
      );
      state = state.copyWith(
        isSaving: false,
        isSuccess: true,
        vehicle: updated,
        clearError: true,
      );
      ref.invalidate(dashboardMetricsProvider);
      await ref.read(vehicleListProvider.notifier).onVehicleUpdated();
      return true;
    } on ConflictFailure catch (f) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: f.message,
        vehicleNumberError: f.message,
      );
      return false;
    } on ValidationFailure catch (f) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: f.message,
        validationErrors: f.errors,
        vehicleNumberError: f.errors['vehicleNumber'],
      );
      return false;
    } on Failure catch (f) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: f.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'An unexpected error occurred while updating the vehicle.',
      );
      return false;
    }
  }

  Future<bool> deleteVehicle(int id) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final deleteVehicleUseCase = ref.read(deleteVehicleUseCaseProvider);
      await deleteVehicleUseCase(id);
      state = state.copyWith(
        isSaving: false,
        clearError: true,
      );
      ref.invalidate(dashboardMetricsProvider);
      await ref.read(vehicleListProvider.notifier).onVehicleDeleted();
      return true;
    } on Failure catch (f) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: f.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'An unexpected error occurred while deleting the vehicle.',
      );
      return false;
    }
  }

  void reset() {
    state = const VehicleFormState();
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void clearVehicleNumberError() {
    state = state.copyWith(clearVehicleNumberError: true);
  }
}
