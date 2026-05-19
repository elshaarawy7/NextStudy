import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/lecture.dart';
import '../../widgets/empty_state_card.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({super.key, required this.lecture});

  final Lecture lecture;

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  int _currentIndex = 0;
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    final flashcards = widget.lecture.analysis?.flashcards ?? [];

    if (flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('البطاقات')),
        body: const Padding(
          padding: EdgeInsets.all(24),
          child: EmptyStateCard(
            icon: Icons.style_outlined,
            title: 'لا توجد بطاقات',
            message: 'ستظهر البطاقات بعد تجهيز المحاضرة وتحليلها',
          ),
        ),
      );
    }

    final card = flashcards[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('البطاقات الدراسية')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'البطاقة ${_currentIndex + 1} من ${flashcards.length}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.muted),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showAnswer = !_showAnswer),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: _showAnswer ? 1 : 0),
                  duration: const Duration(milliseconds: 350),
                  builder: (context, value, child) {
                    final angle = value * pi;
                    final isBack = value > 0.5;
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppTheme.border),
                          boxShadow: AppTheme.softShadow(),
                        ),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..rotateY(isBack ? pi : 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isBack ? 'الإجابة' : 'السؤال',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: AppTheme.muted,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                isBack ? card.answer : card.question,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _showAnswer
                  ? 'اضغط على البطاقة للعودة إلى السؤال'
                  : 'اضغط على البطاقة لإظهار الإجابة',
              textDirection: TextDirection.rtl,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.muted),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _currentIndex == 0
                        ? null
                        : () {
                            setState(() {
                              _currentIndex--;
                              _showAnswer = false;
                            });
                          },
                    child: const Text('السابق'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _currentIndex == flashcards.length - 1
                        ? null
                        : () {
                            setState(() {
                              _currentIndex++;
                              _showAnswer = false;
                            });
                          },
                    child: const Text('التالي'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
