import 'package:equatable/equatable.dart';
import '../../models/judgment_model.dart';

abstract class JudgmentState extends Equatable {
  const JudgmentState();

  @override
  List<Object?> get props => [];
}

class JudgmentInitial extends JudgmentState {}

class JudgmentLoading extends JudgmentState {}

class JudgmentsLoaded extends JudgmentState {
  final List<Judgment> judgments;

  const JudgmentsLoaded({required this.judgments});

  @override
  List<Object?> get props => [judgments];
}

class JudgmentViewLoaded extends JudgmentState {
  final Judgment judgment;

  const JudgmentViewLoaded({required this.judgment});

  @override
  List<Object?> get props => [judgment];
}

class JudgmentError extends JudgmentState {
  final String error;

  const JudgmentError({required this.error});

  @override
  List<Object?> get props => [error];
}

class JudgmentFavoritesLoading extends JudgmentState {}

class JudgmentFavoritesLoaded extends JudgmentState {
  final List<Judgment> judgments;

  const JudgmentFavoritesLoaded({required this.judgments});

  @override
  List<Object?> get props => [judgments];
}

class JudgmentFavoritesError extends JudgmentState {
  final String error;

  const JudgmentFavoritesError({required this.error});

  @override
  List<Object?> get props => [error];
}
