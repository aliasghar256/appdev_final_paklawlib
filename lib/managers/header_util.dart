import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HeaderUtil {
  static const _storage = FlutterSecureStorage();
  static const _keyToken = 'auth_token';

  /// Retrieve token from secure storage
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  /// Create headers with Authorization
  static Future<Map<String, String>> createAuthHeaders() async {
    final token = await getToken();
    if (token != null) {
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
    } else {
      throw Exception('Token not found. Please log in again.');
    }
  }
}
