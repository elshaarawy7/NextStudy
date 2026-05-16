import 'package:equatable/equatable.dart';

import '../../../domain/entities/lecture.dart';

enum UploadStatus { initial, loading, success, failure }

class UploadState extends Equatable {
  const UploadState({
    this.status = UploadStatus.initial,
    this.lecture,
    this.errorMessage,
  });

  final UploadStatus status;
  final Lecture? lecture;
  final String? errorMessage;

  UploadState copyWith({
    UploadStatus? status,
    Lecture? lecture,
    String? errorMessage,
  }) {
    return UploadState(
      status: status ?? this.status,
      lecture: lecture ?? this.lecture,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, lecture, errorMessage];
}
