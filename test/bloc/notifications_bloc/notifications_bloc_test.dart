import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finalproject/bloc/notifications_bloc/notifications_bloc.dart';
import 'package:finalproject/bloc/notifications_bloc/notifications_event.dart';
import 'package:finalproject/bloc/notifications_bloc/notifications_state.dart';
import 'package:finalproject/managers/notifications_manager.dart';
import 'package:finalproject/models/notifications_model.dart';

class MockNotificationsManager extends Mock implements NotificationsManager {}

void main() {
  late MockNotificationsManager mockNotificationsManager;
  late NotificationsBloc notificationsBloc;

  setUp(() {
    mockNotificationsManager = MockNotificationsManager();
    notificationsBloc = NotificationsBloc(manager: mockNotificationsManager);
  });

  tearDown(() {
    notificationsBloc.close();
  });

  group('NotificationsBloc Tests', () {
    blocTest<NotificationsBloc, NotificationsState>(
      'emits [NotificationsLoading, NotificationsLoaded] when NotificationsFetchAllEvent is successful',
      build: () {
        when(() => mockNotificationsManager.fetchAllNotifications()).thenAnswer((_) async => [
              NotificationsModel(
                id: '1',
                title: 'Test Notification',
                description: 'This is a test notification.',
                date: DateTime.parse('2025-01-01T00:00:00Z'),
              ),
            ]);
        return notificationsBloc;
      },
      act: (bloc) => bloc.add(NotificationsFetchAllEvent()),
      expect: () => [
        NotificationsLoading(),
        NotificationsLoaded(notifications: [
          NotificationsModel(
            id: '1',
            title: 'Test Notification',
            description: 'This is a test notification.',
            date: DateTime.parse('2025-01-01T00:00:00Z'),
          ),
        ]),
      ],
    );

    blocTest<NotificationsBloc, NotificationsState>(
      'emits [NotificationsLoading, NotificationsError] when NotificationsFetchAllEvent fails',
      build: () {
        when(() => mockNotificationsManager.fetchAllNotifications())
            .thenThrow(Exception('Failed to fetch notifications'));
        return notificationsBloc;
      },
      act: (bloc) => bloc.add(NotificationsFetchAllEvent()),
      expect: () => [
        NotificationsLoading(),
        NotificationsError(error: 'Exception: Failed to fetch notifications'),
      ],
    );

    blocTest<NotificationsBloc, NotificationsState>(
      'emits [NotificationsLoading, NotificationsLoaded] with correctly formatted dates',
      build: () {
        when(() => mockNotificationsManager.fetchAllNotifications()).thenAnswer((_) async => [
              NotificationsModel(
                id: '1',
                title: 'Test Notification',
                description: 'This is a test notification.',
                date: DateTime.parse('2025-01-01T00:00:00Z'),
              ),
            ]);
        return notificationsBloc;
      },
      act: (bloc) => bloc.add(NotificationsFetchAllEvent()),
      verify: (_) {
        final emittedState = notificationsBloc.state as NotificationsLoaded;
        expect(emittedState.notifications.first.formattedDate(), equals('2025-01-01'));
      },
    );
  });
}
