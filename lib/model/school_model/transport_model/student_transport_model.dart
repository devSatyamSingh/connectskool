class AdminStudentTransportModel {
  bool? success;
  dynamic message;
  Data? data;

  AdminStudentTransportModel({this.success, this.message, this.data});

  AdminStudentTransportModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  dynamic studentTransportId;
  dynamic studentId;
  dynamic academicYear;
  dynamic assignedOn;
  dynamic isActive;
  dynamic discontinuedOn;
  dynamic discontinueReason;
  dynamic transportRouteId;
  dynamic routeName;
  dynamic vehicleNo;
  dynamic driverName;
  dynamic driverPhone;
  dynamic transportRouteStopId;
  dynamic stopName;
  dynamic distanceKm;
  dynamic baseAmount;
  dynamic feeFrequency;
  dynamic studentTransportFeeId;
  dynamic assignedAmount;
  dynamic paidAmount;
  dynamic pendingAmount;
  dynamic feeStatus;

  Data({
    this.studentTransportId,
    this.studentId,
    this.academicYear,
    this.assignedOn,
    this.isActive,
    this.discontinuedOn,
    this.discontinueReason,
    this.transportRouteId,
    this.routeName,
    this.vehicleNo,
    this.driverName,
    this.driverPhone,
    this.transportRouteStopId,
    this.stopName,
    this.distanceKm,
    this.baseAmount,
    this.feeFrequency,
    this.studentTransportFeeId,
    this.assignedAmount,
    this.paidAmount,
    this.pendingAmount,
    this.feeStatus,
  });

  Data.fromJson(Map<String, dynamic> json) {
    studentTransportId = json['student_transport_id'];
    studentId = json['student_id'];
    academicYear = json['academic_year'];
    assignedOn = json['assigned_on'];
    isActive = json['is_active'];
    discontinuedOn = json['discontinued_on'];
    discontinueReason = json['discontinue_reason'];
    transportRouteId = json['transport_route_id'];
    routeName = json['route_name'];
    vehicleNo = json['vehicle_no'];
    driverName = json['driver_name'];
    driverPhone = json['driver_phone'];
    transportRouteStopId = json['transport_route_stop_id'];
    stopName = json['stop_name'];
    distanceKm = json['distance_km'];
    baseAmount = json['base_amount'];
    feeFrequency = json['fee_frequency'];
    studentTransportFeeId = json['student_transport_fee_id'];
    assignedAmount = json['assigned_amount'];
    paidAmount = json['paid_amount'];
    pendingAmount = json['pending_amount'];
    feeStatus = json['fee_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['student_transport_id'] = studentTransportId;
    data['student_id'] = studentId;
    data['academic_year'] = academicYear;
    data['assigned_on'] = assignedOn;
    data['is_active'] = isActive;
    data['discontinued_on'] = discontinuedOn;
    data['discontinue_reason'] = discontinueReason;
    data['transport_route_id'] = transportRouteId;
    data['route_name'] = routeName;
    data['vehicle_no'] = vehicleNo;
    data['driver_name'] = driverName;
    data['driver_phone'] = driverPhone;
    data['transport_route_stop_id'] = transportRouteStopId;
    data['stop_name'] = stopName;
    data['distance_km'] = distanceKm;
    data['base_amount'] = baseAmount;
    data['fee_frequency'] = feeFrequency;
    data['student_transport_fee_id'] = studentTransportFeeId;
    data['assigned_amount'] = assignedAmount;
    data['paid_amount'] = paidAmount;
    data['pending_amount'] = pendingAmount;
    data['fee_status'] = feeStatus;
    return data;
  }
}