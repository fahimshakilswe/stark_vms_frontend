import 'package:flutter/material.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';
import 'package:stark_vms_frontend/core/widgets/app_button.dart';

/// Clean error state display with human-readable messaging and retry action.
class ErrorStateView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? title;

  const ErrorStateView({
    super.key,
    required this.message,
    this.onRetry,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.destructiveBackground,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.destructiveBorder),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 30,
                  color: AppColors.destructive,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title ?? 'Something went wrong',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 20),
                AppButton(
                  label: 'Try Again',
                  icon: Icons.refresh_rounded,
                  onPressed: onRetry,
                  variant: AppButtonVariant.outline,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
