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
        decoration: BoxDecoration(color: AppTheme.scaffold),
        child: SafeArea(child: body),
      ),
    );
  }
}
