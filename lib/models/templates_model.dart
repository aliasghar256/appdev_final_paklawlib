import 'dart:convert';

class Template {
  String id;
  String filename;
  int length;
  int chunkSize;
  DateTime uploadDate;
  Metadata metadata;

  Template({
    required this.id,
    required this.filename,
    required this.length,
    required this.chunkSize,
    required this.uploadDate,
    required this.metadata,
  });

  // Factory constructor to create a Template object from JSON
  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      id: json['_id'] as String,
      filename: json['filename'] as String,
      length: json['length'] as int,
      chunkSize: json['chunkSize'] as int,
      uploadDate: DateTime.parse(json['uploadDate'] as String),
      metadata: Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );
  }

  // Method to convert Template object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'filename': filename,
      'length': length,
      'chunkSize': chunkSize,
      'uploadDate': uploadDate.toIso8601String(),
      'metadata': metadata.toJson(),
    };
  }
}

class Metadata {
  String title;
  String description;

  Metadata({
    required this.title,
    required this.description,
  });

  // Factory constructor to create a Metadata object from JSON
  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  // Method to convert Metadata object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}

List<Template> templatesFromJson(String str) {
  final jsonData = json.decode(str) as List;
  return jsonData.map((item) => Template.fromJson(item as Map<String, dynamic>)).toList();
}

// Helper function to convert a list of Template objects to JSON string
String templatesToJson(List<Template> templates) {
  final jsonData = templates.map((template) => template.toJson()).toList();
  return json.encode(jsonData);
}
