import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';
import 'package:stark_vms_frontend/core/utils/validators.dart';
import 'package:stark_vms_frontend/core/widgets/app_button.dart';
import 'package:stark_vms_frontend/core/widgets/app_card.dart';
import 'package:stark_vms_frontend/core/widgets/app_text_field.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';

class VehicleFormData {
  final String vehicleNumber;
  final String company;
  final String type;
  final String brand;
  final String model;
  final String status;

  const VehicleFormData({
    required this.vehicleNumber,
    required this.company,
    required this.type,
    required this.brand,
    required this.model,
    required this.status,
  });
}

class VehicleForm extends StatefulWidget {
  final VehicleEntity? initialVehicle;
  final bool isSaving;
  final String? errorMessage;
  final void Function(VehicleFormData data) onSubmit;
  final VoidCallback onCancel;

  const VehicleForm({
    super.key,
    this.initialVehicle,
    this.isSaving = false,
    this.errorMessage,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<VehicleForm> createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _vehicleNumberController;
  late final TextEditingController _companyController;
  late final TextEditingController _typeController;
  late final TextEditingController _brandController;
  late final TextEditingController _modelController;

  String _status = 'ACTIVE';

  static const List<String> statusOptions = [
    'ACTIVE',
    'MAINTENANCE',
    'INACTIVE',
    'RETIRED',
  ];

  static const List<String> vehicleTypeSuggestions = [
    'Sedan',
    'SUV',
    'Truck',
    'Van',
    'Pickup',
    'Bus',
    'Motorcycle',
    'Trailer',
  ];

  @override
  void initState() {
    super.initState();
    final v = widget.initialVehicle;
    _vehicleNumberController = TextEditingController(text: v?.vehicleNumber ?? '');
    _companyController = TextEditingController(text: v?.company ?? '');
    _typeController = TextEditingController(text: v?.type ?? 'Sedan');
    _brandController = TextEditingController(text: v?.brand ?? '');
    _modelController = TextEditingController(text: v?.model ?? '');
    _status = v?.status.toUpperCase() ?? 'ACTIVE';
    if (!statusOptions.contains(_status)) {
      _status = 'ACTIVE';
    }
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _companyController.dispose();
    _typeController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.onSubmit(
      VehicleFormData(
        vehicleNumber: _vehicleNumberController.text.trim().toUpperCase(),
        company: _companyController.text.trim(),
        type: _typeController.text.trim(),
        brand: _brandController.text.trim(),
        model: _modelController.text.trim(),
        status: _status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return AppCard(
      title: widget.initialVehicle == null ? 'Vehicle Information' : 'Edit Fleet Details',
      subtitle: 'Complete all required vehicle specifications. Vehicle number must be globally unique.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Error banner from backend
            if (widget.errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.destructiveBackground,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.destructiveBorder),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.destructive,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.errorMessage!,
                        style: const TextStyle(
                          color: AppColors.destructive,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Row 1: Vehicle Number & Company
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Vehicle Registration Number',
                      hint: 'e.g. DHAKA-METRO-GA-1234',
                      controller: _vehicleNumberController,
                      isRequired: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\-_ ]')),
                      ],
                      validator: Validators.validateVehicleNumber,
                      prefixIcon: const Icon(Icons.tag_rounded, size: 18, color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: AppTextField(
                      label: 'Company / Fleet Operator',
                      hint: 'e.g. Acme Logistics Ltd.',
                      controller: _companyController,
                      isRequired: true,
                      validator: Validators.validateCompany,
                      prefixIcon: const Icon(Icons.business_outlined, size: 18, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              )
            else ...[
              AppTextField(
                label: 'Vehicle Registration Number',
                hint: 'e.g. DHAKA-METRO-GA-1234',
                controller: _vehicleNumberController,
                isRequired: true,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\-_ ]')),
                ],
                validator: Validators.validateVehicleNumber,
                prefixIcon: const Icon(Icons.tag_rounded, size: 18, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Company / Fleet Operator',
                hint: 'e.g. Acme Logistics Ltd.',
                controller: _companyController,
                isRequired: true,
                validator: Validators.validateCompany,
                prefixIcon: const Icon(Icons.business_outlined, size: 18, color: AppColors.textSecondary),
              ),
            ],
            const SizedBox(height: 16),

            // Row 2: Type, Brand, Model
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          label: 'Vehicle Type',
                          hint: 'e.g. Sedan, Truck, Van',
                          controller: _typeController,
                          isRequired: true,
                          validator: Validators.validateType,
                          prefixIcon: const Icon(Icons.category_outlined, size: 18, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 4,
                          children: vehicleTypeSuggestions.map((t) {
                            return InkWell(
                              borderRadius: BorderRadius.circular(4),
                              onTap: () => _typeController.text = t,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                child: Text(
                                  t,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.accent,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: AppTextField(
                      label: 'Brand / Manufacturer',
                      hint: 'e.g. Toyota, Volvo, Mercedes',
                      controller: _brandController,
                      isRequired: true,
                      validator: Validators.validateBrand,
                      prefixIcon: const Icon(Icons.directions_car_outlined, size: 18, color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: AppTextField(
                      label: 'Model',
                      hint: 'e.g. Corolla, FH16, Sprinter',
                      controller: _modelController,
                      isRequired: true,
                      validator: Validators.validateModel,
                      prefixIcon: const Icon(Icons.speed_outlined, size: 18, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              )
            else ...[
              AppTextField(
                label: 'Vehicle Type',
                hint: 'e.g. Sedan, Truck, Van',
                controller: _typeController,
                isRequired: true,
                validator: Validators.validateType,
                prefixIcon: const Icon(Icons.category_outlined, size: 18, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Brand / Manufacturer',
                hint: 'e.g. Toyota, Volvo, Mercedes',
                controller: _brandController,
                isRequired: true,
                validator: Validators.validateBrand,
                prefixIcon: const Icon(Icons.directions_car_outlined, size: 18, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Model',
                hint: 'e.g. Corolla, FH16, Sprinter',
                controller: _modelController,
                isRequired: true,
                validator: Validators.validateModel,
                prefixIcon: const Icon(Icons.speed_outlined, size: 18, color: AppColors.textSecondary),
              ),
            ],
            const SizedBox(height: 16),

            // Row 3: Status Selector
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'Operational Status',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      ' *',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.destructive,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _status,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textSecondary,
                      ),
                      items: statusOptions.map((st) {
                        return DropdownMenuItem<String>(
                          value: st,
                          child: Text(
                            st,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _status = val;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Form Actions (Save & Cancel)
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  label: 'Cancel',
                  variant: AppButtonVariant.outline,
                  onPressed: widget.isSaving ? null : widget.onCancel,
                ),
                const SizedBox(width: 12),
                AppButton(
                  label: widget.initialVehicle == null ? 'Register Vehicle' : 'Update Vehicle',
                  icon: widget.initialVehicle == null ? Icons.add_rounded : Icons.save_rounded,
                  isLoading: widget.isSaving,
                  onPressed: _submit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
