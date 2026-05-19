import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/lecture.dart';
import '../../blocs/home/home_cubit.dart';
import '../../blocs/home/home_state.dart';
import '../../widgets/empty_state_card.dart';
import '../../widgets/lecture_pdf_card.dart';
import '../analysis/analysis_page.dart';
import '../upload/upload_page.dart';

class LecturesPage extends StatelessWidget {
  const LecturesPage({super.key});

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
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openUpload(context),
        icon: const Icon(Icons.upload_file_rounded),
        label: const Text('رفع محاضرة'),
      ),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: context.read<HomeCubit>().loadLectures,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    'المحاضرات',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'كل ملفاتك الدراسية في مكان واحد للوصول السريع والمراجعة بسهولة.',
                    textDirection: TextDirection.rtl,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (state.status == HomeStatus.loading)
                    const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.lectures.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: EmptyStateCard(
                        icon: Icons.picture_as_pdf_outlined,
                        title: 'لا توجد محاضرات',
                        message: 'لم تقم برفع أي محاضرات بعد',
                      ),
                    )
                  else
                    ...state.lectures.map(
                      (lecture) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: LecturePdfCard(
                          lecture: lecture,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AnalysisPage(lecture: lecture),
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
