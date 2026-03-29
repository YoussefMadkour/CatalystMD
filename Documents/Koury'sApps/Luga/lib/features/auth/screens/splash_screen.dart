import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final user = ref.read(currentUserProvider);
    if (user != null) {
      context.goNamed(RouteNames.tripsHome);
    } else {
      context.goNamed(RouteNames.languageSelect);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.flight_takeoff_rounded,
              size: 56.w,
              color: Colors.white.withValues(alpha: 0.9),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: -0.3, end: 0, curve: Curves.easeOut),
            SizedBox(height: 16.h),
            Text(
              'Luga',
              style: TextStyle(
                fontSize: 48.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 2,
              ),
            )
                .animate()
                .fadeIn(duration: 800.ms, delay: 200.ms)
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  curve: Curves.easeOutBack,
                  delay: 200.ms,
                  duration: 800.ms,
                ),
            SizedBox(height: 8.h),
            Text(
              'Deliver with every flight',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.7),
                letterSpacing: 0.5,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 600.ms),
          ],
        ),
      ),
    );
  }
}
