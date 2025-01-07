import '../../models/notifications_model.dart';


abstract class NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationsModel> notifications;

  NotificationsLoaded({required this.notifications});
}


class NotificationsError extends NotificationsState {
  final String error;

  NotificationsError({required this.error});
}