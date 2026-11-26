import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stark_vms_frontend/core/config/env_config.dart';
import 'package:stark_vms_frontend/core/router/route_names.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';
import 'package:stark_vms_frontend/core/widgets/app_shell/app_sidebar.dart';
import 'package:stark_vms_frontend/core/widgets/confirm_dialog.dart';
import 'package:stark_vms_frontend/features/auth/presentation/providers/auth_provider.dart';

/// Top-level application shell with responsive sidebar navigation and content frame.
class AppShell extends ConsumerStatefulWidget {
  final Widget child;

  const AppShell({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _getPageTitle(String location) {
    if (location == AppRoutes.vehicles) {
      return 'Vehicle Management';
    } else if (location == AppRoutes.addVehicle) {
      return 'Register New Vehicle';
    } else if (location.startsWith('/vehicles/edit')) {
      return 'Edit Vehicle';
    }
    return EnvConfig.appName;
  }

  Future<void> _handleLogout() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Log out',
      message: 'Are you sure you want to log out of Stark VMS?',
      confirmLabel: 'Log out',
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      await ref.read(authNotifierProvider.notifier).logout();
      if (mounted) {
        context.go(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1024;
    final isTablet = width >= 768 && width < 1024;
    final isMobile = width < 768;

    final location = GoRouterState.of(context).matchedLocation;
    final pageTitle = _getPageTitle(location);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: isMobile
          ? Drawer(
              backgroundColor: AppColors.sidebarBackground,
              child: AppSidebar(
                currentRoute: location,
                onNavigate: () => Navigator.of(context).pop(),
              ),
            )
          : null,
      body: Row(
        children: [
          // Desktop & Tablet Persistent Sidebar
          if (isDesktop)
            AppSidebar(currentRoute: location)
          else if (isTablet)
            AppSidebar(currentRoute: location, isCollapsed: true),

          // Main Content Area with Header
          Expanded(
            child: Column(
              children: [
                // Top Application Header
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      bottom: BorderSide(color: AppColors.border, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (isMobile) ...[
                        IconButton(
                          icon: const Icon(
                            Icons.menu_rounded,
                            color: AppColors.textPrimary,
                          ),
                          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          pageTitle,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      // Top bar quick actions
                      Tooltip(
                        message: 'Log out',
                        child: IconButton(
                          icon: const Icon(
                            Icons.logout_rounded,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          onPressed: _handleLogout,
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Child View
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
