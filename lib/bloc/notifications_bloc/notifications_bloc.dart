import 'package:flutter_bloc/flutter_bloc.dart';
import '../../managers/notifications_manager.dart';
import '../../models/notifications_model.dart';

import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsManager manager;

  NotificationsBloc({required this.manager}) : super(NotificationsLoading()) {

    on<NotificationsFetchAllEvent>((event, emit) async {
      emit(NotificationsLoading());
      try {
        final List<NotificationsModel> notifications = await manager.fetchAllNotifications();
        emit(NotificationsLoaded(notifications: notifications));
      } catch (e) {
        emit(NotificationsError(error: e.toString()));
      }
    });
    add(NotificationsFetchAllEvent());
  }
  
  // add(NotificationsFetchAllEvent);
}