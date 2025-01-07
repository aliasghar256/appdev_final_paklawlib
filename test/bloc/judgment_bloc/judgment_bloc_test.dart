import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finalproject/bloc/judgment_bloc/judgment_bloc.dart';
import 'package:finalproject/bloc/judgment_bloc/judgment_event.dart';
import 'package:finalproject/bloc/judgment_bloc/judgment_state.dart';
import 'package:finalproject/managers/judgment_manager.dart';
import 'package:finalproject/models/judgment_model.dart';

class MockJudgmentManager extends Mock implements JudgmentManager {}

void main() {
  late MockJudgmentManager mockJudgmentManager;
  late JudgmentBloc judgmentBloc;

  setUp(() {
    mockJudgmentManager = MockJudgmentManager();
    judgmentBloc = JudgmentBloc(manager: mockJudgmentManager);
  });

  tearDown(() {
    judgmentBloc.close();
  });

  group('JudgmentBloc Tests', () {
    blocTest<JudgmentBloc, JudgmentState>(
      'emits [JudgmentLoading, JudgmentsLoaded] when JudgmentKeywordSearchEvent is successful',
      build: () {
        when(() => mockJudgmentManager.fetchJudgmentsByKeyword(
              keyword: any(named: 'keyword'),
              page: any(named: 'page'),
              limit: any(named: 'limit'),
            )).thenAnswer((_) async => [
              Judgment(
                judgmentID: 1,
                caseYear: 2023,
                party1: 'Party A',
                party2: 'Party B',
                judgeID: 101,
                caseNo: '12345',
                snippet: 'Case summary snippet.',
                indexes: [1, 2, 3],
                JudgmentText: 'Full judgment text.',
              ),
            ]);
        return judgmentBloc;
      },
      act: (bloc) => bloc.add(JudgmentKeywordSearchEvent(
        keyword: 'test',
        page: 1,
        limit: 10,
      )),
      expect: () => [
        JudgmentLoading(),
        JudgmentsLoaded(judgments: [
          Judgment(
            judgmentID: 1,
            caseYear: 2023,
            party1: 'Party A',
            party2: 'Party B',
            judgeID: 101,
            caseNo: '12345',
            snippet: 'Case summary snippet.',
            indexes: [1, 2, 3],
            JudgmentText: 'Full judgment text.',
          ),
        ]),
      ],
    );

    blocTest<JudgmentBloc, JudgmentState>(
      'emits [JudgmentLoading, JudgmentViewLoaded] when JudgmentViewEvent is successful',
      build: () {
        when(() => mockJudgmentManager.fetchJudgmentById(any()))
            .thenAnswer((_) async => Judgment(
                  judgmentID: 1,
                  caseYear: 2023,
                  party1: 'Party A',
                  party2: 'Party B',
                  judgeID: 101,
                  caseNo: '12345',
                  snippet: 'Case summary snippet.',
                  indexes: [1, 2, 3],
                  JudgmentText: 'Full judgment text.',
                ));
        return judgmentBloc;
      },
      act: (bloc) => bloc.add(JudgmentViewEvent(id: '1')), // Changed to String
      expect: () => [
        JudgmentLoading(),
        JudgmentViewLoaded(
          judgment: Judgment(
            judgmentID: 1,
            caseYear: 2023,
            party1: 'Party A',
            party2: 'Party B',
            judgeID: 101,
            caseNo: '12345',
            snippet: 'Case summary snippet.',
            indexes: [1, 2, 3],
            JudgmentText: 'Full judgment text.',
          ),
        ),
      ],
    );

    blocTest<JudgmentBloc, JudgmentState>(
      'does not emit a state when JudgmentAddFavoriteEvent is successful',
      build: () {
        when(() => mockJudgmentManager.addFavorite(judgmentId: any(named: 'judgmentId')))
            .thenAnswer((_) async => {'success': true});
        return judgmentBloc;
      },
      act: (bloc) => bloc.add(JudgmentAddFavoriteEvent(JudgmentID: '1')), // Changed to String
      expect: () => [],
    );

    blocTest<JudgmentBloc, JudgmentState>(
      'emits [JudgmentFavoritesLoading, JudgmentFavoritesLoaded] when JudgmentFetchAllFavoritesEvent is successful',
      build: () {
        when(() => mockJudgmentManager.viewFavorites())
            .thenAnswer((_) async => [
              Judgment(
                judgmentID: 1,
                caseYear: 2023,
                party1: 'Party A',
                party2: 'Party B',
                judgeID: 101,
                caseNo: '12345',
                snippet: 'Case summary snippet.',
                indexes: [1, 2, 3],
                JudgmentText: 'Full judgment text.',
              ),
            ]);
        return judgmentBloc;
      },
      act: (bloc) => bloc.add(JudgmentFetchAllFavoritesEvent()),
      expect: () => [
        JudgmentFavoritesLoading(),
        JudgmentFavoritesLoaded(
          judgments: [
            Judgment(
              judgmentID: 1,
              caseYear: 2023,
              party1: 'Party A',
              party2: 'Party B',
              judgeID: 101,
              caseNo: '12345',
              snippet: 'Case summary snippet.',
              indexes: [1, 2, 3],
              JudgmentText: 'Full judgment text.',
            ),
          ],
        ),
      ],
    );
  });
}
