import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'section_card.dart';

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        children: [
          Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              color: AppTheme.accent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.border),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 34),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textDirection: TextDirection.rtl,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.muted),
          ),
        ],
      ),
    );
  }
}
