import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/lecture.dart';
import '../../../domain/usecases/get_recent_lectures_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required GetRecentLecturesUseCase getRecentLecturesUseCase})
    : _getRecentLecturesUseCase = getRecentLecturesUseCase,
      super(const HomeState());

  final GetRecentLecturesUseCase _getRecentLecturesUseCase;

  Future<void> loadLectures() async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final lectures = await _getRecentLecturesUseCase();
      emit(state.copyWith(status: HomeStatus.loaded, lectures: lectures));
    } catch (error) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void prependLecture(Lecture lecture) {
    final updated = [lecture, ...state.lectures];
    emit(state.copyWith(status: HomeStatus.loaded, lectures: updated));
  }

  void replaceLecture(Lecture lecture) {
    final updated = state.lectures
        .map((item) => item.id == lecture.id ? lecture : item)
        .toList();
    emit(state.copyWith(status: HomeStatus.loaded, lectures: updated));
  }
}
