import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finalproject/view_judgment_page.dart'; // Adjust this path as necessary
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

  testGoldens('ViewJudgmentPage Golden Test - Loaded State', (WidgetTester tester) async {
    final mockManager = MockJudgmentManager();
    final mockBloc = MockJudgmentBloc(
      initialState: JudgmentViewLoaded(
        judgment: Judgment(
          judgmentID: 123,
          caseYear: 2023,
          party1: 'Alice',
          party2: 'Bob',
          judgeID: 1,
          caseNo: '2023-001',
          snippet: 'This is a snippet of the judgment.',
          indexes: [101, 102, 103],
          JudgmentText: 'This is the full judgment text for testing purposes.',
        ),
      ),
      manager: mockManager,
    );

    final widget = BlocProvider<JudgmentBloc>(
      create: (_) => mockBloc,
      child: const MaterialApp(
        home: ViewJudgmentPage(judgmentId: '123'),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(400, 800),
    );
    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'view_judgment_page_loaded_state');
  });

  testGoldens('ViewJudgmentPage Golden Test - Loading State', (WidgetTester tester) async {
    final mockManager = MockJudgmentManager();
    final mockBloc = MockJudgmentBloc(
      initialState: JudgmentLoading(),
      manager: mockManager,
    );

    final widget = BlocProvider<JudgmentBloc>(
      create: (_) => mockBloc,
      child: const MaterialApp(
        home: ViewJudgmentPage(judgmentId: '123'),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(400, 800),
    );
    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'view_judgment_page_loading_state');
  });

  testGoldens('ViewJudgmentPage Golden Test - Error State', (WidgetTester tester) async {
    final mockManager = MockJudgmentManager();
    final mockBloc = MockJudgmentBloc(
      initialState: JudgmentError(error: 'Unable to load judgment'),
      manager: mockManager,
    );

    final widget = BlocProvider<JudgmentBloc>(
      create: (_) => mockBloc,
      child: const MaterialApp(
        home: ViewJudgmentPage(judgmentId: '123'),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(400, 800),
    );
    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'view_judgment_page_error_state');
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
  Future<Judgment> fetchJudgmentById(String id) async {
    return Judgment(
      judgmentID: 123,
      caseYear: 2023,
      party1: 'Alice',
      party2: 'Bob',
      judgeID: 1,
      caseNo: '2023-001',
      snippet: 'This is a snippet of the judgment.',
      indexes: [101, 102, 103],
      JudgmentText: 'This is the full judgment text for testing purposes.',
    );
  }
}
