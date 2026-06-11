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

// class ExamMarksData {
//   int? markId;
//   int? examId;
//   int? studentId;
//   int? classId;
//   int? sectionId;
//   int? timetableId;
//   double? marksObtained;
//   double? totalMarks;
//   String? grade;
//   String? remarks;
//   String? studentName;
//   String? admissionNo;
//   String? gender;
//   String? subjectName;
//   String? examName;
//   String? className;
//   String? sectionName;
//
//   ExamMarksData({
//     this.markId,
//     this.examId,
//     this.studentId,
//     this.classId,
//     this.sectionId,
//     this.timetableId,
//     this.marksObtained,
//     this.totalMarks,
//     this.grade,
//     this.remarks,
//     this.studentName,
//     this.admissionNo,
//     this.gender,
//     this.subjectName,
//     this.examName,
//     this.className,
//     this.sectionName,
//   });
//
//   factory ExamMarksData.fromJson(Map<String, dynamic> json) {
//     return ExamMarksData(
//       markId: json['mark_id'],
//       examId: json['exam_id'],
//       studentId: json['student_id'],
//       classId: json['class_id'],
//       sectionId: json['section_id'],
//       timetableId: json['timetable_id'],
//       marksObtained: json['marks_obtained'] != null
//           ? double.tryParse(json['marks_obtained'].toString())
//           : null,
//       totalMarks: json['total_marks'] != null
//           ? double.tryParse(json['total_marks'].toString())
//           : null,
//       grade: json['grade'],
//       remarks: json['remarks'],
//       studentName: json['student_name'],
//       admissionNo: json['admission_no'],
//       gender: json['gender'],
//       subjectName: json['subject_name'],
//       examName: json['exam_name'],
//       className: json['class_name'],
//       sectionName: json['section_name'],
//     );
//   }
// }
class ExamMarksData {
  int? markId;
  int? examId;
  int? studentId;
  int? classId;
  int? sectionId;
  int? timetableId;
  double? marksObtained;
  double? totalMarks;
  String? grade;
  String? remarks;
  String? studentName;
  String? admissionNo;
  String? gender;
  String? subjectName;
  String? examName;
  String? className;
  String? sectionName;

  DateTime? examDate; // ✅ ADD THIS

  ExamMarksData({
    this.markId,
    this.examId,
    this.studentId,
    this.classId,
    this.sectionId,
    this.timetableId,
    this.marksObtained,
    this.totalMarks,
    this.grade,
    this.remarks,
    this.studentName,
    this.admissionNo,
    this.gender,
    this.subjectName,
    this.examName,
    this.className,
    this.sectionName,
    this.examDate, // ✅ ADD
  });
  factory ExamMarksData.fromJson(Map<String, dynamic> json) {
    return ExamMarksData(
      markId: json['mark_id'],
      examId: json['exam_id'],
      studentId: json['student_id'],
      classId: json['class_id'],
      sectionId: json['section_id'],
      timetableId: json['timetable_id'],
      marksObtained: json['marks_obtained'] != null
          ? double.tryParse(json['marks_obtained'].toString())
          : null,
      totalMarks: json['total_marks'] != null
          ? double.tryParse(json['total_marks'].toString())
          : null,
      grade: json['grade'],
      remarks: json['remarks'],
      studentName: json['student_name'],
      admissionNo: json['admission_no'],
      gender: json['gender'],
      subjectName: json['subject_name'],
      examName: json['exam_name'],
      className: json['class_name'],
      sectionName: json['section_name'],

      // ✅ ADD THIS
      examDate: json['exam_date'] != null
          ? DateTime.parse(json['exam_date'])
          : null,
    );
  }}