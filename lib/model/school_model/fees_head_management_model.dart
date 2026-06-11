
class FeesHeadManagementModel {
  bool? success;
  Data? data;

  FeesHeadManagementModel({this.success, this.data});

  FeesHeadManagementModel.fromJson(Map<String, dynamic> json) {
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
  int? count;
  List<FeeHeads>? feeHeads;

  Data({this.count, this.feeHeads});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['fee_heads'] != null) {
      feeHeads = <FeeHeads>[];
      json['fee_heads'].forEach((v) {
        feeHeads!.add(FeeHeads.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (feeHeads != null) {
      data['fee_heads'] = feeHeads!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeeHeads {
  int? feeHeadId;
  int? schoolId;
  String? headName;
  String? description;
  int? status;

  FeeHeads(
      {this.feeHeadId,
        this.schoolId,
        this.headName,
        this.description,
        this.status});

  FeeHeads.fromJson(Map<String, dynamic> json) {
    feeHeadId = json['fee_head_id'];
    schoolId = json['school_id'];
    headName = json['head_name'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fee_head_id'] = feeHeadId;
    data['school_id'] = schoolId;
    data['head_name'] = headName;
    data['description'] = description;
    data['status'] = status;
    return data;
  }
}
