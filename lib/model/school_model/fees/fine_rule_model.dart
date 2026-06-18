class FineRuleModel {
  bool? success;
  Data? data;

  FineRuleModel({this.success, this.data});

  FineRuleModel.fromJson(Map<String, dynamic> json) {
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
  List<FineRules>? fineRules;

  Data({this.count, this.fineRules});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['fine_rules'] != null) {
      fineRules = <FineRules>[];
      json['fine_rules'].forEach((v) {
        fineRules!.add(FineRules.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (fineRules != null) {
      data['fine_rules'] = fineRules!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FineRules {
  dynamic fineRuleId;
  dynamic schoolId;
  dynamic ruleName;
  dynamic fineType;
  dynamic fineAmount;
  dynamic gracePeriodDays;
  dynamic maxFineCap;
  dynamic applicableTo;
  dynamic feeHeadId;
  dynamic feeHeadName;
  dynamic status;

  FineRules(
      {this.fineRuleId,
        this.schoolId,
        this.ruleName,
        this.fineType,
        this.fineAmount,
        this.gracePeriodDays,
        this.maxFineCap,
        this.applicableTo,
        this.feeHeadId,
        this.feeHeadName,
        this.status});

  FineRules.fromJson(Map<String, dynamic> json) {
    fineRuleId = json['fine_rule_id'];
    schoolId = json['school_id'];
    ruleName = json['rule_name'];
    fineType = json['fine_type'];
    fineAmount = json['fine_amount'];
    gracePeriodDays = json['grace_period_days'];
    maxFineCap = json['max_fine_cap'];
    applicableTo = json['applicable_to'];
    feeHeadId = json['fee_head_id'];
    feeHeadName = json['fee_head_name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fine_rule_id'] = fineRuleId;
    data['school_id'] = schoolId;
    data['rule_name'] = ruleName;
    data['fine_type'] = fineType;
    data['fine_amount'] = fineAmount;
    data['grace_period_days'] = gracePeriodDays;
    data['max_fine_cap'] = maxFineCap;
    data['applicable_to'] = applicableTo;
    data['fee_head_id'] = feeHeadId;
    data['fee_head_name'] = feeHeadName;
    data['status'] = status;
    return data;
  }
}
