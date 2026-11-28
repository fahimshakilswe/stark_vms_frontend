import 'package:flutter/material.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';
import 'package:stark_vms_frontend/core/widgets/app_badge.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';

class VehicleMobileCard extends StatelessWidget {
  final VehicleEntity vehicle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const VehicleMobileCard({
    super.key,
    required this.vehicle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x04000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1F8),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFB3D4EE)),
                ),
                child: Text(
                  vehicle.vehicleNumber,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepBlue,
                  ),
                ),
              ),
              AppBadge.fromStatus(vehicle.status),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${vehicle.brand} ${vehicle.model}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${vehicle.vehicleType} • ${vehicle.fuelType}${vehicle.manufacturingYear != null ? ' • ${vehicle.manufacturingYear}' : ''}',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              if (vehicle.color != null && vehicle.color!.trim().isNotEmpty)
                _buildInfoChip(Icons.palette_outlined, vehicle.color!),
              if (vehicle.seatingCapacity != null)
                _buildInfoChip(Icons.event_seat_outlined, '${vehicle.seatingCapacity} seats'),
              if (vehicle.driverName != null && vehicle.driverName!.trim().isNotEmpty)
                _buildInfoChip(Icons.person_outline_rounded, vehicle.driverName!),
              if (vehicle.driverPhone != null && vehicle.driverPhone!.trim().isNotEmpty)
                _buildInfoChip(Icons.phone_outlined, vehicle.driverPhone!),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.corporateBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded, size: 16),
                label: const Text('Delete'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
