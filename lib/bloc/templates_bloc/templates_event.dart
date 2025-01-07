// templates_event.dart

abstract class TemplatesEvent {
}

/// Load all templates when page is opened
class TemplatesFettchAllEvent extends TemplatesEvent {}

class DownloadTemplate extends TemplatesEvent {
  final String templateId;

  DownloadTemplate(this.templateId);
}

/// Search templates based on a query string
// class SearchTemplates extends TemplatesEvent {
//   final String query;

//   const SearchTemplates(this.query);

//   @override
//   List<Object> get props => [query];
// }

// /// Filter templates by category
// class FilterTemplates extends TemplatesEvent {
//   final String category;

//   const FilterTemplates(this.category);

//   @override
//   List<Object> get props => [category];
// }
