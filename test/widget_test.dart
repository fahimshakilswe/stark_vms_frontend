import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stark_vms_frontend/core/utils/validators.dart';
import 'package:stark_vms_frontend/core/widgets/app_button.dart';
import 'package:stark_vms_frontend/main.dart';

void main() {
  group('Validators Unit Tests', () {
    test('validateEmail validates correct email format', () {
      expect(Validators.validateEmail('user@stark.com'), isNull);
      expect(Validators.validateEmail(''), 'Email is required');
      expect(Validators.validateEmail('invalid-email'), 'Please enter a valid email address');
    });

    test('validateStrongPassword enforces backend complexity requirements', () {
      expect(Validators.validateStrongPassword('ValidPass123!'), isNull);
      expect(Validators.validateStrongPassword('short1!'), 'Password must be at least 8 characters');
      expect(Validators.validateStrongPassword('alllowercase1!'), 'Password must contain at least one uppercase letter (A-Z)');
      expect(Validators.validateStrongPassword('ALLUPPERCASE1!'), 'Password must contain at least one lowercase letter (a-z)');
      expect(Validators.validateStrongPassword('NoSpecialChar123'), 'Password must contain at least one special character (!@#\$%...)');
      expect(Validators.validateStrongPassword('NoNumbersHere!'), 'Password must contain at least one digit (0-9)');
    });

    test('validateVehicleNumber checks non-empty and length limit', () {
      expect(Validators.validateVehicleNumber('DHAKA-METRO-GA-1234'), isNull);
      expect(Validators.validateVehicleNumber(''), 'Vehicle number is required');
    });
  });

  group('Widget Rendering Tests', () {
    testWidgets('AppTextField renders properly within StarkVmsApp without missing MaterialLocalizations', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: StarkVmsApp(),
        ),
      );

      // Verify that StarkVmsApp builds without throwing No MaterialLocalizations found
      await tester.pump();
      expect(find.byType(StarkVmsApp), findsOneWidget);
    });

    testWidgets('AppButton renders properly without assertion failure on shape and borderRadius', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                AppButton(label: 'Primary', onPressed: () {}),
                AppButton(label: 'Secondary', variant: AppButtonVariant.secondary, onPressed: () {}),
                AppButton(label: 'Outline', variant: AppButtonVariant.outline, onPressed: () {}),
                AppButton(label: 'Destructive', variant: AppButtonVariant.destructive, onPressed: () {}),
                AppButton(label: 'Ghost', variant: AppButtonVariant.ghost, onPressed: () {}),
              ],
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Primary'), findsOneWidget);
      expect(find.text('Secondary'), findsOneWidget);
      expect(find.text('Outline'), findsOneWidget);
      expect(find.text('Destructive'), findsOneWidget);
      expect(find.text('Ghost'), findsOneWidget);
    });
  });
}
