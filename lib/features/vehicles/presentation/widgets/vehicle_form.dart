import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';
import 'package:stark_vms_frontend/core/utils/validators.dart';
import 'package:stark_vms_frontend/core/widgets/app_button.dart';
import 'package:stark_vms_frontend/core/widgets/app_card.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/enums/vehicle_enums.dart';

class VehicleFormData {
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

  const VehicleFormData({
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
  });
}

class VehicleForm extends StatefulWidget {
  final VehicleEntity? initialVehicle;
  final bool isSaving;
  final String? errorMessage;
  final String? vehicleNumberError;
  final void Function(VehicleFormData data) onSubmit;
  final VoidCallback onCancel;

  const VehicleForm({
    super.key,
    this.initialVehicle,
    this.isSaving = false,
    this.errorMessage,
    this.vehicleNumberError,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<VehicleForm> createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _vehicleNumberController;
  late final TextEditingController _brandController;
  late final TextEditingController _modelController;
  late final TextEditingController _yearController;
  late final TextEditingController _colorController;
  late final TextEditingController _capacityController;
  late final TextEditingController _driverNameController;
  late final TextEditingController _driverPhoneController;

  String _vehicleType = VehicleType.CAR.name;
  String _fuelType = FuelType.OCTANE.name;
  String _status = VehicleStatus.AVAILABLE.name;

  String? _backendVehicleNumberError;

  @override
  void initState() {
    super.initState();
    final v = widget.initialVehicle;
    _vehicleNumberController = TextEditingController(text: v?.vehicleNumber ?? '');
    _brandController = TextEditingController(text: v?.brand ?? '');
    _modelController = TextEditingController(text: v?.model ?? '');
    _yearController = TextEditingController(
      text: v?.manufacturingYear != null ? v!.manufacturingYear.toString() : '',
    );
    _colorController = TextEditingController(text: v?.color ?? '');
    _capacityController = TextEditingController(
      text: v?.seatingCapacity != null ? v!.seatingCapacity.toString() : '',
    );
    _driverNameController = TextEditingController(text: v?.driverName ?? '');
    _driverPhoneController = TextEditingController(text: v?.driverPhone ?? '');

    if (v != null) {
      final parsedType = VehicleType.fromString(v.vehicleType);
      if (parsedType != null) _vehicleType = parsedType.name;

      final parsedFuel = FuelType.fromString(v.fuelType);
      if (parsedFuel != null) _fuelType = parsedFuel.name;

      final parsedStatus = VehicleStatus.fromString(v.status);
      if (parsedStatus != null) _status = parsedStatus.name;
    } else {
      // Default status for new vehicle: AVAILABLE
      _status = VehicleStatus.AVAILABLE.name;
    }

    _backendVehicleNumberError = widget.vehicleNumberError;
    _vehicleNumberController.addListener(_onVehicleNumberChanged);
  }

  void _onVehicleNumberChanged() {
    if (_backendVehicleNumberError != null) {
      setState(() {
        _backendVehicleNumberError = null;
      });
    }
  }

  @override
  void didUpdateWidget(covariant VehicleForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.vehicleNumberError != oldWidget.vehicleNumberError) {
      setState(() {
        _backendVehicleNumberError = widget.vehicleNumberError;
      });
    }
    if (widget.initialVehicle != oldWidget.initialVehicle && widget.initialVehicle != null) {
      final v = widget.initialVehicle!;
      _vehicleNumberController.text = v.vehicleNumber;
      _brandController.text = v.brand;
      _modelController.text = v.model;
      _yearController.text = v.manufacturingYear != null ? v.manufacturingYear.toString() : '';
      _colorController.text = v.color ?? '';
      _capacityController.text = v.seatingCapacity != null ? v.seatingCapacity.toString() : '';
      _driverNameController.text = v.driverName ?? '';
      _driverPhoneController.text = v.driverPhone ?? '';

      final parsedType = VehicleType.fromString(v.vehicleType);
      if (parsedType != null) _vehicleType = parsedType.name;

      final parsedFuel = FuelType.fromString(v.fuelType);
      if (parsedFuel != null) _fuelType = parsedFuel.name;

      final parsedStatus = VehicleStatus.fromString(v.status);
      if (parsedStatus != null) _status = parsedStatus.name;
    }
  }

  @override
  void dispose() {
    _vehicleNumberController.removeListener(_onVehicleNumberChanged);
    _vehicleNumberController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    _capacityController.dispose();
    _driverNameController.dispose();
    _driverPhoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final yearText = _yearController.text.trim();
    final capacityText = _capacityController.text.trim();
    final colorText = _colorController.text.trim();
    final driverNameText = _driverNameController.text.trim();
    final driverPhoneText = _driverPhoneController.text.trim();

    widget.onSubmit(
      VehicleFormData(
        vehicleNumber: _vehicleNumberController.text.trim().toUpperCase(),
        vehicleType: _vehicleType,
        brand: _brandController.text.trim(),
        model: _modelController.text.trim(),
        manufacturingYear: yearText.isNotEmpty ? int.tryParse(yearText) : null,
        color: colorText.isNotEmpty ? colorText : null,
        fuelType: _fuelType,
        seatingCapacity: capacityText.isNotEmpty ? int.tryParse(capacityText) : null,
        driverName: driverNameText.isNotEmpty ? driverNameText : null,
        driverPhone: driverPhoneText.isNotEmpty ? driverPhoneText : null,
        status: _status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 768;

    return AppCard(
      title: widget.initialVehicle == null ? 'Vehicle Information' : 'Edit Vehicle Details',
      subtitle: 'Complete all required vehicle specifications. Vehicle number must be globally unique.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // General error banner if present and not specific to vehicle number
            if (widget.errorMessage != null &&
                widget.errorMessage != _backendVehicleNumberError) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.destructiveBackground,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.destructiveBorder),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.errorMessage!,
                        style: const TextStyle(
                          color: AppColors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Row 1: Vehicle Number * | Vehicle Type *
            _buildResponsiveRow(
              isDesktop: isDesktop,
              first: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Vehicle Number', isRequired: true),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _vehicleNumberController,
                    validator: Validators.validateVehicleNumber,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      color: AppColors.charcoal,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. DHA-METRO-GA-11-1001',
                      prefixIcon: const Icon(Icons.pin_outlined, size: 18, color: AppColors.textSecondary),
                      errorBorder: _backendVehicleNumberError != null
                          ? const OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.red, width: 1.5),
                            )
                          : null,
                    ),
                  ),
                  // HTTP 409 duplicate vehicle number error display directly below field
                  if (_backendVehicleNumberError != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.error_outline_rounded, size: 15, color: AppColors.red),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _backendVehicleNumberError!,
                            style: const TextStyle(
                              color: AppColors.red,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              second: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Vehicle Type', isRequired: true),
                  const SizedBox(height: 6),
                  _buildDropdownSelect<String>(
                    value: _vehicleType,
                    items: VehicleType.values
                        .map((t) => DropdownMenuItem(value: t.name, child: Text(t.displayName)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _vehicleType = val);
                    },
                    icon: Icons.category_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Row 2: Brand * | Model *
            _buildResponsiveRow(
              isDesktop: isDesktop,
              first: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Brand', isRequired: true),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _brandController,
                    validator: Validators.validateBrand,
                    style: const TextStyle(fontSize: 14, color: AppColors.charcoal),
                    decoration: const InputDecoration(
                      hintText: 'e.g. Toyota, Mercedes-Benz, Hyundai',
                      prefixIcon: Icon(Icons.directions_car_outlined, size: 18, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
              second: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Model', isRequired: true),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _modelController,
                    validator: Validators.validateModel,
                    style: const TextStyle(fontSize: 14, color: AppColors.charcoal),
                    decoration: const InputDecoration(
                      hintText: 'e.g. Corolla Altis, Sprinter, Tucson',
                      prefixIcon: Icon(Icons.tune_rounded, size: 18, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Row 3: Manufacturing Year | Color
            _buildResponsiveRow(
              isDesktop: isDesktop,
              first: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Manufacturing Year'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _yearController,
                    validator: Validators.validateManufacturingYear,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                    style: const TextStyle(fontSize: 14, color: AppColors.charcoal),
                    decoration: const InputDecoration(
                      hintText: 'e.g. 2022',
                      prefixIcon: Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
              second: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Exterior Color'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _colorController,
                    validator: Validators.validateColor,
                    style: const TextStyle(fontSize: 14, color: AppColors.charcoal),
                    decoration: const InputDecoration(
                      hintText: 'e.g. Silver, Pearl White, Midnight Black',
                      prefixIcon: Icon(Icons.palette_outlined, size: 18, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Row 4: Fuel Type * | Seating Capacity
            _buildResponsiveRow(
              isDesktop: isDesktop,
              first: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Fuel Type', isRequired: true),
                  const SizedBox(height: 6),
                  _buildDropdownSelect<String>(
                    value: _fuelType,
                    items: FuelType.values
                        .map((f) => DropdownMenuItem(value: f.name, child: Text(f.displayName)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _fuelType = val);
                    },
                    icon: Icons.local_gas_station_outlined,
                  ),
                ],
              ),
              second: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Seating Capacity'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _capacityController,
                    validator: Validators.validateSeatingCapacity,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                    style: const TextStyle(fontSize: 14, color: AppColors.charcoal),
                    decoration: const InputDecoration(
                      hintText: 'e.g. 5',
                      prefixIcon: Icon(Icons.event_seat_outlined, size: 18, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Row 5: Driver Name | Driver Phone
            _buildResponsiveRow(
              isDesktop: isDesktop,
              first: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Driver Name'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _driverNameController,
                    validator: Validators.validateDriverName,
                    style: const TextStyle(fontSize: 14, color: AppColors.charcoal),
                    decoration: const InputDecoration(
                      hintText: 'e.g. Rahim Uddin',
                      prefixIcon: Icon(Icons.person_outline_rounded, size: 18, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
              second: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Driver Phone Number'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _driverPhoneController,
                    validator: Validators.validateDriverPhone,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(fontSize: 14, color: AppColors.charcoal),
                    decoration: const InputDecoration(
                      hintText: 'e.g. +8801711000001',
                      prefixIcon: Icon(Icons.phone_outlined, size: 18, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Row 6: Status *
            _buildResponsiveRow(
              isDesktop: isDesktop,
              first: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Operational Status', isRequired: true),
                  const SizedBox(height: 6),
                  _buildDropdownSelect<String>(
                    value: _status,
                    items: VehicleStatus.values
                        .map((s) => DropdownMenuItem(value: s.name, child: Text(s.displayName)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _status = val);
                    },
                    icon: Icons.shield_outlined,
                  ),
                ],
              ),
              second: const SizedBox.shrink(),
            ),
            const SizedBox(height: 32),

            // Form Actions Row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  label: 'Cancel',
                  variant: AppButtonVariant.outline,
                  onPressed: widget.onCancel,
                ),
                const SizedBox(width: 12),
                AppButton(
                  label: widget.initialVehicle == null ? 'Register Vehicle' : 'Save Changes',
                  isLoading: widget.isSaving,
                  icon: widget.initialVehicle == null ? Icons.add_rounded : Icons.check_rounded,
                  onPressed: widget.isSaving ? null : _submit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: AppColors.deepBlue,
        ),
        children: [
          if (isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(
                color: AppColors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdownSelect<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: items.any((i) => i.value == value) ? value : items.first.value,
                items: items,
                onChanged: onChanged,
                icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.charcoal,
                ),
                borderRadius: BorderRadius.circular(8),
                isExpanded: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveRow({
    required bool isDesktop,
    required Widget first,
    required Widget second,
  }) {
    if (!isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          first,
          if (second is! SizedBox) ...[
            const SizedBox(height: 18),
            second,
          ],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        const SizedBox(width: 24),
        Expanded(child: second),
      ],
    );
  }
}
