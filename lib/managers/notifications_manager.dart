import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/notifications_model.dart';
import './header_util.dart';


class NotificationsManager {
  // Base URL for the notifications API
  final String baseUrl = 'http://10.0.2.2:3001/notifications/fetch_all';

  NotificationsManager();

  Future<List<NotificationsModel>> fetchAllNotifications() async {
    final url = Uri.parse(baseUrl);
    final headers = await HeaderUtil.createAuthHeaders();

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        return data.map((jsonItem) => NotificationsModel.fromJson(jsonItem)).toList();
      } else {
        throw Exception('Failed to fetch notifications: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error fetching notifications: $error');
    }
  }

  // // Fetch a single notification by ID
  // Future<NotificationModel> fetchNotificationById(String id) async {
  //   final url = Uri.parse('$baseUrl/$id');

  //   try {
  //     final response = await http.get(url);

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       return NotificationModel.fromJson(data);
  //     } else if (response.statusCode == 404) {
  //       throw Exception('Notification not found');
  //     } else {
  //       throw Exception('Unexpected error. Status code: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     throw Exception('Error fetching notification: $error');
  //   }
  // }

  // // Fetch notifications with pagination
  // Future<List<NotificationModel>> fetchNotificationsWithPagination({
  //   int page = 1,
  //   int limit = 10,
  // }) async {
  //   final url = Uri.parse('$baseUrl?page=$page&limit=$limit');

  //   try {
  //     final response = await http.get(url);

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body) as List<dynamic>;
  //       return data.map((jsonItem) => NotificationModel.fromJson(jsonItem)).toList();
  //     } else {
  //       throw Exception('Failed to fetch paginated notifications: ${response.body}');
  //     }
  //   } catch (error) {
  //     throw Exception('Error fetching paginated notifications: $error');
  //   }
  // }
}
