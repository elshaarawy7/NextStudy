import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../../domain/entities/lecture.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/home/home_cubit.dart';
import '../../blocs/home/home_state.dart';
import '../../widgets/metric_chip.dart';
import '../../widgets/section_card.dart';
import '../analysis/analysis_page.dart';
import '../auth/auth_page.dart';
import '../upload/upload_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);

    return GradientScaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final lecture = await Navigator.of(context).push<Lecture>(
            MaterialPageRoute(builder: (_) => const UploadPage()),
          );

          if (lecture != null && context.mounted) {
            context.read<HomeCubit>().prependLecture(lecture);
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AnalysisPage(lecture: lecture)),
            );
          }
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.upload_file_rounded),
        label: const Text('Upload PDF'),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: context.read<HomeCubit>().loadLectures,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi ${user?.name ?? 'Student'}',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Let AI turn dense lecture notes into quick revision wins.',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppTheme.muted),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(const AuthSignedOut());
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const AuthPage()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppTheme.heroGradient(),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: AppTheme.softShadow(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your study momentum',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Upload a lecture, get calm step-by-step explanations, then test yourself with AI quizzes.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.88),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          MetricChip(
                            label: 'Streak',
                            value: '${user?.studyStreak ?? 0} days',
                          ),
                          MetricChip(
                            label: 'Lectures',
                            value: '${state.lectures.length}',
                          ),
                          const MetricChip(label: 'Mode', value: 'Mock AI'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent lectures',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 18),
                      if (state.status == HomeStatus.loading)
                        const Center(child: CircularProgressIndicator())
                      else if (state.lectures.isEmpty)
                        const Text(
                          'No lectures yet. Upload your first PDF to begin.',
                        )
                      else
                        ...state.lectures.map(
                          (lecture) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _LectureTile(lecture: lecture),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LectureTile extends StatelessWidget {
  const _LectureTile({required this.lecture});

  final Lecture lecture;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => AnalysisPage(lecture: lecture)),
        );
      },
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FE),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.picture_as_pdf_rounded,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lecture.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    lecture.previewText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppTheme.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
