import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/templates_model.dart';
import 'bloc/templates_bloc/templates_state.dart';
import 'bloc/templates_bloc/templates_event.dart';
import 'bloc/templates_bloc/templates_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<String> getDefaultDownloadPath(String filename) async {
  if (Platform.isAndroid || Platform.isIOS) {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$filename';
  } else if (Platform.isWindows) {
    return 'C:\\Users\\${Platform.environment['USERNAME']}\\Downloads\\$filename';
  } else if (Platform.isMacOS || Platform.isLinux) {
    return '/Users/${Platform.environment['USER']}/Downloads/$filename';
  } else {
    throw UnsupportedError('Unsupported platform');
  }
}

class TemplatesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Legal Templates'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Add search functionality here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Optional Horizontal Chips
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Contracts'),
                _buildFilterChip('Agreements'),
                _buildFilterChip('MOUs'),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<TemplatesBloc, TemplatesState>(
              builder: (context, state) {
                if (state is TemplatesLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TemplatesLoaded) {
                  final templates = state.templates;
                  if (templates.isEmpty) {
                    return Center(child: Text('No templates found'));
                  }
                  return ListView.builder(
                    itemCount: templates.length,
                    itemBuilder: (context, index) {
                      final template = templates[index];
                      return _buildTemplateCard(context, template);
                    },
                  );
                } else if (state is TemplatesError) {
                  return Center(child: Text('Error: ${state.error}'));
                } else {
                  return Center(child: Text('Unexpected state'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Builds a filter chip
  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Chip(
        label: Text(label),
        onDeleted: () {
          // Add filter functionality here
        },
      ),
    );
  }

  // Builds a single template card
  Widget _buildTemplateCard(BuildContext context, Template template) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(template.metadata.title),
        subtitle: Text(template.metadata.description),
        trailing: Wrap(
          spacing: 8,
          children: [
            ElevatedButton(
              onPressed: () async {
                final templateId = template.id;
                final filename = template.filename;

                try {
                  // Get the dynamic save path
                  final savePath = await getDefaultDownloadPath(filename);

                  // Trigger the download event
                  context.read<TemplatesBloc>().add(DownloadTemplateEvent(
                    templateId: templateId,
                    savePath: savePath,
                  ));

                  // Provide feedback to the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Downloading $filename...')),
                  );
                } catch (e) {
                  // Handle path errors or other issues
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: Text('Download'),
            ),

            ElevatedButton(
              onPressed: () {
                // Implement edit functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Edit functionality here')),
                );
              },
              child: Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }
}
