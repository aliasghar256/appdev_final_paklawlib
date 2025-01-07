import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finalproject/bloc/templates_bloc/templates_bloc.dart';
import 'package:finalproject/bloc/templates_bloc/templates_event.dart';
import 'package:finalproject/bloc/templates_bloc/templates_state.dart';
import 'package:finalproject/managers/templates_manager.dart';
import 'package:finalproject/models/templates_model.dart';

class MockTemplatesManager extends Mock implements TemplatesManager {}

void main() {
  late MockTemplatesManager mockTemplatesManager;
  late TemplatesBloc templatesBloc;

  setUp(() {
    mockTemplatesManager = MockTemplatesManager();
    templatesBloc = TemplatesBloc(manager: mockTemplatesManager);
  });

  tearDown(() {
    templatesBloc.close();
  });

  group('TemplatesBloc Tests', () {
    blocTest<TemplatesBloc, TemplatesState>(
      'emits [TemplatesLoading, TemplatesLoaded] when TemplatesFettchAllEvent is successful',
      build: () {
        when(() => mockTemplatesManager.fetchAllTemplates()).thenAnswer((_) async => [
              Template(
                id: '1',
                filename: 'template1.docx',
                length: 1024,
                chunkSize: 256,
                uploadDate: DateTime.parse('2025-01-01T00:00:00Z'),
                metadata: Metadata(
                  title: 'Template 1',
                  description: 'Description of Template 1',
                ),
              ),
              Template(
                id: '2',
                filename: 'template2.docx',
                length: 2048,
                chunkSize: 512,
                uploadDate: DateTime.parse('2025-01-02T00:00:00Z'),
                metadata: Metadata(
                  title: 'Template 2',
                  description: 'Description of Template 2',
                ),
              ),
            ]);
        return templatesBloc;
      },
      act: (bloc) => bloc.add(TemplatesFettchAllEvent()),
      expect: () => [
        TemplatesLoading(),
        TemplatesLoaded(templates: [
          Template(
            id: '1',
            filename: 'template1.docx',
            length: 1024,
            chunkSize: 256,
            uploadDate: DateTime.parse('2025-01-01T00:00:00Z'),
            metadata: Metadata(
              title: 'Template 1',
              description: 'Description of Template 1',
            ),
          ),
          Template(
            id: '2',
            filename: 'template2.docx',
            length: 2048,
            chunkSize: 512,
            uploadDate: DateTime.parse('2025-01-02T00:00:00Z'),
            metadata: Metadata(
              title: 'Template 2',
              description: 'Description of Template 2',
            ),
          ),
        ]),
      ],
    );

    blocTest<TemplatesBloc, TemplatesState>(
      'emits [TemplatesLoading, TemplatesError] when TemplatesFettchAllEvent fails',
      build: () {
        when(() => mockTemplatesManager.fetchAllTemplates())
            .thenThrow(Exception('Failed to fetch templates'));
        return templatesBloc;
      },
      act: (bloc) => bloc.add(TemplatesFettchAllEvent()),
      expect: () => [
        TemplatesLoading(),
        TemplatesError(error: 'Exception: Failed to fetch templates'),
      ],
    );

    blocTest<TemplatesBloc, TemplatesState>(
      'does not emit any state when DownloadTemplateEvent is successful',
      build: () {
        when(() => mockTemplatesManager.downloadTemplateById(any(), any()))
            .thenAnswer((_) async => {});
        return templatesBloc;
      },
      act: (bloc) => bloc.add(DownloadTemplateEvent(
        templateId: '1',
        savePath: '/downloads/template1.docx',
      )),
      expect: () => [],
    );

    blocTest<TemplatesBloc, TemplatesState>(
      'handles error silently when DownloadTemplateEvent fails',
      build: () {
        when(() => mockTemplatesManager.downloadTemplateById(any(), any()))
            .thenThrow(Exception('Download failed'));
        return templatesBloc;
      },
      act: (bloc) => bloc.add(DownloadTemplateEvent(
        templateId: '1',
        savePath: '/downloads/template1.docx',
      )),
      expect: () => [], // No state is emitted
      verify: (_) {
        // Verify that the downloadTemplateById method was called
        verify(() => mockTemplatesManager.downloadTemplateById('1', '/downloads/template1.docx')).called(1);
      },
    );
  });
}
