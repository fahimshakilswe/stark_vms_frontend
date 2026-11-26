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
import 'package:stark_vms_frontend/features/auth/presentation/widgets/password_requirement_item.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _successMessage;

  // Password requirements live state
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasDigit = false;
  bool _hasSpecialChar = false;
  bool _hasNoWhitespace = true;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updatePasswordRequirements);
  }

  void _updatePasswordRequirements() {
    final text = _passwordController.text;
    setState(() {
      _hasMinLength = text.length >= 8 && text.length <= 64;
      _hasUppercase = RegExp(r'[A-Z]').hasMatch(text);
      _hasLowercase = RegExp(r'[a-z]').hasMatch(text);
      _hasDigit = RegExp(r'[0-9]').hasMatch(text);
      _hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>\-_=+]').hasMatch(text);
      _hasNoWhitespace = !RegExp(r'\s').hasMatch(text);
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _successMessage = null;
    });
    ref.read(authNotifierProvider.notifier).clearError();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await ref.read(authNotifierProvider.notifier).register(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (success && mounted) {
      setState(() {
        _successMessage = 'Registration successful! Redirecting to login...';
      });

      // On successful registration, navigate to Login
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) {
          context.go(AppRoutes.login);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return AuthLayout(
      title: 'Create Account',
      subtitle: 'Join the Stark fleet system to manage vehicle operations',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Error banner from backend
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

            // Success banner
            if (_successMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.successBackground,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.successBorder),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      color: AppColors.success,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _successMessage!,
                        style: const TextStyle(
                          color: AppColors.success,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Full Name input
            AppTextField(
              label: 'Full Name',
              hint: 'e.g. John Doe',
              controller: _fullNameController,
              isRequired: true,
              validator: Validators.validateFullName,
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),

            // Email input
            AppTextField(
              label: 'Email Address',
              hint: 'e.g. john.doe@stark.com',
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
              hint: 'Min 8 chars, mixed case, number & symbol',
              controller: _passwordController,
              isPassword: true,
              isRequired: true,
              validator: Validators.validateStrongPassword,
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),

            // Live Password Requirements checklist
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Password Requirements:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  PasswordRequirementItem(
                    label: '8-64 characters long',
                    isMet: _hasMinLength,
                  ),
                  PasswordRequirementItem(
                    label: 'At least 1 uppercase letter (A-Z)',
                    isMet: _hasUppercase,
                  ),
                  PasswordRequirementItem(
                    label: 'At least 1 lowercase letter (a-z)',
                    isMet: _hasLowercase,
                  ),
                  PasswordRequirementItem(
                    label: 'At least 1 digit (0-9)',
                    isMet: _hasDigit,
                  ),
                  PasswordRequirementItem(
                    label: 'At least 1 special symbol (!@#\$%...)',
                    isMet: _hasSpecialChar,
                  ),
                  PasswordRequirementItem(
                    label: 'No whitespace',
                    isMet: _hasNoWhitespace,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Confirm Password input
            AppTextField(
              label: 'Confirm Password',
              hint: 'Re-enter your password',
              controller: _confirmPasswordController,
              isPassword: true,
              isRequired: true,
              validator: (val) => Validators.validateConfirmPassword(
                val,
                _passwordController.text,
              ),
              prefixIcon: const Icon(
                Icons.lock_clock_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 24),

            // Register Submit Button
            AppButton(
              label: 'Create Account',
              isFullWidth: true,
              size: AppButtonSize.lg,
              isLoading: authState.isLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: 20),

            // Sign In Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () {
                    ref.read(authNotifierProvider.notifier).clearError();
                    context.go(AppRoutes.login);
                  },
                  child: const Text(
                    'Sign in',
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
