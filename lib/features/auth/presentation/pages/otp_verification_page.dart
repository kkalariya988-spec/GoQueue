import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/auth_back_to_login.dart';
import '../widgets/auth_brand_block.dart';
import '../widgets/auth_page_shell.dart';
import 'success_page.dart';

/// Where the verification code came from, which decides the copy and the next
/// screen after a successful check.
enum OtpPurpose { signUp, resetPassword }

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({
    super.key,
    this.purpose = OtpPurpose.resetPassword,
  });

  final OtpPurpose purpose;

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  static const int _otpLength = 6;
  static const int _resendSeconds = 45;

  final List<TextEditingController> _controllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _otpLength,
    (_) => FocusNode(),
  );

  Timer? _timer;
  int _secondsLeft = _resendSeconds;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  void _resendCode() {
    for (final controller in _controllers) {
      controller.clear();
    }
    setState(() {
      _secondsLeft = _resendSeconds;
      _error = null;
    });
    _startCountdown();
    _focusNodes.first.requestFocus();
  }

  void _handleVerify() {
    final code = _controllers.map((controller) => controller.text).join();
    if (code.length != _otpLength) {
      setState(() => _error = 'Please enter the complete 6-digit code');
      final emptyIndex = _controllers.indexWhere(
        (controller) => controller.text.isEmpty,
      );
      if (emptyIndex >= 0) {
        _focusNodes[emptyIndex].requestFocus();
      }
      return;
    }

    setState(() => _error = null);

    if (widget.purpose == OtpPurpose.signUp) {
      NavigationService.pushReplacementNamed(
        RouteNames.success,
        arguments: const SuccessArgs(
          title: 'Account Created!',
          subtitle: 'Your account has been verified and setup successfully.',
          buttonText: 'Back to Login',
        ),
      );
    } else {
      NavigationService.pushReplacementNamed(RouteNames.resetPassword);
    }
  }

  String get _timerLabel => '00:${_secondsLeft.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final tight = MediaQuery.sizeOf(context).height < 720;
    final isSignUp = widget.purpose == OtpPurpose.signUp;
    final subtitle = isSignUp
        ? "We've sent a 6-digit OTP to your registered mobile number. "
              'Please enter it below to verify your account.'
        : "We've sent a 6-digit OTP to your registered email address. "
              'Enter it below to reset your password.';

    return AuthPageShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthBrandBlock(),
          const Text(
            'OTP Verification',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          SizedBox(height: tight ? 18 : 22),
          Row(
            children: [
              for (var index = 0; index < _otpLength; index++) ...[
                if (index > 0) const SizedBox(width: 10),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                      style: TextStyle(
                        fontSize: tight ? 18 : 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: AppRadius.borderMd,
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: AppRadius.borderMd,
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: AppRadius.borderMd,
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < _otpLength - 1) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        if (_error != null) {
                          setState(() => _error = null);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _error!,
                style: const TextStyle(color: AppColors.error, fontSize: 12),
              ),
            ),
          SizedBox(height: tight ? 16 : 20),
          AppButton(text: 'Verify OTP', onPressed: _handleVerify),
          SizedBox(height: tight ? 10 : 14),
          const Center(
            child: Text(
              "Didn't receive the code?",
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
                height: 1.4,
              ),
            ),
          ),
          TextButton(
            onPressed: _secondsLeft == 0 ? _resendCode : null,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 4),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              _secondsLeft == 0 ? 'Resend OTP' : 'Resend OTP ($_timerLabel)',
              style: TextStyle(
                color: _secondsLeft == 0
                    ? AppColors.primary
                    : AppColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          const Center(child: AuthBackToLogin()),
          SizedBox(height: tight ? 16 : 28),
        ],
      ),
    );
  }
}
