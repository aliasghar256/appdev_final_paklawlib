import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../lib/notifications_screen.dart'; // Adjust this path as necessary
import '../lib/bloc/notifications_bloc/notifications_bloc.dart';
import '../lib/bloc/notifications_bloc/notifications_event.dart';
import '../lib/bloc/notifications_bloc/notifications_state.dart';
import '../lib/models/notifications_model.dart';
import '../lib/managers/notifications_manager.dart';

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

  testGoldens('NotificationsScreen Golden Test - Initial State', (WidgetTester tester) async {
    final mockManager = MockNotificationsManager();
    final mockBloc = MockNotificationsBloc(
      initialState: NotificationsInitial(),
      manager: mockManager,
    );

    final widget = BlocProvider<NotificationsBloc>(
      create: (_) => mockBloc,
      child: const MaterialApp(
        home: NotificationsScreen(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(400, 800),
    );
    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'notifications_screen_initial_state');
  });

  testGoldens('NotificationsScreen Golden Test - Loading State', (WidgetTester tester) async {
    final mockManager = MockNotificationsManager();
    final mockBloc = MockNotificationsBloc(
      initialState: NotificationsLoading(),
      manager: mockManager,
    );

    final widget = BlocProvider<NotificationsBloc>(
      create: (_) => mockBloc,
      child: const MaterialApp(
        home: NotificationsScreen(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(400, 800),
    );
    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'notifications_screen_loading_state');
  });

  testGoldens('NotificationsScreen Golden Test - Loaded State', (WidgetTester tester) async {
    final notifications = [
      NotificationsModel(
        id: '1',
        title: 'Welcome Notification',
        description: 'This is a welcome notification.',
        date: DateTime.now(),
      ),
      NotificationsModel(
        id: '2',
        title: 'System Update',
        description: 'Your system will be updated tonight.',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    final mockManager = MockNotificationsManager();
    final mockBloc = MockNotificationsBloc(
      initialState: NotificationsLoaded(notifications: notifications),
      manager: mockManager,
    );

    final widget = BlocProvider<NotificationsBloc>(
      create: (_) => mockBloc,
      child: const MaterialApp(
        home: NotificationsScreen(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(400, 800), // Set the size to simulate a mobile screen.
    );
    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'notifications_screen_loaded_state');
  });

  testGoldens('NotificationsScreen Golden Test - Empty State', (WidgetTester tester) async {
    final mockManager = MockNotificationsManager();
    final mockBloc = MockNotificationsBloc(
      initialState: NotificationsLoaded(notifications: []),
      manager: mockManager,
    );

    final widget = BlocProvider<NotificationsBloc>(
      create: (_) => mockBloc,
      child: const MaterialApp(
        home: NotificationsScreen(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(400, 800),
    );
    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'notifications_screen_empty_state');
  });

  testGoldens('NotificationsScreen Golden Test - Error State', (WidgetTester tester) async {
    final mockManager = MockNotificationsManager();
    final mockBloc = MockNotificationsBloc(
      initialState: NotificationsError(error: 'Unable to load notifications'),
      manager: mockManager,
    );

    final widget = BlocProvider<NotificationsBloc>(
      create: (_) => mockBloc,
      child: const MaterialApp(
        home: NotificationsScreen(),
      ),
    );

    await tester.pumpWidgetBuilder(
      widget,
      surfaceSize: const Size(400, 800),
    );
    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'notifications_screen_error_state');
  });
}

class MockNotificationsBloc extends NotificationsBloc {
  MockNotificationsBloc({
    required NotificationsState initialState,
    required NotificationsManager manager,
  }) : super(manager: manager) {
    emit(initialState); // Emit the provided initial state.
  }

  @override
  Stream<NotificationsState> mapEventToState(NotificationsEvent event) async* {
    // No-op for testing.
  }
}

class MockNotificationsManager extends NotificationsManager {
  @override
  Future<List<NotificationsModel>> fetchAllNotifications() async {
    return [
      NotificationsModel(
        id: '1',
        title: 'Welcome Notification',
        description: 'This is a welcome notification.',
        date: DateTime.now(),
      ),
      NotificationsModel(
        id: '2',
        title: 'System Update',
        description: 'Your system will be updated tonight.',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}
