import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stark_vms_frontend/core/router/route_names.dart';
import 'package:stark_vms_frontend/core/theme/app_colors.dart';
import 'package:stark_vms_frontend/core/utils/validators.dart';
import 'package:stark_vms_frontend/core/widgets/app_button.dart';
import 'package:stark_vms_frontend/core/widgets/app_text_field.dart';
import 'package:stark_vms_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:stark_vms_frontend/features/auth/presentation/widgets/auth_layout.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    ref.read(authNotifierProvider.notifier).clearError();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await ref.read(authNotifierProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (success && mounted) {
      context.go(AppRoutes.vehicles);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return AuthLayout(
      title: 'Sign In',
      subtitle: 'Enter your work credentials to access the fleet dashboard',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Error banner if any
            if (authState.errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.destructiveBackground,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.destructiveBorder),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.destructive,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        authState.errorMessage!,
                        style: const TextStyle(
                          color: AppColors.destructive,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Email input
            AppTextField(
              label: 'Email Address',
              hint: 'e.g. fahim.shakil@stark.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              isRequired: true,
              validator: Validators.validateEmail,
              prefixIcon: const Icon(
                Icons.email_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),

            // Password input
            AppTextField(
              label: 'Password',
              hint: '******',
              controller: _passwordController,
              isPassword: true,
              isRequired: true,
              validator: Validators.validateLoginPassword,
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 24),

            // Sign In Action Button
            AppButton(
              label: 'Sign In',
              isFullWidth: true,
              size: AppButtonSize.lg,
              isLoading: authState.isLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: 20),

            // Navigate to Register link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () {
                    ref.read(authNotifierProvider.notifier).clearError();
                    context.go(AppRoutes.register);
                  },
                  child: const Text(
                    'Create an account',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
