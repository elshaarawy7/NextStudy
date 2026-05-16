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
                  'Upload a lecture PDF',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Pick a lecture note, handout, or slide export. NexStudy will extract the text and prepare revision content.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppTheme.muted),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SectionCard(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 94,
                          width: 94,
                          decoration: BoxDecoration(
                            gradient: AppTheme.heroGradient(),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.cloud_upload_rounded,
                            color: Colors.white,
                            size: 42,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'Drop in your lecture and let AI do the heavy lifting.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'You will get a summary, key points, steps, quiz, flashcards, and a lecture chat in one flow.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppTheme.muted),
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
                                  ? 'Uploading...'
                                  : 'Choose PDF',
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
