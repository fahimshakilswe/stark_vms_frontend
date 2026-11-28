import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stark_vms_frontend/core/router/route_names.dart';
import 'package:stark_vms_frontend/core/storage/token_storage.dart';
import 'package:stark_vms_frontend/core/widgets/app_shell/app_shell.dart';
import 'package:stark_vms_frontend/features/auth/presentation/screens/login_screen.dart';
import 'package:stark_vms_frontend/features/auth/presentation/screens/register_screen.dart';
import 'package:stark_vms_frontend/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/screens/vehicle_add_screen.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/screens/vehicle_edit_screen.dart';
import 'package:stark_vms_frontend/features/vehicles/presentation/screens/vehicle_list_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);

  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    redirect: (context, state) async {
      final hasToken = await tokenStorage.hasToken();
      final isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      // Unauthenticated users attempting to access protected routes are redirected to login
      if (!hasToken && !isAuthRoute) {
        return AppRoutes.login;
      }

      // Authenticated users attempting to access login, register or root are redirected to dashboard
      if (hasToken && (isAuthRoute || state.matchedLocation == '/')) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      // Public Authentication Routes (Outside the App Shell)
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      // Protected Application Routes (Inside the App Shell)
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.vehicles,
            builder: (context, state) => const VehicleListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const VehicleAddScreen(),
              ),
              GoRoute(
                path: 'edit/:id',
                builder: (context, state) {
                  final idStr = state.pathParameters['id'] ?? '0';
                  final id = int.tryParse(idStr) ?? 0;
                  return VehicleEditScreen(vehicleId: id);
                },
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '404 - Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.dashboard),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
});
