import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class AuthManager {
  final String baseUrl = 'http://10.0.2.2:3001';
  static const _storage = FlutterSecureStorage();
  static const _keyToken = 'auth_token';

  /// Save token securely
  Future<void> _saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  /// Retrieve token securely
  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  /// Delete token
  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  /// Sign up a new user
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/user/signup');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        // Extract user information from the response
        final user = User(
          id: responseData['newUser']['_id'],
          email: responseData['newUser']['email'],
        );

        return {
          'success': true,
          'message': responseData['Message'],
          'user': user,
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Signup failed',
        };
      }
    } catch (error) {
      return {
        'success': false,
        'message': 'Error: $error',
      };
    }
  }

  /// Login an existing user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/user/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Extract token and construct the user
        final user = User(
          id: '', // No `id` returned in login response
          email: email,
          token: responseData['Message']['token'],
        );

        // Save the token securely
        await _saveToken(user.token!);

        return {
          'success': true,
          'message': 'Login successful',
          'user': user,
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login failed',
        };
      }
    } catch (error) {
      return {
        'success': false,
        'message': 'Error: $error',
      };
    }
  }
}
