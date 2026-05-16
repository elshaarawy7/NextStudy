import 'package:equatable/equatable.dart';

import '../../../domain/entities/analysis_bundle.dart';

enum AnalysisStatus { initial, loading, loaded, failure }

class AnalysisState extends Equatable {
  const AnalysisState({
    this.status = AnalysisStatus.initial,
    this.analysis,
    this.errorMessage,
  });

  final AnalysisStatus status;
  final AnalysisBundle? analysis;
  final String? errorMessage;

  AnalysisState copyWith({
    AnalysisStatus? status,
    AnalysisBundle? analysis,
    String? errorMessage,
  }) {
    return AnalysisState(
      status: status ?? this.status,
      analysis: analysis ?? this.analysis,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, analysis, errorMessage];
}
