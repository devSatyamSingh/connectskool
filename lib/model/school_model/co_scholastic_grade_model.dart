class CoScholasticGradeModel {
  final bool? success;
  final String? message;
  final List<CoScholasticGradeData>? data;

  CoScholasticGradeModel({
    this.success,
    this.message,
    this.data,
  });

  factory CoScholasticGradeModel.fromJson(Map<String, dynamic> json) {
    return CoScholasticGradeModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<CoScholasticGradeData>.from(
        json["data"].map(
              (x) => CoScholasticGradeData.fromJson(x),
        ),
      ),
    );
  }
}

class CoScholasticGradeData {
  final int? coScholasticGradesId;
  final int? studentId;
  final int? subjectId;
  final String? studentName;
  final String? subjectName;
  final String? rollNo;
  final String? term;
  final String? grade;
  final String? academicYear;
  final int? schoolId;
  final String? createdAt;
  final String? updatedAt;

  CoScholasticGradeData({
    this.coScholasticGradesId,
    this.studentId,
    this.subjectId,
    this.studentName,
    this.subjectName,
    this.rollNo,
    this.term,
    this.grade,
    this.academicYear,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
  });

  factory CoScholasticGradeData.fromJson(
      Map<String, dynamic> json) {
    return CoScholasticGradeData(
      coScholasticGradesId:
      json["co_scholastic_grades_id"],
      studentId: json["student_id"],
      subjectId: json["subject_id"],
      studentName: json["student_name"],
      subjectName: json["subject_name"],
      rollNo: json["roll_no"],
      term: json["term"],
      grade: json["grade"],
      academicYear: json["academic_year"],
      schoolId: json["school_id"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }
}