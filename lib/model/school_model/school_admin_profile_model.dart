class SchoolAdminProfileModel {
  bool? success;
  Data? data;

  SchoolAdminProfileModel({this.success, this.data});

  SchoolAdminProfileModel.fromJson(Map<String, dynamic> json) {
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
  dynamic userId;
  dynamic name;
  dynamic userEmail;
  dynamic role;
  dynamic userStatus;
  dynamic adminId;
  dynamic adminStatus;
  dynamic schoolId;
  dynamic schoolName;
  dynamic schoolEmail;
  dynamic schoolPhoneNumber;
  dynamic schoolAdrees;

  Data(
      {this.userId,
        this.name,
        this.userEmail,
        this.role,
        this.userStatus,
        this.adminId,
        this.adminStatus,
        this.schoolId,
        this.schoolName,
        this.schoolEmail,
        this.schoolPhoneNumber,
        this.schoolAdrees});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    userEmail = json['user_email'];
    role = json['role'];
    userStatus = json['user_status'];
    adminId = json['admin_id'];
    adminStatus = json['admin_status'];
    schoolId = json['school_id'];
    schoolName = json['school_name'];
    schoolEmail = json['school_email'];
    schoolPhoneNumber = json['school_phone_number'];
    schoolAdrees = json['school_adrees'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['user_email'] = userEmail;
    data['role'] = role;
    data['user_status'] = userStatus;
    data['admin_id'] = adminId;
    data['admin_status'] = adminStatus;
    data['school_id'] = schoolId;
    data['school_name'] = schoolName;
    data['school_email'] = schoolEmail;
    data['school_phone_number'] = schoolPhoneNumber;
    data['school_adrees'] = schoolAdrees;
    return data;
  }
}
