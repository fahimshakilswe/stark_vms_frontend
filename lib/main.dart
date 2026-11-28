import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:stark_vms_frontend/core/config/env_config.dart';
import 'package:stark_vms_frontend/core/router/app_router.dart';
import 'package:stark_vms_frontend/core/storage/hive_service.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';
import 'package:stark_vms_frontend/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prevent blank or unstyled crash screens if a widget fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: AppColors.softGray,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.destructiveBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, color: AppColors.red, size: 36),
              const SizedBox(height: 12),
              const Text(
                'Unable to display this section',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepBlue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                details.exceptionAsString(),
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  };

  // Initialize Hive for local preferences
  await HiveService.init();

  runApp(
    const ProviderScope(
      child: StarkVmsApp(),
    ),
  );
}

class StarkVmsApp extends ConsumerWidget {
  const StarkVmsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return ShadApp.custom(
      theme: AppTheme.shadcnTheme(),
      appBuilder: (context) {
        return MaterialApp.router(
          title: EnvConfig.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.materialTheme(),
          routerConfig: router,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
          ],
          builder: (context, child) {
            return ShadAppBuilder(
              child: child ??
                  const Scaffold(
                    backgroundColor: AppColors.softGray,
                    body: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.corporateBlue),
                      ),
                    ),
                  ),
            );
          },
        );
      },
    );
  }
}
