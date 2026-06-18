class TransportStudentsModel {
  bool? success;
  String? message;
  List<TransportStudentData>? data;

  TransportStudentsModel({
    this.success,
    this.message,
    this.data,
  });

  TransportStudentsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];

    if (json['data'] != null) {
      data = <TransportStudentData>[];
      json['data'].forEach((v) {
        data!.add(TransportStudentData.fromJson(v));
      });
    }
  }
}

class TransportStudentData {
  int? studentTransportId;
  int? studentId;
  String? academicYear;
  String? assignedOn;
  int? isActive;

  String? studentName;
  String? admissionNo;
  String? rollNo;

  String? className;
  String? sectionName;

  int? transportRouteId;
  String? routeName;
  String? vehicleNo;

  int? transportRouteStopId;
  String? stopName;

  String? distanceKm;

  String? baseAmount;
  String? feeFrequency;

  String? assignedAmount;
  String? paidAmount;
  String? pendingAmount;

  String? feeStatus;

  TransportStudentData.fromJson(Map<String, dynamic> json) {
    studentTransportId = json['student_transport_id'];
    studentId = json['student_id'];
    academicYear = json['academic_year'];
    assignedOn = json['assigned_on'];
    isActive = json['is_active'];

    studentName = json['student_name'];
    admissionNo = json['admission_no'];
    rollNo = json['roll_no'];

    className = json['class_name'];
    sectionName = json['section_name'];

    transportRouteId = json['transport_route_id'];
    routeName = json['route_name'];
    vehicleNo = json['vehicle_no'];

    transportRouteStopId = json['transport_route_stop_id'];
    stopName = json['stop_name'];

    distanceKm = json['distance_km'];

    baseAmount = json['base_amount'];
    feeFrequency = json['fee_frequency'];

    assignedAmount = json['assigned_amount'];
    paidAmount = json['paid_amount'];
    pendingAmount = json['pending_amount'];

    feeStatus = json['fee_status'];
  }
}