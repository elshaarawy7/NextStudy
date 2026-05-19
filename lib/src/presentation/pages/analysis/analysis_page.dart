import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../../domain/entities/lecture.dart';
import '../../blocs/analysis/analysis_cubit.dart';
import '../../blocs/analysis/analysis_state.dart';
import '../../blocs/home/home_cubit.dart';
import '../../widgets/section_card.dart';
import '../chat/chat_page.dart';
import '../flashcards/flashcards_page.dart';
import '../quiz/quiz_page.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key, required this.lecture});

  final Lecture lecture;

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  final _chatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AnalysisCubit>().loadAnalysis(widget.lecture);
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: GradientScaffold(
        body: BlocConsumer<AnalysisCubit, AnalysisState>(
          listener: (context, state) {
            final analysis = state.analysis;
            if (state.status == AnalysisStatus.loaded && analysis != null) {
              context.read<HomeCubit>().replaceLecture(
                widget.lecture.copyWith(analysis: analysis),
              );
            }
          },
          builder: (context, state) {
            if (state.status == AnalysisStatus.loading) {
              return const _AnalysisLoadingView();
            }

            if (state.status == AnalysisStatus.failure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    state.errorMessage ?? 'تعذر تحليل المحاضرة.',
                    textDirection: TextDirection.rtl,
                  ),
                ),
              );
            }

            final analysis = state.analysis ?? widget.lecture.analysis;
            if (analysis == null) {
              return const Center(
                child: Text('لا يوجد محتوى متاح لهذه المحاضرة.'),
              );
            }

            final lectureWithAnalysis = widget.lecture.copyWith(
              analysis: analysis,
            );

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.lecture.title,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              widget.lecture.fileName,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppTheme.muted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _StudyActionsRow(
                    onQuizTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              QuizPage(lecture: lectureWithAnalysis),
                        ),
                      );
                    },
                    onFlashcardsTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              FlashcardsPage(lecture: lectureWithAnalysis),
                        ),
                      );
                    },
                    onChatTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ChatPage(lecture: lectureWithAnalysis),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                const TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(text: 'الملخص'),
                    Tab(text: 'النقاط'),
                    Tab(text: 'الشرح'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _SummaryTab(
                        lecture: lectureWithAnalysis,
                        summary: analysis.summary,
                      ),
                      _BulletsTab(
                        title: 'النقاط الأساسية',
                        items: analysis.keyPoints,
                      ),
                      _BulletsTab(
                        title: 'شرح مبسط خطوة بخطوة',
                        items: analysis.steps,
                      ),
                    ],
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

class _SummaryTab extends StatelessWidget {
  const _SummaryTab({required this.lecture, required this.summary});

  final Lecture lecture;
  final String summary;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (lecture.filePath != null)
          SizedBox(
            height: 260,
            child: SectionCard(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SfPdfViewer.file(
                  File(lecture.filePath!),
                  canShowScrollHead: false,
                  canShowScrollStatus: false,
                ),
              ),
            ),
          ),
        if (lecture.filePath != null) const SizedBox(height: 16),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ملخص مبسط',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Text(summary),
            ],
          ),
        ),
      ],
    );
  }
}

class _BulletsTab extends StatelessWidget {
  const _BulletsTab({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        height: 8,
                        width: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(item)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StudyActionsRow extends StatelessWidget {
  const _StudyActionsRow({
    required this.onQuizTap,
    required this.onFlashcardsTap,
    required this.onChatTap,
  });

  final VoidCallback onQuizTap;
  final VoidCallback onFlashcardsTap;
  final VoidCallback onChatTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.quiz_outlined,
            label: 'الاختبار',
            onTap: onQuizTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            icon: Icons.style_outlined,
            label: 'البطاقات',
            onTap: onFlashcardsTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'الدردشة',
            onTap: onChatTap,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primary),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _AnalysisLoadingView extends StatelessWidget {
  const _AnalysisLoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 84,
              width: 84,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.border),
                boxShadow: AppTheme.softShadow(),
              ),
              child: const Padding(
                padding: EdgeInsets.all(22),
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'جاري تحليل المحاضرة...',
              textDirection: TextDirection.rtl,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'نجهز لك الملخص والأسئلة والبطاقات الدراسية.',
              textDirection: TextDirection.rtl,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.muted),
            ),
          ],
        ),
      ),
    );
  }
}
