// class StudentAttendanceModel {
//   bool? success;
//   String? message;
//   List<AttendanceData>? data;
//
//   StudentAttendanceModel({this.success, this.message, this.data});
//
//   factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) {
//     return StudentAttendanceModel(
//       success: json['success'] as bool?,
//       message: json['message'] as String?,
//       data: (json['data'] as List<dynamic>?)
//           ?.map((e) => AttendanceData.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'data': data?.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class AttendanceData {
//   int? attendanceId;
//   String? attendanceDate;
//   String? status;
//   String? remarks;
//
//   AttendanceData({this.attendanceId, this.attendanceDate, this.status, this.remarks});
//
//   factory AttendanceData.fromJson(Map<String, dynamic> json) {
//     return AttendanceData(
//       attendanceId: json['attendance_id'] as int?,
//       attendanceDate: json['attendance_date'] as String?,
//       status: json['status'] as String?,
//       remarks: json['remarks'] as String?,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'attendance_id': attendanceId,
//       'attendance_date': attendanceDate,
//       'status': status,
//       'remarks': remarks,
//     };
//   }
// }
class StudentAttendanceModel {
  bool? success;
  String? message;
  List<AttendanceData>? data;

  StudentAttendanceModel({this.success, this.message, this.data});

  factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AttendanceData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class AttendanceData {
  int? attendanceId;
  int? studentId;       // ✅ added
  String? studentName;  // ✅ added  → API key: "student_name"
  String? attendanceDate;
  String? status;
  String? remarks;

  AttendanceData({
    this.attendanceId,
    this.studentId,
    this.studentName,
    this.attendanceDate,
    this.status,
    this.remarks,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      attendanceId:   json['attendance_id']   as int?,
      studentId:      json['student_id']      as int?,
      studentName:    json['student_name']    as String?,  // ✅
      attendanceDate: json['attendance_date'] as String?,
      status:         json['status']          as String?,
      remarks:        json['remarks']         as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'attendance_id':   attendanceId,
    'student_id':      studentId,
    'student_name':    studentName,
    'attendance_date': attendanceDate,
    'status':          status,
    'remarks':         remarks,
  };
}