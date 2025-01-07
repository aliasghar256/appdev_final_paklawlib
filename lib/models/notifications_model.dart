import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class NotificationsModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;

  const NotificationsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  String formattedDate() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  @override
  List<Object?> get props => [id, title, description, date];
}

List<NotificationsModel> parseNotifications(List<dynamic> jsonList) {
  return jsonList.map((json) => NotificationsModel.fromJson(json)).toList();
}
