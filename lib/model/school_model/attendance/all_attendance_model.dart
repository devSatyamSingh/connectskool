// ============================================================
//  student_attendance_model.dart
// ============================================================
//  API Response:
//  {
//    "success": true,
//    "message": "Students fetched successfully",
//    "data": {
//      "date": "2026/01/24",
//      "class_id": 64,
//      "section_id": 71,
//      "total_students": 0,
//      "students": []
//    }
//  }
// ============================================================

class AllAttendanceModel {
  final bool?   success;
  final String? message;
  final AttendanceData? data;

  AllAttendanceModel({this.success, this.message, this.data});

  factory AllAttendanceModel.fromJson(Map<String, dynamic> json) {
    return AllAttendanceModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? AttendanceData.fromJson(json['data'])
          : null,
    );
  }
}

class AttendanceData {
  final String? date;
  final int?    classId;
  final int?    sectionId;
  final int?    totalStudents;
  final List<StudentAttendance> students;

  AttendanceData({
    this.date,
    this.classId,
    this.sectionId,
    this.totalStudents,
    required this.students,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      date:          json['date'],
      classId:       json['class_id'],
      sectionId:     json['section_id'],
      totalStudents: json['total_students'],
      students: json['students'] != null
          ? List<StudentAttendance>.from(
          (json['students'] as List).map((e) => StudentAttendance.fromJson(e)))
          : [],
    );
  }
}

class StudentAttendance {
  final int?    studentId;
  final String? studentName;
  final String? rollNo;
  final String? status;    // present | absent | late
  final String? remarks;

  StudentAttendance({
    this.studentId,
    this.studentName,
    this.rollNo,
    this.status,
    this.remarks,
  });

  factory StudentAttendance.fromJson(Map<String, dynamic> json) {
    return StudentAttendance(
      studentId:   json['student_id'],
      studentName: json['student_name'],
      rollNo:      json['roll_no']?.toString(),
      status:      json['status'],
      remarks:     json['remarks'],
    );
  }
}