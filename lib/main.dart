import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:stark_vms_frontend/core/config/env_config.dart';
import 'package:stark_vms_frontend/core/router/app_router.dart';
import 'package:stark_vms_frontend/core/storage/hive_service.dart';
import 'package:stark_vms_frontend/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
            return ShadAppBuilder(child: child!);
          },
        );
      },
    );
  }
}
