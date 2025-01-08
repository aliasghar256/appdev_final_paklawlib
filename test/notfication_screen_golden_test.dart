import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/mockito.dart';
import '../lib/bloc/notifications_bloc/notifications_bloc.dart';
import '../lib/bloc/notifications_bloc/notifications_event.dart';
import '../lib/bloc/notifications_bloc/notifications_state.dart';
import '../lib/models/notifications_model.dart';
import '../lib/managers/notifications_manager.dart';
import '../lib/notifications_screen.dart';

// Mock NotificationsManager
class MockNotificationsManager extends Mock implements NotificationsManager {}

void main() {
  late MockNotificationsManager mockManager;

  setUp(() {
    mockManager = MockNotificationsManager();
  });

  group('NotificationsScreen Golden Tests', () {
    testGoldens('Loading State', (WidgetTester tester) async {
      await loadAppFonts();

      final widget = BlocProvider<NotificationsBloc>(
        create: (_) => NotificationsBloc(manager: mockManager)
          ..emit(NotificationsLoading()), // Directly emit loading state
        child: const MaterialApp(
          home: NotificationsScreen(),
        ),
      );

      await tester.pumpWidgetBuilder(widget);
      await screenMatchesGolden(tester, 'notifications_loading');
    });

    testGoldens('Loaded State with Notifications', (WidgetTester tester) async {
      await loadAppFonts();

      final notifications = [
        NotificationsModel(
          id: '1',
          title: 'Test Notification 1',
          description: 'This is the first test notification.',
          date: DateTime.now(),
        ),
        NotificationsModel(
          id: '2',
          title: 'Test Notification 2',
          description: 'This is the second test notification.',
          date: DateTime.now().subtract(Duration(days: 1)),
        ),
      ];

      // Stub the method to return mock notifications
      when(mockManager.fetchAllNotifications())
          .thenAnswer((_) async => notifications);

      final widget = BlocProvider<NotificationsBloc>(
        create: (_) => NotificationsBloc(manager: mockManager)
          ..add(NotificationsFetchAllEvent()), // Trigger fetching event
        child: const MaterialApp(
          home: NotificationsScreen(),
        ),
      );

      await tester.pumpWidgetBuilder(widget);
      await screenMatchesGolden(tester, 'notifications_loaded');
    });

    testGoldens('Empty State', (WidgetTester tester) async {
      await loadAppFonts();

      // Stub the method to return an empty list
      when(mockManager.fetchAllNotifications()).thenAnswer((_) async => []);

      final widget = BlocProvider<NotificationsBloc>(
        create: (_) => NotificationsBloc(manager: mockManager)
          ..add(NotificationsFetchAllEvent()), // Trigger fetching event
        child: const MaterialApp(
          home: NotificationsScreen(),
        ),
      );

      await tester.pumpWidgetBuilder(widget);
      await screenMatchesGolden(tester, 'notifications_empty');
    });

    testGoldens('Error State', (WidgetTester tester) async {
      await loadAppFonts();

      // Stub the method to throw an exception
      when(mockManager.fetchAllNotifications())
          .thenThrow(Exception('Failed to fetch notifications'));

      final widget = BlocProvider<NotificationsBloc>(
        create: (_) => NotificationsBloc(manager: mockManager)
          ..add(NotificationsFetchAllEvent()), // Trigger fetching event
        child: const MaterialApp(
          home: NotificationsScreen(),
        ),
      );

      await tester.pumpWidgetBuilder(widget);
      await screenMatchesGolden(tester, 'notifications_error');
    });
  });
}
