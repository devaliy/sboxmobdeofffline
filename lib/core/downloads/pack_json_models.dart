/// Parses the `pack.json` payload inside a downloaded zip (spec Section
/// 4.5) into typed models the importer writes straight into drift
/// companions. Field names mirror the wire shape exactly.
library;

class StudyPackJson {
  const StudyPackJson({
    required this.scopeId,
    required this.version,
    required this.classJson,
    required this.bookJson,
    required this.terms,
    required this.subjects,
  });

  final int scopeId;
  final String version;
  final Map<String, dynamic> classJson;
  final Map<String, dynamic> bookJson;
  final List<Map<String, dynamic>> terms;
  final List<StudySubjectJson> subjects;

  factory StudyPackJson.fromJson(Map<String, dynamic> json) => StudyPackJson(
        scopeId: json['scope_id'] as int,
        version: json['version'] as String,
        classJson: json['class'] as Map<String, dynamic>,
        bookJson: json['book'] as Map<String, dynamic>,
        terms: (json['terms'] as List).cast<Map<String, dynamic>>(),
        subjects: (json['subjects'] as List)
            .cast<Map<String, dynamic>>()
            .map(StudySubjectJson.fromJson)
            .toList(),
      );
}

class StudySubjectJson {
  const StudySubjectJson({required this.json, required this.contents, required this.questions});

  final Map<String, dynamic> json;
  final List<Map<String, dynamic>> contents;
  final List<Map<String, dynamic>> questions;

  factory StudySubjectJson.fromJson(Map<String, dynamic> json) => StudySubjectJson(
        json: json,
        contents: (json['contents'] as List).cast<Map<String, dynamic>>(),
        questions: (json['questions'] as List).cast<Map<String, dynamic>>(),
      );
}

class AssessmentPackJson {
  const AssessmentPackJson({
    required this.scopeId,
    required this.version,
    required this.subjectJson,
    required this.categories,
    required this.years,
    required this.testTypes,
    required this.passages,
    required this.questions,
  });

  final int scopeId;
  final String version;
  final Map<String, dynamic> subjectJson;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> years;
  final List<Map<String, dynamic>> testTypes;
  final List<Map<String, dynamic>> passages;
  final List<Map<String, dynamic>> questions;

  factory AssessmentPackJson.fromJson(Map<String, dynamic> json) => AssessmentPackJson(
        scopeId: json['scope_id'] as int,
        version: json['version'] as String,
        subjectJson: json['subject'] as Map<String, dynamic>,
        categories: (json['categories'] as List).cast<Map<String, dynamic>>(),
        years: (json['years'] as List).cast<Map<String, dynamic>>(),
        testTypes: (json['test_types'] as List).cast<Map<String, dynamic>>(),
        passages: (json['passages'] as List).cast<Map<String, dynamic>>(),
        questions: (json['questions'] as List).cast<Map<String, dynamic>>(),
      );
}
