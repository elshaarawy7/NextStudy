import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/home/home_cubit.dart';
import '../../widgets/metric_chip.dart';
import '../../widgets/section_card.dart';
import '../auth/auth_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final homeState = context.watch<HomeCubit>().state;
    final user = authState.user;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'الحساب',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 24),
            SectionCard(
              child: Row(
                children: [
                  Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      color: AppTheme.secondary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: AppTheme.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'الطالب',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? 'student@nexstudy.ai',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppTheme.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                MetricChip(
                  label: 'المحاضرات',
                  value: '${homeState.lectures.length}',
                ),
                MetricChip(
                  label: 'أيام المذاكرة',
                  value: '${user?.studyStreak ?? 0}',
                ),
              ],
            ),
            const SizedBox(height: 16),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'نبذة',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'تطبيق بسيط لمساعدة طلاب الجامعات على رفع المحاضرات ومراجعتها واختبار فهمهم بشكل يومي.',
                    textDirection: TextDirection.rtl,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppTheme.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthSignedOut());
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthPage()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('تسجيل الخروج'),
            ),
          ],
        ),
      ),
    );
  }
}
