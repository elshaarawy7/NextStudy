import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/lecture.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/home/home_cubit.dart';
import '../../blocs/home/home_state.dart';
import '../../widgets/empty_state_card.dart';
import '../../widgets/lecture_pdf_card.dart';
import '../../widgets/metric_chip.dart';
import '../../widgets/section_card.dart';
import '../analysis/analysis_page.dart';
import '../flashcards/flashcards_page.dart';
import '../quiz/quiz_page.dart';
import '../upload/upload_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _openUpload(BuildContext context) async {
    final lecture = await Navigator.of(
      context,
    ).push<Lecture>(MaterialPageRoute(builder: (_) => const UploadPage()));

    if (lecture != null && context.mounted) {
      context.read<HomeCubit>().prependLecture(lecture);
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => AnalysisPage(lecture: lecture)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final latestLecture = state.lectures.isEmpty
                ? null
                : state.lectures.first;

            return RefreshIndicator(
              onRefresh: context.read<HomeCubit>().loadLectures,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    'مرحبًا، ماذا تريد أن تذاكر اليوم؟',
                    textDirection: TextDirection.rtl,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'نظّم محاضراتك وابدأ المذاكرة بطريقة بسيطة ومريحة كل يوم.',
                    textDirection: TextDirection.rtl,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppTheme.muted),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      MetricChip(
                        label: 'اسم الطالب',
                        value: user?.name ?? 'طالب',
                      ),
                      MetricChip(
                        label: 'المحاضرات',
                        value: '${state.lectures.length}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'رفع محاضرة جديدة',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'أضف ملف PDF جديد ليتم تلخيصه وتجهيزه للمراجعة والاختبار.',
                          textDirection: TextDirection.rtl,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppTheme.muted),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _openUpload(context),
                            icon: const Icon(Icons.upload_file_rounded),
                            label: const Text('رفع PDF'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'أكمل المذاكرة',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (latestLecture == null)
                    const EmptyStateCard(
                      icon: Icons.menu_book_outlined,
                      title: 'لا يوجد محتوى للمراجعة',
                      message: 'لم تقم برفع أي محاضرات بعد',
                    )
                  else
                    _ContinueStudyingCard(lecture: latestLecture),
                  const SizedBox(height: 20),
                  Text(
                    'آخر المحاضرات',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (state.status == HomeStatus.loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.lectures.isEmpty)
                    const EmptyStateCard(
                      icon: Icons.picture_as_pdf_outlined,
                      title: 'لا توجد محاضرات',
                      message: 'لم تقم برفع أي محاضرات بعد',
                    )
                  else
                    ...state.lectures
                        .take(3)
                        .map(
                          (lecture) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: LecturePdfCard(
                              lecture: lecture,
                              compact: true,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AnalysisPage(lecture: lecture),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ContinueStudyingCard extends StatelessWidget {
  const _ContinueStudyingCard({required this.lecture});

  final Lecture lecture;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lecture.title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            lecture.previewText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textDirection: TextDirection.rtl,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.muted),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AnalysisPage(lecture: lecture),
                      ),
                    );
                  },
                  child: const Text('فتح الملخص'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: lecture.analysis == null
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => QuizPage(lecture: lecture),
                            ),
                          );
                        },
                  child: const Text('الاختبار'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: lecture.analysis == null
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FlashcardsPage(lecture: lecture),
                            ),
                          );
                        },
                  child: const Text('البطاقات'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
