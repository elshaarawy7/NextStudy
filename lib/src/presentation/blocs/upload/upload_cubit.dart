import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/upload_lecture_usecase.dart';
import 'upload_state.dart';

class UploadCubit extends Cubit<UploadState> {
  UploadCubit({required UploadLectureUseCase uploadLectureUseCase})
    : _uploadLectureUseCase = uploadLectureUseCase,
      super(const UploadState());

  final UploadLectureUseCase _uploadLectureUseCase;

  Future<void> uploadLecture() async {
    emit(state.copyWith(status: UploadStatus.loading, errorMessage: null));
    try {
      final lecture = await _uploadLectureUseCase();
      emit(state.copyWith(status: UploadStatus.success, lecture: lecture));
    } catch (error) {
      emit(
        state.copyWith(
          status: UploadStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void reset() => emit(const UploadState());
}
