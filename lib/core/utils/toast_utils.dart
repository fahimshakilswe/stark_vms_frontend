import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';

/// Clean, enterprise toast and feedback notification helper using Shadcn UI.
class AppToast {
  AppToast._();

  static void showSuccess(BuildContext context, String message, {String title = 'Success'}) {
    try {
      ShadToaster.of(context).show(
        ShadToast(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.green, size: 18),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.green)),
            ],
          ),
          description: Text(message, style: const TextStyle(color: AppColors.charcoal, fontSize: 13)),
          backgroundColor: AppColors.white,
        ),
      );
    } catch (_) {
      _showSnackBar(
        context,
        message: message,
        icon: Icons.check_circle_rounded,
        iconColor: AppColors.green,
        backgroundColor: AppColors.deepBlue,
      );
    }
  }

  static void showError(BuildContext context, String message, {String title = 'Error'}) {
    try {
      ShadToaster.of(context).show(
        ShadToast.destructive(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          description: Text(message, style: const TextStyle(fontSize: 13)),
          backgroundColor: AppColors.red,
        ),
      );
    } catch (_) {
      _showSnackBar(
        context,
        message: message,
        icon: Icons.error_outline_rounded,
        iconColor: const Color(0xFFFCA5A5),
        backgroundColor: AppColors.red,
      );
    }
  }

  static void showInfo(BuildContext context, String message, {String title = 'Info'}) {
    try {
      ShadToaster.of(context).show(
        ShadToast(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline_rounded, color: AppColors.corporateBlue, size: 18),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.corporateBlue)),
            ],
          ),
          description: Text(message, style: const TextStyle(color: AppColors.charcoal, fontSize: 13)),
          backgroundColor: AppColors.white,
        ),
      );
    } catch (_) {
      _showSnackBar(
        context,
        message: message,
        icon: Icons.info_outline_rounded,
        iconColor: const Color(0xFF93C5FD),
        backgroundColor: AppColors.deepBlue,
      );
    }
  }

  static void _showSnackBar(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
