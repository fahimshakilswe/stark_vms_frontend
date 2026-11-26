import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stark_vms_frontend/core/error/failures.dart';
import 'package:stark_vms_frontend/core/network/dio_client.dart';
import 'package:stark_vms_frontend/features/vehicles/data/datasources/vehicle_api_service.dart';
import 'package:stark_vms_frontend/features/vehicles/data/datasources/vehicle_remote_datasource.dart';
import 'package:stark_vms_frontend/features/vehicles/data/repositories/vehicle_repository_impl.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/usecases/create_vehicle_usecase.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/usecases/delete_vehicle_usecase.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/usecases/get_vehicle_by_id_usecase.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/usecases/get_vehicles_usecase.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/usecases/update_vehicle_usecase.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/providers/vehicle_form_state.dart';

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

/// Filter state for vehicle search and status selection.
class VehicleFilterState {
  final String searchQuery;
  final String? statusFilter;
  final String sortBy;
  final String sortDir;

  const VehicleFilterState({
    this.searchQuery = '',
    this.statusFilter,
    this.sortBy = 'createdAt',
    this.sortDir = 'desc',
  });

  VehicleFilterState copyWith({
    String? searchQuery,
    String? Function()? statusFilter,
    String? sortBy,
    String? sortDir,
  }) {
    return VehicleFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter != null ? statusFilter() : this.statusFilter,
      sortBy: sortBy ?? this.sortBy,
      sortDir: sortDir ?? this.sortDir,
    );
  }
}

final vehicleFilterProvider =
    NotifierProvider<VehicleFilterNotifier, VehicleFilterState>(
  VehicleFilterNotifier.new,
);

class VehicleFilterNotifier extends Notifier<VehicleFilterState> {
  @override
  VehicleFilterState build() => const VehicleFilterState();

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setStatusFilter(String? status) {
    final cleanStatus = (status == null || status.toUpperCase() == 'ALL')
        ? null
        : status.toUpperCase();
    state = state.copyWith(statusFilter: () => cleanStatus);
  }

  void resetFilters() {
    state = const VehicleFilterState();
  }
}

/// Notifier managing single vehicle load and create/update operations.
final vehicleFormNotifierProvider =
    NotifierProvider<VehicleFormNotifier, VehicleFormState>(
  VehicleFormNotifier.new,
);

class VehicleFormNotifier extends Notifier<VehicleFormState> {
  @override
  VehicleFormState build() => const VehicleFormState();

  Future<void> loadVehicle(int id) async {
    state = state.copyWith(isLoading: true, clearError: true);
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
    required String company,
    required String type,
    required String brand,
    required String model,
    required String status,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final createVehicleUseCase = ref.read(createVehicleUseCaseProvider);
      final created = await createVehicleUseCase(
        vehicleNumber: vehicleNumber,
        company: company,
        type: type,
        brand: brand,
        model: model,
        status: status,
      );
      state = state.copyWith(
        isSaving: false,
        isSuccess: true,
        vehicle: created,
        clearError: true,
      );
      return true;
    } on Failure catch (f) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: f.message,
        validationErrors: f is ValidationFailure ? f.errors : null,
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
    required String company,
    required String type,
    required String brand,
    required String model,
    required String status,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final updateVehicleUseCase = ref.read(updateVehicleUseCaseProvider);
      final updated = await updateVehicleUseCase(
        id: id,
        vehicleNumber: vehicleNumber,
        company: company,
        type: type,
        brand: brand,
        model: model,
        status: status,
      );
      state = state.copyWith(
        isSaving: false,
        isSuccess: true,
        vehicle: updated,
        clearError: true,
      );
      return true;
    } on Failure catch (f) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: f.message,
        validationErrors: f is ValidationFailure ? f.errors : null,
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
}
