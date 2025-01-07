import 'package:equatable/equatable.dart';
import '../../models/templates_model.dart';

abstract class TemplatesState extends Equatable {
  const TemplatesState();

  @override
  List<Object?> get props => [];
}

class TemplatesLoading extends TemplatesState {}

class TemplatesLoaded extends TemplatesState {
  final List<Template> templates;

  const TemplatesLoaded({required this.templates});

  @override
  List<Object?> get props => [templates];
}

class TemplatesError extends TemplatesState {
  final String error;

  const TemplatesError({required this.error});

  @override
  List<Object?> get props => [error];
}

class TemplateDownloadInProgress extends TemplatesState {}

class TemplateDownloaded extends TemplatesState {
  final String savePath;

  const TemplateDownloaded({required this.savePath});

  @override
  List<Object?> get props => [savePath];
}

class TemplateDownloadError extends TemplatesState {
  final String error;

  const TemplateDownloadError({required this.error});

  @override
  List<Object?> get props => [error];
}
