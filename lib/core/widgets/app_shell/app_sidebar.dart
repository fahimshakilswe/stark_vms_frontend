import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stark_vms_frontend/core/config/env_config.dart';
import 'package:stark_vms_frontend/core/router/route_names.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';
import 'package:stark_vms_frontend/core/widgets/app_shell/sidebar_item.dart';
import 'package:stark_vms_frontend/core/widgets/confirm_dialog.dart';
import 'package:stark_vms_frontend/features/auth/presentation/providers/auth_provider.dart';

class AppSidebar extends ConsumerWidget {
  final String currentRoute;
  final bool isCollapsed;
  final VoidCallback? onNavigate;

  const AppSidebar({
    super.key,
    required this.currentRoute,
    this.isCollapsed = false,
    this.onNavigate,
  });

  static const List<SidebarItemData> navItems = [
    SidebarItemData(
      title: 'Vehicle Fleet',
      icon: Icons.directions_car_filled_outlined,
      route: AppRoutes.vehicles,
    ),
    SidebarItemData(
      title: 'Register Vehicle',
      icon: Icons.add_circle_outline_rounded,
      route: AppRoutes.addVehicle,
    ),
  ];

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Log out',
      message: 'Are you sure you want to log out of Stark VMS?',
      confirmLabel: 'Log out',
      isDestructive: true,
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authNotifierProvider.notifier).logout();
      if (context.mounted) {
        context.go(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: isCollapsed ? 68 : 250,
      decoration: const BoxDecoration(
        color: AppColors.sidebarBackground,
        border: Border(
          right: BorderSide(color: AppColors.sidebarBorder, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Branding Header
          _buildBrandHeader(context),
          const Divider(height: 1, color: AppColors.sidebarBorder),
          const SizedBox(height: 12),

          // Navigation Links
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                if (!isCollapsed)
                  const Padding(
                    padding: EdgeInsets.only(left: 20, top: 8, bottom: 8),
                    child: Text(
                      'MANAGEMENT',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ...navItems.map((item) {
                  final isSelected = currentRoute == item.route ||
                      (item.route == AppRoutes.vehicles &&
                          currentRoute.startsWith('/vehicles') &&
                          currentRoute != AppRoutes.addVehicle);

                  return SidebarItemWidget(
                    item: item,
                    isSelected: isSelected,
                    isCollapsed: isCollapsed,
                    onTap: () {
                      onNavigate?.call();
                      context.go(item.route);
                    },
                  );
                }),
              ],
            ),
          ),

          // User Profile & Logout section
          const Divider(height: 1, color: AppColors.sidebarBorder),
          _buildProfileFooter(context, ref),
        ],
      ),
    );
  }

  Widget _buildBrandHeader(BuildContext context) {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 12 : 18),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x332563EB),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          if (!isCollapsed) ...[
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  EnvConfig.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Enterprise Fleet',
                  style: TextStyle(
                    color: AppColors.sidebarForeground.withValues(alpha: 0.6),
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileFooter(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).user;

    if (isCollapsed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: IconButton(
          icon: const Icon(
            Icons.logout_rounded,
            color: Color(0xFF94A3B8),
            size: 20,
          ),
          tooltip: 'Log out',
          onPressed: () => _handleLogout(context, ref),
        ),
      );
    }

    final displayName = user?.fullName.isNotEmpty == true ? user!.fullName : 'Fleet Officer';
    final displayEmail = user?.email.isNotEmpty == true ? user!.email : 'user@stark.com';

    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: AppColors.accent.withValues(alpha: 0.2),
            child: Text(
              displayName.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  displayEmail,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: Color(0xFF94A3B8),
              size: 19,
            ),
            tooltip: 'Log out',
            onPressed: () => _handleLogout(context, ref),
          ),
        ],
      ),
    );
  }
}
