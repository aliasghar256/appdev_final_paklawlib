import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finalproject/home_page.dart';
import 'package:finalproject/bloc/judgment_bloc/judgment_bloc.dart';
import 'package:finalproject/bloc/judgment_bloc/judgment_event.dart';
import 'package:finalproject/bloc/judgment_bloc/judgment_state.dart';
import 'package:finalproject/models/judgment_model.dart';
import 'package:finalproject/managers/judgment_manager.dart';

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
    await loadAppFonts(); // Ensure fonts are loaded.
  });

  testGoldens('HomePage Golden Test - Initial State', (WidgetTester tester) async {
    final mockManager = MockJudgmentManager();
    final mockBloc = MockJudgmentBloc(
      initialState: JudgmentInitial(),
      manager: mockManager,
    );

    final widget = BlocProvider<JudgmentBloc>(
      create: (_) => mockBloc,
      child: MaterialApp(
        home: HomePage(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(400, 800), // Simulate a mobile screen size
    );
    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'home_page_initial_state');
  });

  testGoldens('HomePage Golden Test - Loaded State', (WidgetTester tester) async {
    final mockManager = MockJudgmentManager();
    final mockBloc = MockJudgmentBloc(
      initialState: JudgmentsLoaded(
        judgments: [
          Judgment(
            judgmentID: 1,
            caseYear: 2023,
            party1: 'Alice',
            party2: 'Bob',
            judgeID: 101,
            caseNo: '2023-001',
            snippet: 'This is a test snippet',
            indexes: [1, 2, 3],
            JudgmentText: 'This is the full judgment text',
          ),
          Judgment(
            judgmentID: 2,
            caseYear: 2023,
            party1: 'Charlie',
            party2: 'Delta',
            judgeID: 102,
            caseNo: '2023-002',
            snippet: 'Another test snippet',
            indexes: [4, 5, 6],
            JudgmentText: 'Another full judgment text',
          ),
        ],
      ),
      manager: mockManager,
    );

    final widget = BlocProvider<JudgmentBloc>(
      create: (_) => mockBloc,
      child: MaterialApp(
        home: HomePage(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(400, 800),
    );
    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'home_page_loaded_state');
  });

  testGoldens('HomePage Golden Test - Error State', (WidgetTester tester) async {
    final mockManager = MockJudgmentManager();
    final mockBloc = MockJudgmentBloc(
      initialState: JudgmentError(error: 'Failed to load judgments'),
      manager: mockManager,
    );

    final widget = BlocProvider<JudgmentBloc>(
      create: (_) => mockBloc,
      child: MaterialApp(
        home: HomePage(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(400, 800),
    );
    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'home_page_error_state');
  });
}

class MockJudgmentBloc extends JudgmentBloc {
  MockJudgmentBloc({
    required JudgmentState initialState,
    required JudgmentManager manager,
  }) : super(manager: manager) {
    emit(initialState); // Emit the provided initial state.
  }

  @override
  Stream<JudgmentState> mapEventToState(JudgmentEvent event) async* {
    // No-op for testing.
  }
}

class MockJudgmentManager extends JudgmentManager {
  @override
  Future<List<Judgment>> fetchJudgmentsByKeyword({
    required String keyword, // Matches the base class
    int limit = 10, // Default value as per base class
    int page = 1, // Default value as per base class
  }) async {
    return [
      Judgment(
        judgmentID: 1,
        caseYear: 2023,
        party1: 'Alice',
        party2: 'Bob',
        judgeID: 101,
        caseNo: '2023-001',
        snippet: 'This is a test snippet',
        indexes: [1, 2, 3],
        JudgmentText: 'This is the full judgment text',
      ),
    ];
  }
}

