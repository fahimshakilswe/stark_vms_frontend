import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';

class VehicleFormState {
  final bool isLoading;
  final bool isSaving;
  final bool isSuccess;
  final String? errorMessage;
  final Map<String, String>? validationErrors;
  final VehicleEntity? vehicle;

  const VehicleFormState({
    this.isLoading = false,
    this.isSaving = false,
    this.isSuccess = false,
    this.errorMessage,
    this.validationErrors,
    this.vehicle,
  });

  VehicleFormState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isSuccess,
    String? errorMessage,
    Map<String, String>? validationErrors,
    VehicleEntity? vehicle,
    bool clearError = false,
  }) {
    return VehicleFormState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      validationErrors:
          clearError ? null : (validationErrors ?? this.validationErrors),
      vehicle: vehicle ?? this.vehicle,
    );
  }
}
