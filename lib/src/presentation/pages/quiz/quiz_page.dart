import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/lecture.dart';
import '../../widgets/empty_state_card.dart';
import '../../widgets/section_card.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.lecture});

  final Lecture lecture;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentIndex = 0;
  String? _selectedAnswer;
  bool _showResult = false;

  @override
  Widget build(BuildContext context) {
    final quiz = widget.lecture.analysis?.quiz ?? [];

    if (quiz.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('الاختبار')),
        body: const Padding(
          padding: EdgeInsets.all(24),
          child: EmptyStateCard(
            icon: Icons.quiz_outlined,
            title: 'لا يوجد اختبار',
            message: 'افتح هذه المحاضرة من شاشة التحليل ليتم تجهيز الأسئلة',
          ),
        ),
      );
    }

    final question = quiz[_currentIndex];
    final progress = (_currentIndex + 1) / quiz.length;

    return Scaffold(
      appBar: AppBar(title: const Text('اختبار سريع')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.lecture.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(999),
              backgroundColor: AppTheme.accent,
            ),
            const SizedBox(height: 8),
            Text(
              'السؤال ${_currentIndex + 1} من ${quiz.length}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.muted),
            ),
            const SizedBox(height: 20),
            SectionCard(
              child: Text(
                question.question,
                textDirection: TextDirection.rtl,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 16),
            ...question.options.map(
              (option) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedAnswer = option;
                      _showResult = true;
                    });
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Ink(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _backgroundFor(option, question.correctAnswer),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: _borderFor(option, question.correctAnswer),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option,
                            textDirection: TextDirection.rtl,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        if (_showResult && option == question.correctAnswer)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppTheme.primary,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedAnswer == null
                    ? null
                    : () {
                        if (_currentIndex == quiz.length - 1) {
                          Navigator.of(context).pop();
                          return;
                        }
                        setState(() {
                          _currentIndex++;
                          _selectedAnswer = null;
                          _showResult = false;
                        });
                      },
                child: Text(
                  _currentIndex == quiz.length - 1 ? 'إنهاء' : 'التالي',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _backgroundFor(String option, String correctAnswer) {
    if (!_showResult) {
      return _selectedAnswer == option ? AppTheme.secondary : Colors.white;
    }
    if (option == correctAnswer) {
      return AppTheme.secondary;
    }
    if (option == _selectedAnswer) {
      return const Color(0xFFFDECEC);
    }
    return Colors.white;
  }

  Color _borderFor(String option, String correctAnswer) {
    if (!_showResult) {
      return _selectedAnswer == option ? AppTheme.primary : AppTheme.border;
    }
    if (option == correctAnswer) {
      return AppTheme.primary;
    }
    if (option == _selectedAnswer) {
      return const Color(0xFFF29B9B);
    }
    return AppTheme.border;
  }
}
