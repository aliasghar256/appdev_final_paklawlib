import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/templates_model.dart';
import './header_util.dart';
class TemplatesManager {
  // Base URL for the templates API
  final String baseUrl = 'http://10.0.2.2:3001/templates';

  TemplatesManager();

  // Fetch all templates
  Future<List<Template>> fetchAllTemplates() async {
    final url = Uri.parse('$baseUrl/fetch_all_templates');
    final headers = await HeaderUtil.createAuthHeaders();

    try {
      final response = await http.get(url,headers: headers);

      if (response.statusCode == 200) {
        // Use Template.fromJson to parse the response
        return templatesFromJson(response.body);
      } else {
        throw Exception('Failed to fetch templates: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error fetching templates: $error');
    }
  }

  // Download a template by ID
  Future<File> downloadTemplateById(String id, String savePath) async {
    final url = Uri.parse('$baseUrl/download/$id');
    final headers = await HeaderUtil.createAuthHeaders();

    try {
      final response = await http.get(url,headers: headers);

      if (response.statusCode == 200) {
        // Save the file to the specified path
        final file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);

        return file;
      } else {
        throw Exception('Failed to download template: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error downloading template: $error');
    }
  }
}
