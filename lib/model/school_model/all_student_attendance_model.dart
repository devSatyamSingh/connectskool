// // class AllStudentAdminAttendanceModel {
// //   bool? success;
// //   String? message;
// //   AttendanceData? data;
// //
// //   AllStudentAdminAttendanceModel({this.success, this.message, this.data});
// //
// //   AllStudentAdminAttendanceModel.fromJson(Map<String, dynamic> json) {
// //     success = json['success'];
// //     message = json['message'];
// //     data = json['data'] != null ? AttendanceData.fromJson(json['data']) : null;
// //   }
// // }
// //
// // class AttendanceData {
// //   String? date;
// //   int? classId;
// //   int? sectionId;
// //   int? totalStudents;
// //   List<StudentAttendance>? students;
// //
// //   AttendanceData({
// //     this.date,
// //     this.classId,
// //     this.sectionId,
// //     this.totalStudents,
// //     this.students,
// //   });
// //
// //   AttendanceData.fromJson(Map<String, dynamic> json) {
// //     date = json['date'];
// //     classId = json['class_id'];
// //     sectionId = json['section_id'];
// //     totalStudents = json['total_students'];
// //
// //     if (json['students'] != null) {
// //       students = <StudentAttendance>[];
// //       json['students'].forEach((v) {
// //         students!.add(StudentAttendance.fromJson(v));
// //       });
// //     }
// //   }
// // }
// //
// // class StudentAttendance {
// //   int? attendanceId;
// //   int? studentId;
// //   String? admissionNo;
// //   String? rollNo;
// //   String? studentName;
// //   String? fatherName;
// //   String? userEmail;
// //   String? markedAt;
// //
// //   StudentAttendance({
// //     this.attendanceId,
// //     this.studentId,
// //     this.admissionNo,
// //     this.rollNo,
// //     this.studentName,
// //     this.fatherName,
// //     this.userEmail,
// //     this.markedAt,
// //   });
// //
// //   StudentAttendance.fromJson(Map<String, dynamic> json) {
// //     attendanceId = json['attendance_id'];
// //     studentId = json['student_id'];
// //     admissionNo = json['admission_no'];
// //     rollNo = json['roll_no']?.toString();
// //     studentName = json['student_name'];
// //     fatherName = json['father_name'];
// //     userEmail = json['user_email'];
// //     markedAt = json['marked_at'];
// //   }
// // }
// class AllStudentAdminAttendanceModel {
//   bool? success;
//   String? message;
//   AttendanceData? data;
//
//   AllStudentAdminAttendanceModel({
//     this.success,
//     this.message,
//     this.data,
//   });
//
//   factory AllStudentAdminAttendanceModel.fromJson(
//       Map<String, dynamic> json) {
//     return AllStudentAdminAttendanceModel(
//       success: json['success'] ?? false,
//       message: json['message']?.toString(),
//       data: json['data'] != null
//           ? AttendanceData.fromJson(
//           Map<String, dynamic>.from(json['data']))
//           : null,
//     );
//   }
// }
//
// class AttendanceData {
//   String? date;
//   int? classId;
//   int? sectionId;
//   int? totalStudents;
//   List<StudentAttendance>? students;
//
//   AttendanceData({
//     this.date,
//     this.classId,
//     this.sectionId,
//     this.totalStudents,
//     this.students,
//   });
//
//   factory AttendanceData.fromJson(Map<String, dynamic> json) {
//     return AttendanceData(
//       date: json['date']?.toString(),
//       classId: json['class_id'] is int
//           ? json['class_id']
//           : int.tryParse(json['class_id']?.toString() ?? ''),
//       sectionId: json['section_id'] is int
//           ? json['section_id']
//           : int.tryParse(json['section_id']?.toString() ?? ''),
//       totalStudents: json['total_students'] is int
//           ? json['total_students']
//           : int.tryParse(json['total_students']?.toString() ?? ''),
//       students: json['students'] != null
//           ? (json['students'] as List)
//           .map((e) => StudentAttendance.fromJson(
//           Map<String, dynamic>.from(e)))
//           .toList()
//           : [],
//     );
//   }
// }
//
// class StudentAttendance {
//   int? attendanceId;
//   int? studentId;
//   String? admissionNo;
//   String? rollNo;
//   String? studentName;
//   String? fatherName;
//   String? userEmail;
//   String? markedAt;
//
//   StudentAttendance({
//     this.attendanceId,
//     this.studentId,
//     this.admissionNo,
//     this.rollNo,
//     this.studentName,
//     this.fatherName,
//     this.userEmail,
//     this.markedAt,
//   });
//
//   factory StudentAttendance.fromJson(Map<String, dynamic> json) {
//     return StudentAttendance(
//       attendanceId: json['attendance_id'] is int
//           ? json['attendance_id']
//           : int.tryParse(json['attendance_id']?.toString() ?? ''),
//       studentId: json['student_id'] is int
//           ? json['student_id']
//           : int.tryParse(json['student_id']?.toString() ?? ''),
//       admissionNo: json['admission_no']?.toString(),
//       rollNo: json['roll_no']?.toString(),
//       studentName: json['student_name']?.toString(),
//       fatherName: json['father_name']?.toString(),
//       userEmail: json['user_email']?.toString(),
//       markedAt: json['marked_at']?.toString(),
//     );
//   }
// }
class AllStudentAdminAttendanceModel {
  final bool success;
  final String? message;
  final AttendanceData? data;

  AllStudentAdminAttendanceModel({
    required this.success,
    this.message,
    this.data,
  });

  factory AllStudentAdminAttendanceModel.fromJson(
      Map<String, dynamic> json) {
    return AllStudentAdminAttendanceModel(
      success: json['success'] ?? false,
      message: json['message']?.toString(),
      data: json['data'] != null
          ? AttendanceData.fromJson(
          Map<String, dynamic>.from(json['data']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "data": data?.toJson(),
    };
  }
}

class AttendanceData {
  final String? date;
  final int? classId;
  final int? sectionId;
  final int? totalStudents;
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
      date: json['date']?.toString(),
      classId: _parseInt(json['class_id']),
      sectionId: _parseInt(json['section_id']),
      totalStudents: _parseInt(json['total_students']),
      students: json['students'] != null
          ? (json['students'] as List)
          .map((e) => StudentAttendance.fromJson(
          Map<String, dynamic>.from(e)))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "class_id": classId,
      "section_id": sectionId,
      "total_students": totalStudents,
      "students": students.map((e) => e.toJson()).toList(),
    };
  }
}

class StudentAttendance {
  final int? attendanceId;
  final int? studentId;
  final String? admissionNo;
  final String? rollNo;
  final String? studentName;
  final String? fatherName;
  final String? status;        // ✅ ADDED
  final String? userEmail;
  final String? markedAt;

  StudentAttendance({
    this.attendanceId,
    this.studentId,
    this.admissionNo,
    this.rollNo,
    this.studentName,
    this.fatherName,
    this.status,
    this.userEmail,
    this.markedAt,
  });

  factory StudentAttendance.fromJson(Map<String, dynamic> json) {
    return StudentAttendance(
      attendanceId: _parseInt(json['attendance_id']),
      studentId: _parseInt(json['student_id']),
      admissionNo: _safeString(json['admission_no']),
      rollNo: _safeString(json['roll_no']),
      studentName: _safeString(json['student_name']),
      fatherName: _safeString(json['father_name']),
      status: _safeString(json['status']),   // ✅ ADDED
      userEmail: _safeString(json['user_email']),
      markedAt: _safeString(json['marked_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "attendance_id": attendanceId,
      "student_id": studentId,
      "admission_no": admissionNo,
      "roll_no": rollNo,
      "student_name": studentName,
      "father_name": fatherName,
      "status": status,
      "user_email": userEmail,
      "marked_at": markedAt,
    };
  }
}

///// 🔹 Helper Functions (Safe Parsing)

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

String? _safeString(dynamic value) {
  if (value == null) return null;
  final str = value.toString();
  if (str.toLowerCase() == "null") return null;
  return str;
}