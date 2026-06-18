class CreateCoScholasticGradeRequest {
  int? studentId;
  int? subjectId;
  String? term;
  String? grade;
  String? academicYear;

  CreateCoScholasticGradeRequest({
    this.studentId,
    this.subjectId,
    this.term,
    this.grade,
    this.academicYear,
  });

  Map<String, dynamic> toJson() {
    return {
      "student_id": studentId,
      "subject_id": subjectId,
      "term": term,
      "grade": grade,
      "academic_year": academicYear,
    };
  }
}