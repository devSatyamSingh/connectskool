class AcademicModel {
  bool? success;
  String? message;
  List<AcademicData>? data;

  AcademicModel({this.success, this.message, this.data});

  AcademicModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AcademicData>[];
      json['data'].forEach((v) {
        data!.add(AcademicData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AcademicData {
  int? academicYearId;
  String? yearName;
  String? startDate;
  String? endDate;
  int? isCurrent;
  int? status;
  String? createdAt;

  AcademicData(
      {this.academicYearId,
        this.yearName,
        this.startDate,
        this.endDate,
        this.isCurrent,
        this.status,
        this.createdAt});

  AcademicData.fromJson(Map<String, dynamic> json) {
    academicYearId = json['academic_year_id'];
    yearName = json['year_name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    isCurrent = json['is_current'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['academic_year_id'] = academicYearId;
    data['year_name'] = yearName;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['is_current'] = isCurrent;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}
