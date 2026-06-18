// class SchoolTeachersDetailModel {
//   bool? success;
//   Data? data;
//
//   SchoolTeachersDetailModel({this.success, this.data});
//
//   SchoolTeachersDetailModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     data = json['data'] != null ? Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['success'] = success;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   dynamic teacherId;
//   dynamic schoolId;
//   dynamic userId;
//   dynamic qualification;
//   dynamic fatherName;
//   dynamic motherName;
//   dynamic mobileNumber;
//   dynamic address;
//   dynamic experienceYears;
//   dynamic joiningDate;
//   dynamic status;
//   dynamic createdAt;
//   dynamic updatedAt;
//   dynamic name;
//   dynamic userEmail;
//   dynamic teacherPhotoUrl;
//   dynamic aadharCardUrl;
//
//   Data(
//       {this.teacherId,
//         this.schoolId,
//         this.userId,
//         this.qualification,
//         this.fatherName,
//         this.motherName,
//         this.mobileNumber,
//         this.address,
//         this.experienceYears,
//         this.joiningDate,
//         this.status,
//         this.createdAt,
//         this.updatedAt,
//         this.name,
//         this.userEmail,
//         this.teacherPhotoUrl,
//         this.aadharCardUrl});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     final map = Map<String, dynamic>.from(json);
//
//     teacherId = map['teacher_id'];
//     schoolId = map['school_id'];
//     userId = map['user_id'];
//     qualification = map['qualification'];
//     fatherName = map['father_name'];
//     motherName = map['mother_name'];
//     mobileNumber = map['mobile_number'];
//     address = map['address'];
//     experienceYears = map['experience_years'];
//     joiningDate = map['joining_date'];
//     status = map['status'];
//     createdAt = map['created_at'];
//     updatedAt = map['updated_at'];
//     name = map['name'];
//     userEmail = map['user_email'];
//     teacherPhotoUrl = map['teacher_photo_url'];
//     aadharCardUrl = map['aadhar_card_url'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['teacher_id'] = teacherId;
//     data['school_id'] = schoolId;
//     data['user_id'] = userId;
//     data['qualification'] = qualification;
//     data['father_name'] = fatherName;
//     data['mother_name'] = motherName;
//     data['mobile_number'] = mobileNumber;
//     data['address'] = address;
//     data['experience_years'] = experienceYears;
//     data['joining_date'] = joiningDate;
//     data['status'] = status;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['name'] = name;
//     data['user_email'] = userEmail;
//     data['teacher_photo_url'] = teacherPhotoUrl;
//     data['aadhar_card_url'] = aadharCardUrl;
//     return data;
//   }
// }
class SchoolTeachersDetailModel {
  bool? success;
  Data? data;

  SchoolTeachersDetailModel({this.success, this.data});

  SchoolTeachersDetailModel.fromJson(Map<String, dynamic> json) {
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
  dynamic teacherId;
  dynamic schoolId;
  dynamic userId;
  dynamic qualification;
  dynamic fatherName;
  dynamic motherName;
  dynamic mobileNumber;
  dynamic address;
  dynamic experienceYears;
  dynamic joiningDate;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic name;
  dynamic userEmail;
  dynamic teacherPhotoUrl;
  dynamic aadharCardUrl;
  dynamic employeeId;       // NEW
  dynamic gender;           // NEW
  dynamic dob;              // NEW
  dynamic employmentType;   // NEW
  dynamic designation;      // NEW

  Data({
    this.teacherId,
    this.schoolId,
    this.userId,
    this.qualification,
    this.fatherName,
    this.motherName,
    this.mobileNumber,
    this.address,
    this.experienceYears,
    this.joiningDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.userEmail,
    this.teacherPhotoUrl,
    this.aadharCardUrl,
    this.employeeId,
    this.gender,
    this.dob,
    this.employmentType,
    this.designation,
  });

  Data.fromJson(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);

    teacherId       = map['teacher_id'];
    schoolId        = map['school_id'];
    userId          = map['user_id'];
    qualification   = map['qualification'];
    fatherName      = map['father_name'];
    motherName      = map['mother_name'];
    mobileNumber    = map['mobile_number'];
    address         = map['address'];
    experienceYears = map['experience_years'];
    joiningDate     = map['joining_date'];
    status          = map['status'];
    createdAt       = map['created_at'];
    updatedAt       = map['updated_at'];
    name            = map['name'];
    userEmail       = map['user_email'];
    teacherPhotoUrl = map['teacher_photo_url'];
    aadharCardUrl   = map['aadhar_card_url'];
    employeeId      = map['employee_id'];     // NEW
    gender          = map['gender'];          // NEW
    dob             = map['dob'];             // NEW
    employmentType  = map['employment_type']; // NEW
    designation     = map['designation'];     // NEW
  }

  Map<String, dynamic> toJson() {
    return {
      'teacher_id'       : teacherId,
      'school_id'        : schoolId,
      'user_id'          : userId,
      'qualification'    : qualification,
      'father_name'      : fatherName,
      'mother_name'      : motherName,
      'mobile_number'    : mobileNumber,
      'address'          : address,
      'experience_years' : experienceYears,
      'joining_date'     : joiningDate,
      'status'           : status,
      'created_at'       : createdAt,
      'updated_at'       : updatedAt,
      'name'             : name,
      'user_email'       : userEmail,
      'teacher_photo_url': teacherPhotoUrl,
      'aadhar_card_url'  : aadharCardUrl,
      'employee_id'      : employeeId,
      'gender'           : gender,
      'dob'              : dob,
      'employment_type'  : employmentType,
      'designation'      : designation,
    };
  }
}