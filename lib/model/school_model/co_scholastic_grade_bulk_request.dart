class BulkCoScholasticGradeRequest {
  String? academicYear;
  String? term;

  List<GradeItem>? grades;

  BulkCoScholasticGradeRequest({
    this.academicYear,
    this.term,
    this.grades,
  });

  Map<String, dynamic> toJson() {
    return {
      "academic_year": academicYear,
      "term": term,
      "grades": grades?.map((e) => e.toJson()).toList(),
    };
  }
}

class GradeItem {
  int? studentId;
  int? subjectId;
  String? grade;

  GradeItem({
    this.studentId,
    this.subjectId,
    this.grade,
  });

  Map<String, dynamic> toJson() {
    return {
      "student_id": studentId,
      "subject_id": subjectId,
      "grade": grade,
    };
  }
}