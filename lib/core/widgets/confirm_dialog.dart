import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';

/// Professional confirmation dialog matching shadcn modal aesthetics.
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;
  final bool isLoading;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
    this.isLoading = false,
    required this.onConfirm,
    this.onCancel,
  });

  /// Displays shadcn_ui Delete confirmation dialog displaying the vehicle number.
  /// When [onConfirmDelete] is provided, the dialog manages a controlled loading state
  /// while the async delete executes and prevents duplicate clicks.
  static Future<bool?> showDeleteVehicle(
    BuildContext context, {
    required String vehicleNumber,
    Future<bool> Function()? onConfirmDelete,
  }) {
    return showShadDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _DeleteVehicleDialog(
        vehicleNumber: vehicleNumber,
        onConfirmDelete: onConfirmDelete,
      ),
    );
  }

  /// Displays general confirmation dialog modally using shadcn.
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
  }) {
    return showShadDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ShadDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.charcoal,
          ),
        ),
        description: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 13.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
        actions: [
          ShadButton.outline(
            child: Text(cancelLabel),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          if (isDestructive)
            ShadButton.destructive(
              backgroundColor: AppColors.red,
              child: Text(confirmLabel),
              onPressed: () => Navigator.of(context).pop(true),
            )
          else
            ShadButton(
              backgroundColor: AppColors.corporateBlue,
              child: Text(confirmLabel),
              onPressed: () => Navigator.of(context).pop(true),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class _DeleteVehicleDialog extends StatefulWidget {
  final String vehicleNumber;
  final Future<bool> Function()? onConfirmDelete;

  const _DeleteVehicleDialog({
    required this.vehicleNumber,
    this.onConfirmDelete,
  });

  @override
  State<_DeleteVehicleDialog> createState() => _DeleteVehicleDialogState();
}

class _DeleteVehicleDialogState extends State<_DeleteVehicleDialog> {
  bool _isDeleting = false;

  Future<void> _handleDelete() async {
    if (_isDeleting) return;
    if (widget.onConfirmDelete == null) {
      Navigator.of(context).pop(true);
      return;
    }

    setState(() => _isDeleting = true);
    final success = await widget.onConfirmDelete!();
    if (mounted) {
      Navigator.of(context).pop(success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      title: const Text(
        'Delete Vehicle',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.deepBlue,
        ),
      ),
      description: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want to delete vehicle ${widget.vehicleNumber}?',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.charcoal,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This action cannot be undone. The vehicle record will be permanently deleted from the system.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
      actions: [
        ShadButton.outline(
          enabled: !_isDeleting,
          onPressed: _isDeleting ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ShadButton.destructive(
          backgroundColor: AppColors.red,
          enabled: !_isDeleting,
          onPressed: _isDeleting ? null : _handleDelete,
          child: _isDeleting
              ? const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text('Deleting...'),
                  ],
                )
              : const Text('Delete'),
        ),
      ],
    );
  }
}
