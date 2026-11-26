import 'package:flutter/material.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';

/// Password requirement checklist item displayed during user registration.
class PasswordRequirementItem extends StatelessWidget {
  final String label;
  final bool isMet;

  const PasswordRequirementItem({
    super.key,
    required this.label,
    required this.isMet,
  });

  @override
  Widget build(BuildContext context) {
    final color = isMet ? AppColors.success : AppColors.textMuted;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isMet ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: isMet ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
