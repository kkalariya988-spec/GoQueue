import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../widgets/auth_back_to_login.dart';
import '../widgets/auth_brand_block.dart';
import '../widgets/auth_page_shell.dart';
import 'otp_verification_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendResetLink() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    NavigationService.pushNamed(
      RouteNames.otpVerification,
      arguments: OtpPurpose.resetPassword,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tight = MediaQuery.sizeOf(context).height < 720;

    return AuthPageShell(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthBrandBlock(),
            const Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "No worries! Enter your email address and we'll send you a "
              'link to reset your password.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            SizedBox(height: tight ? 14 : 20),
            AppTextField(
              controller: _emailController,
              hint: 'Enter your email address',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(
                Icons.mail_outline_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) {
                  return 'Please enter your email';
                }
                if (!email.contains('@') || !email.contains('.')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: tight ? 12 : 16),
            AppButton(text: 'Send Reset Link', onPressed: _handleSendResetLink),
            SizedBox(height: tight ? 12 : 16),
            Center(
              child: Text(
                'Remember your password?',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  height: 1.4,
                ),
              ),
            ),
            const Spacer(),
            const Center(child: AuthBackToLogin()),
            SizedBox(height: tight ? 16 : 28),
          ],
        ),
      ),
    );
  }
}
