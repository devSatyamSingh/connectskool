class AccountantAttendanceModel {
  int? attendanceId;
  String? attendanceDate;
  String? status;
  String? remarks;
  int? accountantId;
  String? accountantName;
  String? fatherName;

  AccountantAttendanceModel({
    this.attendanceId,
    this.attendanceDate,
    this.status,
    this.remarks,
    this.accountantId,
    this.accountantName,
    this.fatherName,
  });

  AccountantAttendanceModel.fromJson(Map<String, dynamic> json) {
    attendanceId = json['attendance_id'];
    attendanceDate = json['attendance_date'];
    status = json['status'];
    remarks = json['remarks'];
    accountantId = json['accountant_id'];
    accountantName = json['accountant_name'];
    fatherName = json['father_name'];
  }
}