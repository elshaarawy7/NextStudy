import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../auth/auth_page.dart';
import '../shell/app_shell_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), _goNext);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goNext() {
    final authState = context.read<AuthBloc>().state;
    final page = authState.status == AuthStatus.authenticated
        ? const AppShellPage()
        : const AuthPage();

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GradientScaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.92, end: 1),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOut,
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: Transform.scale(scale: value, child: child),
                ),
                child: Container(
                  height: 118,
                  width: 118,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(34),
                    boxShadow: AppTheme.softShadow(),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 68,
                        width: 68,
                        decoration: BoxDecoration(
                          gradient: AppTheme.heroGradient(),
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      const Icon(
                        Icons.menu_book_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                      Positioned(
                        top: 26,
                        right: 24,
                        child: Container(
                          height: 14,
                          width: 14,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accent.withValues(alpha: 0.20),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 26),
              Text(
                AppConfig.appName,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppConfig.studyGreeting,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: textTheme.titleMedium?.copyWith(
                  color: AppTheme.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 28),
              Container(
                width: 120,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 54,
                    decoration: BoxDecoration(
                      gradient: AppTheme.heroGradient(),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
