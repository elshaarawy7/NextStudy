import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/lecture.dart';

class LecturePdfCard extends StatelessWidget {
  const LecturePdfCard({
    super.key,
    required this.lecture,
    required this.onTap,
    this.compact = false,
  });

  final Lecture lecture;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: EdgeInsets.all(compact ? 14 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.border),
          boxShadow: AppTheme.softShadow(),
        ),
        child: Row(
          children: [
            Container(
              width: compact ? 64 : 72,
              height: compact ? 82 : 92,
              decoration: BoxDecoration(
                color: AppTheme.accent,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: AppTheme.primary,
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${lecture.pageCount}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'صفحة',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppTheme.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lecture.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    lecture.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppTheme.muted),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MetaTag(
                        icon: Icons.calendar_today_outlined,
                        text: DateFormatter.shortArabic(lecture.uploadedAt),
                      ),
                      _MetaTag(
                        icon: Icons.menu_book_outlined,
                        text: lecture.course,
                      ),
                    ],
                  ),
                  if (!compact) ...[
                    const SizedBox(height: 10),
                    Text(
                      lecture.previewText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppTheme.muted),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_left_rounded, color: AppTheme.muted),
          ],
        ),
      ),
    );
  }
}

class _MetaTag extends StatelessWidget {
  const _MetaTag({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.accent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.muted),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.muted),
          ),
        ],
      ),
    );
  }
}
