import 'package:flutter_bloc/flutter_bloc.dart';
import 'templates_event.dart';
import 'templates_state.dart';
import '../../models/templates_model.dart';
import '../../managers/templates_manager.dart';

class TemplatesBloc extends Bloc<TemplatesEvent, TemplatesState> {
  final TemplatesManager manager;

  TemplatesBloc({required this.manager}) : super(TemplatesLoading()) {

    on<TemplatesFettchAllEvent>((event, emit) async {
      emit(TemplatesLoading());
      try {
        final List<Template> templates = await manager.fetchAllTemplates();
        emit(TemplatesLoaded(templates: templates));
      } catch (e) {
        emit(TemplatesError(error: e.toString()));
      }
    });

    on<DownloadTemplateEvent>((event, emit) async {
      try {
        await manager.downloadTemplateById(event.templateId, event.savePath);
        // Perform the download silently without emitting any new states
      } catch (e) {
        // Optionally log or handle the error silently
        print('Download error: ${e.toString()}');
      }
    });
    add(TemplatesFettchAllEvent());
  }
  
}