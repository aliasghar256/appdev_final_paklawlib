class Judgment {
  final int judgmentID;
  final int caseYear;
  final String party1;
  final String party2;
  final int judgeID;
  final String caseNo;
  final String snippet;
  final List<int> indexes;

  Judgment({
    required this.judgmentID,
    required this.caseYear,
    required this.party1,
    required this.party2,
    required this.judgeID,
    required this.caseNo,
    required this.snippet,
    required this.indexes,
  });

  // A factory constructor to create a Judgment from JSON
  factory Judgment.fromJson(Map<String, dynamic> json) {
    return Judgment(
      judgmentID: json['JudgmentID'] ?? 0,
      caseYear: json['CaseYear'] ?? '',
      party1: json['Party1'] ?? '',
      party2: json['Party2'] ?? '',
      judgeID: json['JudgeID'] ?? '',
      caseNo: json['CaseNo'] ?? '',
      snippet: json['snippet'] ?? '',
      indexes: List<int>.from(json['indexes'] ?? []),
    );
  }
}
