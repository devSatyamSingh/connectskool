class FeesManagementModel {
  bool? success;
  Data? data;

  FeesManagementModel({this.success, this.data});

  FeesManagementModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  dynamic count;
  List<Fees>? fees;

  Data({this.count, this.fees});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['fees'] != null) {
      fees = <Fees>[];
      json['fees'].forEach((v) {
        fees!.add(Fees.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (fees != null) {
      data['fees'] = fees!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Fees {
  dynamic feeId;
  dynamic schoolId;
  dynamic classId;
  dynamic feeHeadId;
  dynamic feeHeadName;
  dynamic className;
  dynamic baseAmount;
  dynamic feeFrequency;
  dynamic totalAmount;
  dynamic academicYear;
  dynamic status;
  dynamic createdAt;

  Fees(
      {this.feeId,
        this.schoolId,
        this.classId,
        this.feeHeadId,
        this.feeHeadName,
        this.className,
        this.baseAmount,
        this.feeFrequency,
        this.totalAmount,
        this.academicYear,
        this.status,
        this.createdAt});

  Fees.fromJson(Map<String, dynamic> json) {
    feeId = json['fee_id'];
    schoolId = json['school_id'];
    classId = json['class_id'];
    feeHeadId = json['fee_head_id'];
    feeHeadName = json['fee_head_name'];
    className = json['class_name'];
    baseAmount = json['base_amount'];
    feeFrequency = json['fee_frequency'];
    totalAmount = json['total_amount'];
    academicYear = json['academic_year'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fee_id'] = feeId;
    data['school_id'] = schoolId;
    data['class_id'] = classId;
    data['fee_head_id'] = feeHeadId;
    data['fee_head_name'] = feeHeadName;
    data['class_name'] = className;
    data['base_amount'] = baseAmount;
    data['fee_frequency'] = feeFrequency;
    data['total_amount'] = totalAmount;
    data['academic_year'] = academicYear;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}
