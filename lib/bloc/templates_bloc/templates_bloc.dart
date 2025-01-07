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
    add(TemplatesFettchAllEvent());
  }
  
}