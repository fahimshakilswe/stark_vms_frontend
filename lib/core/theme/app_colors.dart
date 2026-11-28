import 'package:flutter/material.dart';

/// Enterprise color palette for Stark Group VMS according to design specifications:
/// - Deep Blue: `#1F4E79` — Navigation, sidebar, headings, headers.
/// - Corporate Blue: `#5B9BD5` — Primary actions, buttons, active highlights.
/// - Soft Gray: `#F5F7FA` — Page background.
/// - White: `#FFFFFF` — Cards, forms and tables surfaces.
/// - Charcoal: `#1F2937` — Main text.
/// - Green: `#2E7D32` — Active and success states.
/// - Red: `#D32F2F` — Delete, destructive, and error actions only.
class AppColors {
  AppColors._();

  // Core Specification Palette
  static const Color deepBlue = Color(0xFF1F4E79); // Navigation and headings
  static const Color corporateBlue = Color(0xFF5B9BD5); // Primary actions & highlights
  static const Color softGray = Color(0xFFF5F7FA); // Page background
  static const Color white = Color(0xFFFFFFFF); // Cards, forms and tables
  static const Color charcoal = Color(0xFF1F2937); // Main text
  static const Color green = Color(0xFF2E7D32); // Active and success states
  static const Color red = Color(0xFFD32F2F); // Delete and error actions only

  // Aliases for clean architecture semantics
  static const Color primary = corporateBlue;
  static const Color primaryDark = deepBlue;
  static const Color primaryForeground = Colors.white;

  static const Color accent = corporateBlue;
  static const Color accentHover = Color(0xFF4A88BF);
  static const Color accentForeground = Colors.white;

  // Backgrounds & Surfaces
  static const Color background = softGray;
  static const Color surface = white;
  static const Color surfaceSecondary = Color(0xFFEDF2F7);

  // Sidebar Specific
  static const Color sidebarBackground = deepBlue;
  static const Color sidebarForeground = Color(0xFFE2E8F0);
  static const Color sidebarSelected = Color(0xFF163857);
  static const Color sidebarBorder = Color(0xFF2B5B88);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderSubtle = Color(0xFFEDF2F7);
  static const Color borderFocus = corporateBlue;

  // Text Colors
  static const Color textPrimary = charcoal;
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textMuted = Color(0xFF9CA3AF);

  // Feedback & Status Colors
  static const Color success = green;
  static const Color successBackground = Color(0xFFE8F5E9);
  static const Color successBorder = Color(0xFFA5D6A7);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBackground = Color(0xFFFFFBEB);
  static const Color warningBorder = Color(0xFFFDE68A);

  static const Color destructive = red;
  static const Color destructiveBackground = Color(0xFFFFEBEE);
  static const Color destructiveBorder = Color(0xFFFFCDD2);

  static const Color info = corporateBlue;
  static const Color infoBackground = Color(0xFFEBF3FA);
  static const Color infoBorder = Color(0xFFBCE0FD);

  // Vehicle Status Badge Colors
  // Statuses: AVAILABLE, ACTIVE, INACTIVE, MAINTENANCE
  static Color statusColor(String status) {
    final clean = status.trim().toUpperCase();
    switch (clean) {
      case 'AVAILABLE':
        return green;
      case 'ACTIVE':
        return corporateBlue;
      case 'MAINTENCE':
      case 'MAINTENANCE':
        return const Color(0xFFD97706);
      case 'INACTIVE':
      default:
        return textSecondary;
    }
  }

  static Color statusBackground(String status) {
    final clean = status.trim().toUpperCase();
    switch (clean) {
      case 'AVAILABLE':
        return successBackground;
      case 'ACTIVE':
        return infoBackground;
      case 'MAINTENCE':
      case 'MAINTENANCE':
        return const Color(0xFFFEF3C7);
      case 'INACTIVE':
      default:
        return surfaceSecondary;
    }
  }

  static Color statusBorder(String status) {
    final clean = status.trim().toUpperCase();
    switch (clean) {
      case 'AVAILABLE':
        return successBorder;
      case 'ACTIVE':
        return infoBorder;
      case 'MAINTENCE':
      case 'MAINTENANCE':
        return const Color(0xFFFDE68A);
      case 'INACTIVE':
      default:
        return border;
    }
  }
}
