class AccountantProfileModel {
  bool? success;
  Data? data;

  AccountantProfileModel({this.success, this.data});

  AccountantProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['success'] = success;
    if (data != null) {
      dataMap['data'] = data!.toJson();
    }
    return dataMap;
  }
}

class Data {
  int? accountantId;
  int? schoolId;
  int? userId;
  String? qualification;
  String? fatherName;
  String? motherName;
  String? mobileNumber;
  int? experienceYears;
  String? address;
  int? status;
  String? createdAt;
  String? name;
  String? userEmail;
  String? accountantPhotoUrl;
  String? aadharCardUrl;

  Data({
    this.accountantId,
    this.schoolId,
    this.userId,
    this.qualification,
    this.fatherName,
    this.motherName,
    this.mobileNumber,
    this.experienceYears,
    this.address,
    this.status,
    this.createdAt,
    this.name,
    this.userEmail,
    this.accountantPhotoUrl,
    this.aadharCardUrl,
  });

  Data.fromJson(Map<String, dynamic> json) {
    accountantId = json['accountant_id'];
    schoolId = json['school_id'];
    userId = json['user_id'];
    qualification = json['qualification'];
    fatherName = json['father_name'];
    motherName = json['mother_name'];
    mobileNumber = json['mobile_number'];
    experienceYears = json['experience_years'];
    address = json['address'];
    status = json['status'];
    createdAt = json['created_at'];
    name = json['name'];
    userEmail = json['user_email'];
    accountantPhotoUrl = json['accountant_photo_url'];
    aadharCardUrl = json['aadhar_card_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['accountant_id'] = accountantId;
    dataMap['school_id'] = schoolId;
    dataMap['user_id'] = userId;
    dataMap['qualification'] = qualification;
    dataMap['father_name'] = fatherName;
    dataMap['mother_name'] = motherName;
    dataMap['mobile_number'] = mobileNumber;
    dataMap['experience_years'] = experienceYears;
    dataMap['address'] = address;
    dataMap['status'] = status;
    dataMap['created_at'] = createdAt;
    dataMap['name'] = name;
    dataMap['user_email'] = userEmail;
    dataMap['accountant_photo_url'] = accountantPhotoUrl;
    dataMap['aadhar_card_url'] = aadharCardUrl;
    return dataMap;
  }
}