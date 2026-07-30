import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../application/auth_controller.dart';
import 'widgets/auth_layout.dart';

/// Two-step reset reusing the backend's existing `password_otps`
/// mechanism (spec Section 13): request an OTP, then submit it with a new
/// password. The mock backend hands the OTP straight back (`debug_otp`)
/// since there's no real SMS/email to send it through in development.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  bool _otpRequested = false;
  bool _loading = false;
  bool _done = false;
  String? _error;
  String? _debugOtp;

  Future<void> _requestOtp() async {
    if (_identifierCtrl.text.trim().isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final otp = await ref.read(authControllerProvider).forgotPassword(_identifierCtrl.text.trim());
      setState(() {
        _otpRequested = true;
        _debugOtp = otp;
      });
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resetPassword() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(authControllerProvider).resetPassword(
            identifier: _identifierCtrl.text.trim(),
            otp: _otpCtrl.text.trim(),
            newPassword: _newPasswordCtrl.text,
          );
      setState(() => _done = true);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _identifierCtrl.dispose();
    _otpCtrl.dispose();
    _newPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      tagline: 'We\'ll help you get back in.',
      title: _done ? 'Password reset' : 'Reset password',
      subtitle: _done
          ? 'You can log in with your new password now.'
          : (_otpRequested ? 'Enter the code we sent and a new password.' : 'Enter your email or phone number.'),
      child: _done ? _buildDone(context) : _buildForm(context),
    );
  }

  Widget _buildDone(BuildContext context) {
    return GradientButton(
      label: 'Back to log in',
      icon: Icons.check_circle_outline_rounded,
      onPressed: () => context.go('/login'),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _identifierCtrl,
            enabled: !_otpRequested,
            decoration: const InputDecoration(labelText: 'Email or phone number'),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          if (_otpRequested) ...[
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _otpCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'OTP code'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _newPasswordCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New password'),
              validator: (v) => (v == null || v.length < 8) ? 'At least 8 characters' : null,
            ),
            if (_debugOtp != null) ...[
              const SizedBox(height: AppSpacing.md),
              StatusPill(label: 'Dev only — your OTP is $_debugOtp', tone: StatusPillTone.info),
            ],
          ],
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(_error!, style: const TextStyle(color: AppColors.danger)),
          ],
          const SizedBox(height: AppSpacing.xl),
          GradientButton(
            label: _otpRequested ? 'Reset password' : 'Send code',
            loading: _loading,
            onPressed: _otpRequested ? _resetPassword : _requestOtp,
          ),
        ],
      ),
    );
  }
}
