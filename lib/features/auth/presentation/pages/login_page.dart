import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/auth_service.dart';
import '../widgets/auth_brand_block.dart';
import '../widgets/auth_page_shell.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearError(String _) {
    if (_errorMessage != null) {
      setState(() => _errorMessage = null);
    }
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (_errorMessage != null) {
      setState(() => _errorMessage = null);
    }
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSubmitting = true);
    final user = await AuthService.instance.login(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (!mounted) {
      return;
    }

    if (user == null) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = 'Incorrect email or password.';
      });
      return;
    }

    setState(() => _isSubmitting = false);

    switch (user.role) {
      case 'admin':
        NavigationService.pushReplacementNamed(RouteNames.adminDashboard);
        break;
      case 'manager':
        NavigationService.pushReplacementNamed(RouteNames.managerDashboard);
        break;
      case 'customer':
      default:
        NavigationService.pushReplacementNamed(RouteNames.userHome);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tight = MediaQuery.sizeOf(context).height < 720;
    final fieldsGap = tight ? 20.0 : 30.0;
    final fieldSpacing = tight ? 12.0 : 16.0;
    final forgotGap = tight ? 8.0 : 10.0;
    final buttonGap = tight ? 20.0 : 28.0;
    final footerGap = tight ? 16.0 : AppSpacing.lg;

    return AuthPageShell(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthBrandBlock(),
            const Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Login to continue your beauty journey.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            SizedBox(height: fieldsGap),
            AppTextField(
              controller: _nameController,
              hint: 'Enter your full name',
              keyboardType: TextInputType.name,
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              onChanged: _clearError,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: fieldSpacing),
            AppTextField(
              controller: _emailController,
              hint: 'Enter your email address',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(
                Icons.mail_outline_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              onChanged: _clearError,
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
            SizedBox(height: fieldSpacing),
            AppTextField(
              controller: _passwordController,
              hint: 'Enter Password',
              obscureText: _obscurePassword,
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              onChanged: _clearError,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            SizedBox(height: forgotGap),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  NavigationService.pushNamed(RouteNames.forgotPassword);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (_errorMessage != null) ...[
              SizedBox(height: tight ? 8 : 10),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            SizedBox(
              height: _errorMessage == null ? buttonGap : (tight ? 12 : 14),
            ),
            AppButton(
              text: 'Login',
              isLoading: _isSubmitting,
              onPressed: _isSubmitting ? null : _handleLogin,
            ),
            const Spacer(),
            SizedBox(height: footerGap),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    NavigationService.pushNamed(RouteNames.signUp);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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
