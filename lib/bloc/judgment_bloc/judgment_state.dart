import '../../models/judgment_model.dart';


abstract class JudgmentState {}

class JudgmentInitial extends JudgmentState {}

class JudgmentLoading extends JudgmentState {}

class JudgmentsLoaded extends JudgmentState {
  final List<Judgment> judgments;

  JudgmentsLoaded({required this.judgments});
}

class JudgmentViewLoaded extends JudgmentState {
  final Judgment judgment;

  JudgmentViewLoaded({required this.judgment});
}

class JudgmentError extends JudgmentState {
  final String error;

  JudgmentError({required this.error});
}