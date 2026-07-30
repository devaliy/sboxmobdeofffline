import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../application/auth_controller.dart';

/// Checks for a cached session and routes to the auth gate or straight
/// past it (spec Section 7). The check itself is local-first (works fully
/// offline/in airplane mode) — see [AuthController.bootstrap].
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // A brief floor so the logo intro isn't a flash even when the local
    // session check resolves instantly.
    Future.wait([
      ref.read(authControllerProvider).bootstrap(),
      Future<void>.delayed(const Duration(milliseconds: 700)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.inkNavyDeep,
      body: const Center(
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.white),
          child: AnimatedLogoIntro(),
        ),
      ),
    );
  }
}
