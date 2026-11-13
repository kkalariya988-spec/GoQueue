import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goqueue/app/app.dart';
import 'package:goqueue/core/widgets/app_button.dart';
import 'package:goqueue/features/auth/data/auth_service.dart';
import 'package:goqueue/features/auth/presentation/pages/login_page.dart';
import 'package:goqueue/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:goqueue/features/auth/presentation/pages/signup_page.dart';
import 'package:goqueue/features/auth/presentation/pages/success_page.dart';
import 'package:goqueue/features/user/presentation/pages/user_home_page.dart';

void main() {
  setUp(() => AuthService.instance.logout());

  testWidgets('Create account -> OTP -> success -> back to login', (
    tester,
  ) async {
    await tester.pumpWidget(const GoQueueApp());
    await tester.pump(const Duration(milliseconds: 2400));
    await tester.pumpAndSettle();

    // Login → Sign Up.
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();
    expect(find.byType(SignUpPage), findsOneWidget);

    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(5));
    await tester.enterText(fields.at(0), 'Aarav Shah');
    await tester.enterText(fields.at(1), 'aarav@example.com');
    await tester.enterText(fields.at(2), '9876543210');
    await tester.enterText(fields.at(3), 'secret123');
    await tester.enterText(fields.at(4), 'secret123');

    final checkbox = find.byType(Checkbox);
    await tester.ensureVisible(checkbox);
    await tester.pumpAndSettle();
    await tester.tap(checkbox);
    await tester.pump();

    final createButton = find.widgetWithText(AppButton, 'Create Account');
    await tester.ensureVisible(createButton);
    await tester.pumpAndSettle();
    await tester.tap(createButton);
    await tester.pumpAndSettle();

    // OTP step.
    expect(find.byType(OtpVerificationPage), findsOneWidget);
    final otpFields = find.byType(TextField);
    expect(otpFields, findsNWidgets(6));
    for (var index = 0; index < 6; index++) {
      await tester.enterText(otpFields.at(index), '${index + 1}');
    }
    await tester.pump();

    final verifyButton = find.widgetWithText(AppButton, 'Verify OTP');
    await tester.ensureVisible(verifyButton);
    await tester.pumpAndSettle();
    await tester.tap(verifyButton);
    await tester.pumpAndSettle();

    // Success step.
    expect(find.byType(SuccessPage), findsOneWidget);
    expect(find.text('Account Created!'), findsOneWidget);

    final backButton = find.widgetWithText(AppButton, 'Back to Login');
    await tester.ensureVisible(backButton);
    await tester.pumpAndSettle();
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('demo credentials sign in and invalid credentials are rejected', (
    tester,
  ) async {
    await tester.pumpWidget(const GoQueueApp());
    await tester.pump(const Duration(milliseconds: 2400));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);

    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(3));

    Future<void> submit({
      required String name,
      required String email,
      required String password,
    }) async {
      await tester.enterText(fields.at(0), name);
      await tester.enterText(fields.at(1), email);
      await tester.enterText(fields.at(2), password);
      final loginButton = find.widgetWithText(AppButton, 'Login');
      await tester.ensureVisible(loginButton);
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
    }

    await submit(
      name: 'Wrong Name',
      email: 'wrong@example.com',
      password: '000000',
    );
    expect(find.text('Incorrect name, email or password.'), findsOneWidget);
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(UserHomePage), findsNothing);

    await submit(
      name: AuthService.demoName,
      email: AuthService.demoEmail,
      password: AuthService.demoPassword,
    );
    expect(find.byType(UserHomePage), findsOneWidget);
    expect(find.text('Hi, Khushi'), findsOneWidget);
    expect(find.text('Popular Services'), findsOneWidget);
    expect(find.text('Top Salons Near You'), findsOneWidget);

    await tester.tap(find.byKey(const Key('bottom_nav_4')));
    await tester.pumpAndSettle();
    expect(find.text(AuthService.demoEmail), findsOneWidget);

    final logoutButton = find.widgetWithText(AppButton, 'Log Out');
    await tester.ensureVisible(logoutButton);
    await tester.pumpAndSettle();
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(AuthService.instance.currentUser, isNull);
  });
}
