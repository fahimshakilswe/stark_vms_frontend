import 'package:flutter/material.dart';

/// Professional enterprise SaaS color palette for Stark VMS.
class AppColors {
  AppColors._();

  // Primary Brand Colors (Deep Slate / Stark Blue)
  static const Color primary = Color(0xFF0F172A); // slate-900
  static const Color primaryHover = Color(0xFF1E293B); // slate-800
  static const Color primaryForeground = Color(0xFFF8FAFC); // slate-50

  // Secondary & Accents
  static const Color accent = Color(0xFF2563EB); // blue-600
  static const Color accentHover = Color(0xFF1D4ED8); // blue-700
  static const Color accentForeground = Colors.white;

  // Background & Surfaces
  static const Color background = Color(0xFFF8FAFC); // slate-50
  static const Color surface = Colors.white;
  static const Color surfaceSecondary = Color(0xFFF1F5F9); // slate-100

  // Sidebar specific
  static const Color sidebarBackground = Color(0xFF0F172A);
  static const Color sidebarForeground = Color(0xFFE2E8F0);
  static const Color sidebarSelected = Color(0xFF1E293B);
  static const Color sidebarBorder = Color(0xFF334155);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0); // slate-200
  static const Color borderSubtle = Color(0xFFF1F5F9); // slate-100
  static const Color borderFocus = Color(0xFF2563EB); // blue-600

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // slate-900
  static const Color textSecondary = Color(0xFF64748B); // slate-500
  static const Color textMuted = Color(0xFF94A3B8); // slate-400

  // Feedback & Status Colors
  static const Color success = Color(0xFF10B981); // emerald-500
  static const Color successBackground = Color(0xFFECFDF5); // emerald-50
  static const Color successBorder = Color(0xFFA7F3D0); // emerald-200

  static const Color warning = Color(0xFFF59E0B); // amber-500
  static const Color warningBackground = Color(0xFFFFFBEB); // amber-50
  static const Color warningBorder = Color(0xFFFDE68A); // amber-200

  static const Color destructive = Color(0xFFEF4444); // red-500
  static const Color destructiveBackground = Color(0xFFFEF2F2); // red-50
  static const Color destructiveBorder = Color(0xFFFECACA); // red-200

  static const Color info = Color(0xFF3B82F6); // blue-500
  static const Color infoBackground = Color(0xFFEFF6FF); // blue-50
  static const Color infoBorder = Color(0xFFBFDBFE); // blue-200

  // Vehicle Status Badges
  static Color statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return success;
      case 'MAINTENANCE':
        return warning;
      case 'INACTIVE':
        return textSecondary;
      case 'RETIRED':
        return destructive;
      default:
        return textSecondary;
    }
  }

  static Color statusBackground(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return successBackground;
      case 'MAINTENANCE':
        return warningBackground;
      case 'INACTIVE':
        return surfaceSecondary;
      case 'RETIRED':
        return destructiveBackground;
      default:
        return surfaceSecondary;
    }
  }

  static Color statusBorder(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return successBorder;
      case 'MAINTENANCE':
        return warningBorder;
      case 'INACTIVE':
        return border;
      case 'RETIRED':
        return destructiveBorder;
      default:
        return border;
    }
  }
}
