import '../../models/templates_model.dart';


abstract class TemplatesState {}

class TemplatesLoading extends TemplatesState {}

class TemplatesLoaded extends TemplatesState {
  final List<Template> templates;

  TemplatesLoaded({required this.templates});
}


class TemplatesError extends TemplatesState {
  final String error;

  TemplatesError({required this.error});
}

class TemplateDownloadInProgress extends TemplatesState {}

class TemplateDownloaded extends TemplatesState {
  final String savePath;

  TemplateDownloaded({required this.savePath});

}

class TemplateDownloadError extends TemplatesState {
  final String error;

  TemplateDownloadError({required this.error});

}