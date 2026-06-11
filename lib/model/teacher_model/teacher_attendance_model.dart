class TeacherAttendanceModel {
  bool? success;
  List<AttendanceData>? data;

  TeacherAttendanceModel({this.success, this.data});

  TeacherAttendanceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <AttendanceData>[];
      json['data'].forEach((v) {
        data!.add(AttendanceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class AttendanceData {
  int? attendanceId;
  String? attendanceDate;
  String? status;
  String? remarks;
  int? teacherId;
  String? teacherName;
  String? fatherName;

  AttendanceData({
    this.attendanceId,
    this.attendanceDate,
    this.status,
    this.remarks,
    this.teacherId,
    this.teacherName,
    this.fatherName,
  });

  AttendanceData.fromJson(Map<String, dynamic> json) {
    attendanceId = json['attendance_id'];
    attendanceDate = json['attendance_date'];
    status = json['status'];
    remarks = json['remarks'];
    teacherId = json['teacher_id'];
    teacherName = json['teacher_name'];
    fatherName = json['father_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['attendance_id'] = attendanceId;
    map['attendance_date'] = attendanceDate;
    map['status'] = status;
    map['remarks'] = remarks;
    map['teacher_id'] = teacherId;
    map['teacher_name'] = teacherName;
    map['father_name'] = fatherName;
    return map;
  }
}