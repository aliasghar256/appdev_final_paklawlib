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

class JudgmentViewEvent extends JudgmentEvent {
  final String id;

  JudgmentViewEvent({required this.id});
}

class JudgmentAddFavoriteEvent extends JudgmentEvent {
  final String JudgmentID;

  JudgmentAddFavoriteEvent({required this.JudgmentID});
}