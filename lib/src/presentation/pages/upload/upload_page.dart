import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../blocs/upload/upload_cubit.dart';
import '../../blocs/upload/upload_state.dart';
import '../../widgets/section_card.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UploadCubit, UploadState>(
      listener: (context, state) {
        if (state.status == UploadStatus.success && state.lecture != null) {
          Navigator.of(context).pop(state.lecture);
        }
        if (state.status == UploadStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        final textTheme = Theme.of(context).textTheme;

        return GradientScaffold(
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(height: 12),
                Text(
                  'رفع محاضرة',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'اختر ملف PDF للمحاضرة ليتم تجهيز ملخص ومحتوى مراجعة بشكل منظم وواضح.',
                  textDirection: TextDirection.rtl,
                  style: textTheme.bodyLarge?.copyWith(color: AppTheme.muted),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SectionCard(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 72,
                          width: 72,
                          decoration: BoxDecoration(
                            color: AppTheme.secondary,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: const Icon(
                            Icons.cloud_upload_rounded,
                            color: AppTheme.primary,
                            size: 34,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'ارفع الملف وابدأ المذاكرة',
                          textDirection: TextDirection.rtl,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'سيتم إعداد ملخص ونقاط أساسية وأسئلة مراجعة بطريقة عملية مناسبة للطلاب.',
                          textDirection: TextDirection.rtl,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppTheme.muted,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.picture_as_pdf_rounded,
                                color: AppTheme.primary,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'PDF فقط - مناسب للمحاضرات والملخصات والسلايدات',
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: state.status == UploadStatus.loading
                                ? null
                                : () => context
                                      .read<UploadCubit>()
                                      .uploadLecture(),
                            icon: const Icon(Icons.attach_file_rounded),
                            label: Text(
                              state.status == UploadStatus.loading
                                  ? 'جاري الرفع...'
                                  : 'اختيار ملف PDF',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
