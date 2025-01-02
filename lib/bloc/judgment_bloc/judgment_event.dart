abstract class JudgmentEvent {}

class JudgmentFetchAllEvent extends JudgmentEvent {}

class JudgmentKeywordSearchEvent extends JudgmentEvent {
  final String keyword;
  final int page;
  final int limit;

  JudgmentKeywordSearchEvent({
    required this.keyword,
    this.page = 1,
    this.limit = 10,
  });
}


class TransactionsAddEvent extends JudgmentEvent {
  final String transaction;

  TransactionsAddEvent({required this.transaction});
}

class TransactionsDeleteEvent extends JudgmentEvent {
  final String transaction;

  TransactionsDeleteEvent({required this.transaction});
}

class TransactionsErrorEvent extends JudgmentEvent {
  final String error;

  TransactionsErrorEvent({required this.error});
}