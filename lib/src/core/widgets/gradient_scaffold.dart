import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    super.key,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primary.withValues(alpha: 0.12),
              AppTheme.secondary.withValues(alpha: 0.08),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(child: body),
      ),
    );
  }
}
