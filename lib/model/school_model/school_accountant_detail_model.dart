class SchoolAccountantDetailModel {
  bool? success;
  Data? data;

  SchoolAccountantDetailModel({this.success, this.data});

  SchoolAccountantDetailModel.fromJson(Map<String, dynamic> json) {
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

// class Data {
//   dynamic accountantId;
//   dynamic schoolId;
//   dynamic userId;
//   dynamic qualification;
//   dynamic fatherName;
//   dynamic motherName;
//   dynamic mobileNumber;
//   dynamic experienceYears;
//   dynamic address;
//   dynamic status;
//   dynamic createdAt;
//   dynamic name;
//   dynamic userEmail;
//   dynamic accountantPhotoUrl;
//   dynamic aadharCardUrl;
//
//   Data(
//       {this.accountantId,
//         this.schoolId,
//         this.userId,
//         this.qualification,
//         this.fatherName,
//         this.motherName,
//         this.mobileNumber,
//         this.experienceYears,
//         this.address,
//         this.status,
//         this.createdAt,
//         this.name,
//         this.userEmail,
//         this.accountantPhotoUrl,
//         this.aadharCardUrl});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     accountantId = json['accountant_id'];
//     schoolId = json['school_id'];
//     userId = json['user_id'];
//     qualification = json['qualification'];
//     fatherName = json['father_name'];
//     motherName = json['mother_name'];
//     mobileNumber = json['mobile_number'];
//     experienceYears = json['experience_years'];
//     address = json['address'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     name = json['name'];
//     userEmail = json['user_email'];
//     accountantPhotoUrl = json['accountant_photo_url'];
//     aadharCardUrl = json['aadhar_card_url'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['accountant_id'] = accountantId;
//     data['school_id'] = schoolId;
//     data['user_id'] = userId;
//     data['qualification'] = qualification;
//     data['father_name'] = fatherName;
//     data['mother_name'] = motherName;
//     data['mobile_number'] = mobileNumber;
//     data['experience_years'] = experienceYears;
//     data['address'] = address;
//     data['status'] = status;
//     data['created_at'] = createdAt;
//     data['name'] = name;
//     data['user_email'] = userEmail;
//     data['accountant_photo_url'] = accountantPhotoUrl;
//     data['aadhar_card_url'] = aadharCardUrl;
//     return data;
//   }
// }
class Data {
  dynamic accountantId;
  dynamic schoolId;
  dynamic userId;
  dynamic qualification;
  dynamic fatherName;
  dynamic motherName;
  dynamic mobileNumber;
  dynamic dob;              // ✅ ADD
  dynamic employmentType;   // ✅ ADD
  dynamic joiningDate;      // ✅ ADD
  dynamic experienceYears;
  dynamic address;
  dynamic status;
  dynamic createdAt;
  dynamic name;
  dynamic userEmail;
  dynamic accountantPhotoUrl;
  dynamic aadharCardUrl;

  Data({
    this.accountantId,
    this.schoolId,
    this.userId,
    this.qualification,
    this.fatherName,
    this.motherName,
    this.mobileNumber,
    this.dob,              // ✅ ADD
    this.employmentType,   // ✅ ADD
    this.joiningDate,      // ✅ ADD
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
    accountantId       = json['accountant_id'];
    schoolId           = json['school_id'];
    userId             = json['user_id'];
    qualification      = json['qualification'];
    fatherName         = json['father_name'];
    motherName         = json['mother_name'];
    mobileNumber       = json['mobile_number'];
    dob                = json['dob'];               // ✅ ADD
    employmentType     = json['employment_type'];   // ✅ ADD
    joiningDate        = json['joining_date'];      // ✅ ADD
    experienceYears    = json['experience_years'];
    address            = json['address'];
    status             = json['status'];
    createdAt          = json['created_at'];
    name               = json['name'];
    userEmail          = json['user_email'];
    accountantPhotoUrl = json['accountant_photo_url'];
    aadharCardUrl      = json['aadhar_card_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountant_id']       = accountantId;
    data['school_id']           = schoolId;
    data['user_id']             = userId;
    data['qualification']       = qualification;
    data['father_name']         = fatherName;
    data['mother_name']         = motherName;
    data['mobile_number']       = mobileNumber;
    data['dob']                 = dob;              // ✅ ADD
    data['employment_type']     = employmentType;   // ✅ ADD
    data['joining_date']        = joiningDate;      // ✅ ADD
    data['experience_years']    = experienceYears;
    data['address']             = address;
    data['status']              = status;
    data['created_at']          = createdAt;
    data['name']                = name;
    data['user_email']          = userEmail;
    data['accountant_photo_url']= accountantPhotoUrl;
    data['aadhar_card_url']     = aadharCardUrl;
    return data;
  }
}