import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
      title: 'Dashboard',
      icon: Icons.dashboard_rounded,
      route: AppRoutes.dashboard,
    ),
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
      message: 'Are you sure you want to log out of Stark Group VMS?',
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
                      'FLEET SYSTEM',
                      style: TextStyle(
                        color: Color(0xFF93C5FD),
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

          // Bottom User Profile & Logout section
          const Divider(height: 1, color: AppColors.sidebarBorder),
          _buildUserSection(context, ref),
        ],
      ),
    );
  }

  Widget _buildBrandHeader(BuildContext context) {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 12 : 20),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.corporateBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(
                Icons.directions_car_filled_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          if (!isCollapsed) ...[
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STARK GROUP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Fleet Management',
                    style: TextStyle(
                      color: Color(0xFFB3D4EE),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserSection(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).user;

    return Container(
      padding: EdgeInsets.all(isCollapsed ? 10 : 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: AppColors.corporateBlue,
            child: Text(
              user?.fullName.isNotEmpty == true
                  ? user!.fullName.substring(0, 1).toUpperCase()
                  : 'S',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          if (!isCollapsed) ...[
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user?.fullName ?? 'Fleet Admin',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    user?.email ?? 'admin@stark.com',
                    style: const TextStyle(
                      color: Color(0xFF93C5FD),
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFFCA5A5),
                size: 18,
              ),
              tooltip: 'Log out',
              onPressed: () => _handleLogout(context, ref),
            ),
          ],
        ],
      ),
    );
  }
}
