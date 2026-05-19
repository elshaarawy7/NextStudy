import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/home/home_cubit.dart';
import '../../blocs/home/home_state.dart';
import '../../widgets/empty_state_card.dart';
import '../../widgets/section_card.dart';
import '../analysis/analysis_page.dart';
import '../quiz/quiz_page.dart';

class QuizzesPage extends StatelessWidget {
  const QuizzesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final lecturesWithAnalysis = state.lectures
                .where((lecture) => lecture.analysis != null)
                .toList();

            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'الاختبارات',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'راجع فهمك بسرعة من خلال أسئلة قصيرة لكل محاضرة.',
                  textDirection: TextDirection.rtl,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 24),
                if (lecturesWithAnalysis.isEmpty)
                  const EmptyStateCard(
                    icon: Icons.quiz_outlined,
                    title: 'لا توجد اختبارات جاهزة',
                    message:
                        'افتح محاضرة واحدة على الأقل ليتم تجهيز الاختبار الخاص بها',
                  )
                else
                  ...lecturesWithAnalysis.map(
                    (lecture) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: SectionCard(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lecture.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${lecture.analysis!.quiz.length} أسئلة مراجعة',
                                    textDirection: TextDirection.rtl,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: const Color(0xFF6B7280),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => QuizPage(lecture: lecture),
                                  ),
                                );
                              },
                              child: const Text('ابدأ'),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AnalysisPage(lecture: lecture),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.open_in_new_rounded),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
