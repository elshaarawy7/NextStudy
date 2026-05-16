import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../../domain/entities/lecture.dart';
import '../../blocs/analysis/analysis_cubit.dart';
import '../../blocs/analysis/analysis_state.dart';
import '../../blocs/chat/chat_cubit.dart';
import '../../blocs/chat/chat_state.dart';
import '../../widgets/section_card.dart';

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
    context.read<ChatCubit>().reset();
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: GradientScaffold(
        body: Column(
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
            const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Summary'),
                Tab(text: 'Key Points'),
                Tab(text: 'Steps'),
                Tab(text: 'Quiz'),
                Tab(text: 'Flashcards'),
                Tab(text: 'Chat'),
              ],
            ),
            Expanded(
              child: BlocBuilder<AnalysisCubit, AnalysisState>(
                builder: (context, state) {
                  if (state.status == AnalysisStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == AnalysisStatus.failure) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(state.errorMessage ?? 'Analysis failed.'),
                      ),
                    );
                  }

                  final analysis = state.analysis ?? widget.lecture.analysis;
                  if (analysis == null) {
                    return const Center(child: Text('No analysis available.'));
                  }

                  return TabBarView(
                    children: [
                      _SummaryTab(
                        lecture: widget.lecture,
                        summary: analysis.summary,
                      ),
                      _BulletsTab(
                        title: 'Key learning points',
                        items: analysis.keyPoints,
                      ),
                      _BulletsTab(
                        title: 'Step-by-step explanation',
                        items: analysis.steps,
                      ),
                      _QuizTab(lecture: widget.lecture, state: state),
                      _FlashcardsTab(lecture: widget.lecture, state: state),
                      _ChatTab(
                        lecture: widget.lecture,
                        controller: _chatController,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
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
                'Simple summary',
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

class _QuizTab extends StatelessWidget {
  const _QuizTab({required this.lecture, required this.state});

  final Lecture lecture;
  final AnalysisState state;

  @override
  Widget build(BuildContext context) {
    final quiz = state.analysis?.quiz ?? lecture.analysis?.quiz ?? [];
    return ListView(
      padding: const EdgeInsets.all(20),
      children: quiz
          .map(
            (question) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.question,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...question.options.map(
                      (option) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: option == question.correctAnswer
                                ? AppTheme.primary.withValues(alpha: 0.08)
                                : const Color(0xFFF7F8FD),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Expanded(child: Text(option)),
                              if (option == question.correctAnswer)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppTheme.primary,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _FlashcardsTab extends StatefulWidget {
  const _FlashcardsTab({required this.lecture, required this.state});

  final Lecture lecture;
  final AnalysisState state;

  @override
  State<_FlashcardsTab> createState() => _FlashcardsTabState();
}

class _FlashcardsTabState extends State<_FlashcardsTab> {
  int index = 0;
  bool showAnswer = false;

  @override
  Widget build(BuildContext context) {
    final flashcards =
        widget.state.analysis?.flashcards ??
        widget.lecture.analysis?.flashcards ??
        [];

    if (flashcards.isEmpty) {
      return const Center(child: Text('No flashcards available.'));
    }

    final card = flashcards[index];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => showAnswer = !showAnswer),
              child: SectionCard(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      showAnswer ? card.answer : card.question,
                      key: ValueKey(showAnswer),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            showAnswer
                ? 'Tap card to see question'
                : 'Tap card to reveal answer',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: index == 0
                      ? null
                      : () => setState(() {
                          index--;
                          showAnswer = false;
                        }),
                  child: const Text('Previous'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: index == flashcards.length - 1
                      ? null
                      : () => setState(() {
                          index++;
                          showAnswer = false;
                        }),
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChatTab extends StatelessWidget {
  const _ChatTab({required this.lecture, required this.controller});

  final Lecture lecture;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return ListView.separated(
                  itemCount: state.messages.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    return Align(
                      alignment: message.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 320),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: message.isUser
                              ? AppTheme.primary
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: message.isUser
                              ? null
                              : AppTheme.softShadow(),
                        ),
                        child: Text(
                          message.text,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: message.isUser
                                    ? Colors.white
                                    : AppTheme.text,
                              ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Ask a question from this lecture',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state.status == ChatStatus.sending
                        ? null
                        : () {
                            final value = controller.text.trim();
                            if (value.isEmpty) {
                              return;
                            }
                            context.read<ChatCubit>().sendMessage(
                              lecture: lecture,
                              message: value,
                            );
                            controller.clear();
                          },
                    child: Text(
                      state.status == ChatStatus.sending ? '...' : 'Send',
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
