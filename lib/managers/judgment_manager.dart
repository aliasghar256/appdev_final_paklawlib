import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/judgment_model.dart';
import './header_util.dart';

class JudgmentManager {

  JudgmentManager();

  Future<List<Judgment>> fetchJudgmentsByKeyword({
    required String keyword,
    int page = 1,
    int limit = 10,
  }) async {
    final url = Uri.parse('http://10.0.2.2:3001/judgment/keyword_search');
    final headers = await HeaderUtil.createAuthHeaders();

    final response = await http.get(
      url,
      headers: {
        ...headers,
        'keyword': keyword,
        // 'page': page.toString(),
        // 'limit': limit.toString(),
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final results = data['results'] as List<dynamic>;

      return results.map((jsonItem) => Judgment.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to fetch judgments: ${response.body}');
    }
  }

Future<Judgment> fetchJudgmentById(String id) async {
  final url = Uri.parse('http://10.0.2.2:3001/judgment/searchbyid?JudgmentID=$id');
  final headers = await HeaderUtil.createAuthHeaders();


  try {
    final response = await http.get(url,headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final judgmentJson = data['judgment'];
      return Judgment.fromJson(judgmentJson);
    } else if (response.statusCode == 404) {
      throw Exception('Judgment not found');
    } else {
      throw Exception('Unexpected error. Status code ');
    }
  } catch (error) {
    throw Exception('Error fetching judgment $error');
  }
}

Future<Map<String, dynamic>> addFavorite({
    required String judgmentId,
  }) async {
    final url = Uri.parse('http://10.0.2.2:3001/favorites/add');

    // Create Authorization headers with the token
    final headers = await HeaderUtil.createAuthHeaders();
    headers.addAll({
      'judgmentid': judgmentId, // Add the JudgmentID in the headers
    });
    print("Headers: $headers");
    try {
      final response = await http.post(url, headers: headers);
      print("response: ${response.toString()}");
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': json.decode(response.body)['Message'],
        };
      } else {
        final responseData = json.decode(response.body);
        return {
          'success': false,
          'message': responseData['Message'] ?? 'Error adding favorite',
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