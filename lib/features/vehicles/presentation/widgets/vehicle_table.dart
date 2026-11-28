import 'package:flutter/material.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';
import 'package:stark_vms_frontend/core/widgets/app_badge.dart';
import 'package:stark_vms_frontend/features/vehicles/domain/entities/vehicle_entity.dart';

class VehicleTable extends StatelessWidget {
  final List<VehicleEntity> vehicles;
  final void Function(VehicleEntity vehicle) onEdit;
  final void Function(VehicleEntity vehicle) onDelete;

  const VehicleTable({
    super.key,
    required this.vehicles,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth > 1250 ? constraints.maxWidth : 1250),
              child: DataTable(
                headingRowHeight: 44,
                dataRowMinHeight: 52,
                dataRowMaxHeight: 58,
                columnSpacing: 16,
                horizontalMargin: 20,
                headingRowColor: WidgetStateProperty.all(AppColors.surfaceSecondary),
                dividerThickness: 1,
                border: const TableBorder(
                  horizontalInside: BorderSide(color: AppColors.border, width: 1),
                ),
                columns: const [
                  DataColumn(label: _HeaderCell('VEHICLE NUMBER')),
                  DataColumn(label: _HeaderCell('TYPE')),
                  DataColumn(label: _HeaderCell('BRAND')),
                  DataColumn(label: _HeaderCell('MODEL')),
                  DataColumn(label: _HeaderCell('YEAR')),
                  DataColumn(label: _HeaderCell('COLOR')),
                  DataColumn(label: _HeaderCell('FUEL TYPE')),
                  DataColumn(label: _HeaderCell('SEATS')),
                  DataColumn(label: _HeaderCell('DRIVER NAME')),
                  DataColumn(label: _HeaderCell('DRIVER PHONE')),
                  DataColumn(label: _HeaderCell('STATUS')),
                  DataColumn(label: _HeaderCell('ACTIONS', alignRight: true)),
                ],
                rows: vehicles.map((v) {
                  return DataRow(
                    cells: [
                      // Vehicle Number
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F1F8),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFFB3D4EE)),
                          ),
                          child: Text(
                            v.vehicleNumber,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                              color: AppColors.deepBlue,
                            ),
                          ),
                        ),
                      ),
                      // Vehicle Type
                      DataCell(
                        Text(
                          v.vehicleType,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.charcoal,
                          ),
                        ),
                      ),
                      // Brand
                      DataCell(
                        Text(
                          v.brand,
                          style: const TextStyle(fontSize: 13, color: AppColors.charcoal),
                        ),
                      ),
                      // Model
                      DataCell(
                        Text(
                          v.model,
                          style: const TextStyle(fontSize: 13, color: AppColors.charcoal),
                        ),
                      ),
                      // Manufacturing Year
                      DataCell(
                        Text(
                          v.manufacturingYear != null ? v.manufacturingYear.toString() : '—',
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ),
                      // Color
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (v.color != null && v.color!.trim().isNotEmpty) ...[
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _parseColor(v.color!),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.border),
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            Text(
                              v.color != null && v.color!.trim().isNotEmpty ? v.color! : '—',
                              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      // Fuel Type
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            v.fuelType,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      // Seating Capacity
                      DataCell(
                        Text(
                          v.seatingCapacity != null ? '${v.seatingCapacity} seats' : '—',
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ),
                      // Driver Name
                      DataCell(
                        Text(
                          v.driverName != null && v.driverName!.trim().isNotEmpty
                              ? v.driverName!
                              : 'Unassigned',
                          style: TextStyle(
                            fontSize: 13,
                            color: v.driverName != null && v.driverName!.trim().isNotEmpty
                                ? AppColors.charcoal
                                : AppColors.textMuted,
                            fontStyle: v.driverName != null && v.driverName!.trim().isNotEmpty
                                ? FontStyle.normal
                                : FontStyle.italic,
                          ),
                        ),
                      ),
                      // Driver Phone
                      DataCell(
                        Text(
                          v.driverPhone != null && v.driverPhone!.trim().isNotEmpty
                              ? v.driverPhone!
                              : '—',
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ),
                      // Status
                      DataCell(
                        AppBadge.fromStatus(v.status),
                      ),
                      // Actions
                      DataCell(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              tooltip: 'Edit vehicle',
                              color: AppColors.corporateBlue,
                              hoverColor: AppColors.corporateBlue.withValues(alpha: 0.1),
                              onPressed: () => onEdit(v),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, size: 18),
                              tooltip: 'Delete vehicle',
                              color: AppColors.red,
                              hoverColor: AppColors.red.withValues(alpha: 0.1),
                              onPressed: () => onDelete(v),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _parseColor(String colorName) {
    final lower = colorName.toLowerCase().trim();
    if (lower.contains('red')) return Colors.red;
    if (lower.contains('blue')) return Colors.blue;
    if (lower.contains('green')) return Colors.green;
    if (lower.contains('black')) return Colors.black;
    if (lower.contains('white')) return Colors.white;
    if (lower.contains('silver') || lower.contains('grey') || lower.contains('gray')) return Colors.grey;
    if (lower.contains('yellow')) return Colors.amber;
    if (lower.contains('orange')) return Colors.orange;
    return AppColors.corporateBlue;
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final bool alignRight;

  const _HeaderCell(this.label, {this.alignRight = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: AppColors.deepBlue,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
