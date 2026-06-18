class ExamMarksModel {
  bool? success;
  String? message;
  List<ExamMarksData>? data;

  ExamMarksModel({this.success, this.message, this.data});

  factory ExamMarksModel.fromJson(Map<String, dynamic> json) {
    return ExamMarksModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? List<ExamMarksData>.from(
          json['data'].map((e) => ExamMarksData.fromJson(e)))
          : [],
    );
  }
}

class ExamMarksData {
  int? markId;
  int? schoolId;
  int? examId;
  int? studentId;
  int? classId;
  int? sectionId;
  int? timetableId;
  int? enteredBy;

  double? marksObtained;
  double? totalMarks;

  int? isAbsent;
  int? status;

  String? grade;
  String? remarks;

  String? studentName;
  String? admissionNo;
  String? rollNo;
  String? gender;

  String? subjectName;
  String? examName;
  String? className;
  String? sectionName;

  DateTime? examDate;
  DateTime? createdAt;
  DateTime? updatedAt;

  ExamMarksData({
    this.markId,
    this.schoolId,
    this.examId,
    this.studentId,
    this.classId,
    this.sectionId,
    this.timetableId,
    this.enteredBy,
    this.marksObtained,
    this.totalMarks,
    this.isAbsent,
    this.status,
    this.grade,
    this.remarks,
    this.studentName,
    this.admissionNo,
    this.rollNo,
    this.gender,
    this.subjectName,
    this.examName,
    this.className,
    this.sectionName,
    this.examDate,
    this.createdAt,
    this.updatedAt,
  });

  factory ExamMarksData.fromJson(
      Map<String, dynamic> json,
      ) {
    return ExamMarksData(
      markId: json['mark_id'],
      schoolId: json['school_id'],
      examId: json['exam_id'],
      studentId: json['student_id'],
      classId: json['class_id'],
      sectionId: json['section_id'],
      timetableId: json['timetable_id'],
      enteredBy: json['entered_by'],

      marksObtained: json['marks_obtained'] != null
          ? double.tryParse(
        json['marks_obtained'].toString(),
      )
          : null,

      totalMarks: json['max_marks'] != null
          ? double.tryParse(
        json['max_marks'].toString(),
      )
          : null,

      isAbsent: json['is_absent'],
      status: json['status'],

      grade: json['grade'],
      remarks: json['remarks'],

      studentName: json['student_name'],
      admissionNo: json['admission_no'],
      rollNo: json['roll_no'], // ✅ Added
      gender: json['gender'],

      subjectName: json['subject_name'],
      examName: json['exam_name'],
      className: json['class_name'],
      sectionName: json['section_name'],

      examDate: json['exam_date'] != null
          ? DateTime.tryParse(
        json['exam_date'].toString(),
      )
          : null,

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(
        json['created_at'].toString(),
      )
          : null,

      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(
        json['updated_at'].toString(),
      )
          : null,
    );
  }
}