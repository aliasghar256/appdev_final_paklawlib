import 'package:equatable/equatable.dart';

class Judgment extends Equatable {
  final int judgmentID;
  final int caseYear;
  final String party1;
  final String party2;
  final int judgeID;
  final String caseNo;
  final String snippet;
  final List<int> indexes;
  final String JudgmentText;

  const Judgment({
    required this.judgmentID,
    required this.caseYear,
    required this.party1,
    required this.party2,
    required this.judgeID,
    required this.caseNo,
    required this.snippet,
    required this.indexes,
    required this.JudgmentText,
  });

  // A factory constructor to create a Judgment from JSON
  factory Judgment.fromJson(Map<String, dynamic> json) {
    return Judgment(
      judgmentID: json['JudgmentID'] ?? 0,
      caseYear: json['CaseYear'] ?? 0,
      party1: json['Party1'] ?? '',
      party2: json['Party2'] ?? '',
      judgeID: json['JudgeID'] ?? 0,
      caseNo: json['CaseNo'] ?? '',
      snippet: json['snippet'] ?? '',
      indexes: List<int>.from(json['indexes'] ?? []),
      JudgmentText: json['JudgmentText'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        judgmentID,
        caseYear,
        party1,
        party2,
        judgeID,
        caseNo,
        snippet,
        indexes,
        JudgmentText,
      ];
}
