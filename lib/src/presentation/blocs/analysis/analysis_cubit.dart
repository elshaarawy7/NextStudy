import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/lecture.dart';
import '../../../domain/usecases/analyze_lecture_usecase.dart';
import 'analysis_state.dart';

class AnalysisCubit extends Cubit<AnalysisState> {
  AnalysisCubit({required AnalyzeLectureUseCase analyzeLectureUseCase})
    : _analyzeLectureUseCase = analyzeLectureUseCase,
      super(const AnalysisState());

  final AnalyzeLectureUseCase _analyzeLectureUseCase;

  Future<void> loadAnalysis(Lecture lecture) async {
    emit(state.copyWith(status: AnalysisStatus.loading));
    try {
      final analysis =
          lecture.analysis ?? await _analyzeLectureUseCase(lecture);
      emit(state.copyWith(status: AnalysisStatus.loaded, analysis: analysis));
    } catch (error) {
      emit(
        state.copyWith(
          status: AnalysisStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
