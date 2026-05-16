import 'package:equatable/equatable.dart';

import '../../../domain/entities/lecture.dart';

enum HomeStatus { initial, loading, loaded, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.lectures = const [],
    this.errorMessage,
  });

  final HomeStatus status;
  final List<Lecture> lectures;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    List<Lecture>? lectures,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      lectures: lectures ?? this.lectures,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, lectures, errorMessage];
}
