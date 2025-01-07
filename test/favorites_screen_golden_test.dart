import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../lib/favorites_screen.dart'; // Adjust this path as necessary
import '../lib/bloc/judgment_bloc/judgment_bloc.dart';
import '../lib/bloc/judgment_bloc/judgment_event.dart';
import '../lib/bloc/judgment_bloc/judgment_state.dart';
import '../lib/models/judgment_model.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return GoldenToolkit.runWithConfiguration(
    () async {
      await loadAppFonts();
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      skipGoldenAssertion: () => !Platform.isMacOS,
    ),
  );
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('FavoritesScreen Golden Test - Loaded State', (WidgetTester tester) async {
    final favorites = [
      Judgment(
        judgmentID: 1,
        caseYear: 2025,
        party1: 'Party A',
        party2: 'Party B',
        judgeID: 101,
        caseNo: '12345',
        snippet: 'This is a snippet for Judgment 1.',
        indexes: [1, 2, 3],
        JudgmentText: 'Full text of Judgment 1',
      ),
      Judgment(
        judgmentID: 2,
        caseYear: 2024,
        party1: 'Party C',
        party2: 'Party D',
        judgeID: 102,
        caseNo: '54321',
        snippet: 'This is a snippet for Judgment 2.',
        indexes: [4, 5, 6],
        JudgmentText: 'Full text of Judgment 2',
      ),
    ];

    final mockBloc = MockJudgmentBloc(
      initialState: JudgmentFavoritesLoaded(judgments: favorites),
    );

    final widget = BlocProvider<JudgmentBloc>(
      create: (_) => mockBloc,
      child: const MaterialApp(
        home: FavoritesScreen(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(400, 800),
    );
    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'favorites_screen_loaded_state');
  });

  testGoldens('FavoritesScreen Golden Test - Empty State', (WidgetTester tester) async {
    final mockBloc = MockJudgmentBloc(
      initialState: JudgmentFavoritesLoaded(judgments: []),
    );

    final widget = BlocProvider<JudgmentBloc>(
      create: (_) => mockBloc,
      child: const MaterialApp(
        home: FavoritesScreen(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(400, 800),
    );
    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'favorites_screen_empty_state');
  });

  testGoldens('FavoritesScreen Golden Test - Loading State', (WidgetTester tester) async {
    final mockBloc = MockJudgmentBloc(
      initialState: JudgmentFavoritesLoading(),
    );

    final widget = BlocProvider<JudgmentBloc>(
      create: (_) => mockBloc,
      child: const MaterialApp(
        home: FavoritesScreen(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(400, 800),
    );
    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'favorites_screen_loading_state');
  });

  testGoldens('FavoritesScreen Golden Test - Error State', (WidgetTester tester) async {
    final mockBloc = MockJudgmentBloc(
      initialState: JudgmentFavoritesError(error: 'Unable to load favorites.'),
    );

    final widget = BlocProvider<JudgmentBloc>(
      create: (_) => mockBloc,
      child: const MaterialApp(
        home: FavoritesScreen(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(400, 800),
    );
    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'favorites_screen_error_state');
  });
}

class MockJudgmentBloc extends JudgmentBloc {
  MockJudgmentBloc({required JudgmentState initialState})
      : super(manager: MockJudgmentManager()) {
    emit(initialState); // Emit the provided initial state for testing.
  }

  @override
  Stream<JudgmentState> mapEventToState(JudgmentEvent event) async* {
    // No-op for testing.
  }
}

class MockJudgmentManager extends JudgmentManager {
  @override
  Future<List<Judgment>> viewFavorites() async {
    return [
      Judgment(
        judgmentID: 1,
        caseYear: 2025,
        party1: 'Party A',
        party2: 'Party B',
        judgeID: 101,
        caseNo: '12345',
        snippet: 'This is a snippet for Judgment 1.',
        indexes: [1, 2, 3],
        JudgmentText: 'Full text of Judgment 1',
      ),
    ];
  }
}
