class RouteStudentsModel {
  bool? success;
  String? message;
  List<RouteStudentData>? data;

  RouteStudentsModel({this.success, this.message, this.data});

  RouteStudentsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];

    if (json['data'] != null) {
      data = <RouteStudentData>[];
      json['data'].forEach((v) {
        data!.add(RouteStudentData.fromJson(v));
      });
    }
  }
}

class RouteStudentData {
  int? studentTransportId;
  int? studentId;
  String? academicYear;
  String? studentName;
  String? admissionNo;
  String? className;
  String? sectionName;
  String? stopName;
  String? baseAmount;
  String? assignedAmount;
  String? paidAmount;
  String? pendingAmount;
  String? feeStatus;

  RouteStudentData({
    this.studentTransportId,
    this.studentId,
    this.academicYear,
    this.studentName,
    this.admissionNo,
    this.className,
    this.sectionName,
    this.stopName,
    this.baseAmount,
    this.assignedAmount,
    this.paidAmount,
    this.pendingAmount,
    this.feeStatus,
  });

  RouteStudentData.fromJson(Map<String, dynamic> json) {
    studentTransportId = json['student_transport_id'];
    studentId = json['student_id'];
    academicYear = json['academic_year'];
    studentName = json['student_name'];
    admissionNo = json['admission_no'];
    className = json['class_name'];
    sectionName = json['section_name'];
    stopName = json['stop_name'];
    baseAmount = json['base_amount'];
    assignedAmount = json['assigned_amount'];
    paidAmount = json['paid_amount'];
    pendingAmount = json['pending_amount'];
    feeStatus = json['fee_status'];
  }
}