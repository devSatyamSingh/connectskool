
class SchoolAdminMarkSheetModel {
  bool? success;
  List<CoScholasticGrade>? data;

  SchoolAdminMarkSheetModel({this.success, this.data});

  // factory SchoolAdminMarkSheetModel.fromJson(Map<String, dynamic> json) {
  //   return SchoolAdminMarkSheetModel(
  //     success: json['success'],
  //     data: json['data'] != null
  //         ? (json['data'] as List)
  //         .map((v) => CoScholasticGrade.fromJson(
  //         Map<String, dynamic>.from(v as Map)))
  //         .toList()
  //         : [],
  //   );
  // }
  factory SchoolAdminMarkSheetModel.fromJson(Map<String, dynamic> json) {
    List<CoScholasticGrade> gradeList = [];

    if (json['data'] != null && json['data'] is List) {
      gradeList = (json['data'] as List)
          .map((v) => CoScholasticGrade.fromJson(
          Map<String, dynamic>.from(v)))
          .toList();
    }

    return SchoolAdminMarkSheetModel(
      success: json['success'] ?? false,
      data: gradeList,
    );
  }
}

class CoScholasticGrade {
  final int?    coScholasticGradesId;
  final int?    schoolId;
  final int?    studentId;
  final int?    subjectId;
  final String? term;
  final String? grade;
  final String? academicYear;
  final String? createdAt;
  final String? updatedAt;
  final String? subjectName;
  final String? studentName;
  final dynamic rollNo;

  CoScholasticGrade({
    this.coScholasticGradesId,
    this.schoolId,
    this.studentId,
    this.subjectId,
    this.term,
    this.grade,
    this.academicYear,
    this.createdAt,
    this.updatedAt,
    this.subjectName,
    this.studentName,
    this.rollNo,
  });

  factory CoScholasticGrade.fromJson(Map<String, dynamic> json) {
    return CoScholasticGrade(
      coScholasticGradesId: json['co_scholastic_grades_id'],
      schoolId:    json['school_id'],
      studentId:   json['student_id'],
      subjectId:   json['subject_id'],
      term:        json['term'],
      grade:       json['grade'],
      academicYear: json['academic_year'],
      createdAt:   json['created_at'],
      updatedAt:   json['updated_at'],
      subjectName: json['subject_name'],
      studentName: json['student_name'],
      rollNo:      json['roll_no'],
    );
  }
}