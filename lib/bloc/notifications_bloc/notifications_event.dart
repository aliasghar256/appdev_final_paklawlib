abstract class NotificationsEvent {}

// class NotificationsLoading extends NotificationsEvent {
// }

class NotificationsFetchAllEvent extends NotificationsEvent {
}

class NotificationsErrorEvent extends NotificationsEvent {
  final String error;

  NotificationsErrorEvent({required this.error});
}

// class TransactionsAddEvent extends NotificationsEvent {
//   final String transaction;

//   TransactionsAddEvent({required this.transaction});
// }

// class TransactionsDeleteEvent extends NotificationsEvent {
//   final String transaction;

//   TransactionsDeleteEvent({required this.transaction});
// }
