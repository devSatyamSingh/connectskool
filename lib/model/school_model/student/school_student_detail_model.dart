class SchoolStudentDetailModel {
  bool? success;
  dynamic message;
  Data? data;

  SchoolStudentDetailModel({this.success, this.message, this.data});

  SchoolStudentDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  // ── Core IDs ──
  dynamic studentId;
  dynamic schoolId;
  dynamic userId;
  dynamic classId;
  dynamic sectionId;
// ── Class & Section Name ──
  dynamic className;
  dynamic sectionName;
  // ── Academic ──
  dynamic admissionNo;
  dynamic rollNo;
  dynamic academicYear;
  dynamic passedOut;
  dynamic transfer;

  // ── Personal ──
  dynamic gender;
  dynamic dob;
  dynamic mobileNumber;
  dynamic address;
  dynamic religion;
  dynamic bloodGroup;
  dynamic category;
  dynamic city;
  dynamic state;
  dynamic pincode;
  dynamic aadharNumber;
  List<String>? feeHeads;

  // ── Family ──
  dynamic fatherName;
  dynamic fatherOccupation;
  dynamic fatherMobile;
  dynamic motherName;
  dynamic motherOccupation;
  dynamic motherMobile;
  dynamic guardianName;
  dynamic emergencyContactNumber;

  // ── Status & Timestamps ──
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;

  // ── User Info ──
  dynamic name;
  dynamic userEmail;

  // ── Media URLs ──
  dynamic studentPhotoUrl;
  dynamic fatherPhotoUrl;
  dynamic motherPhotoUrl;
  dynamic aadharCardUrl;

  Data({
    this.studentId,
    this.schoolId,
    this.userId,
    this.classId,
    this.sectionId,
    this.admissionNo,
    this.rollNo,
    this.academicYear,
    this.passedOut,
    this.transfer,
    this.gender,
    this.dob,
    this.className,
    this.sectionName,
    this.mobileNumber,
    this.address,
    this.religion,
    this.bloodGroup,
    this.category,
    this.city,
    this.state,
    this.pincode,
    this.feeHeads,
    this.aadharNumber,
    this.fatherName,
    this.fatherOccupation,
    this.fatherMobile,
    this.motherName,
    this.motherOccupation,
    this.motherMobile,
    this.guardianName,
    this.emergencyContactNumber,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.name,
    this.userEmail,
    this.studentPhotoUrl,
    this.fatherPhotoUrl,
    this.motherPhotoUrl,
    this.aadharCardUrl,
  });

  Data.fromJson(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);

    studentId              = map['student_id'];
    schoolId               = map['school_id'];
    userId                 = map['user_id'];
    classId                = map['class_id'];
    sectionId              = map['section_id'];
    admissionNo            = map['admission_no'];
    rollNo                 = map['roll_no'];
    academicYear           = map['academic_year'];
    passedOut              = map['passed_out'];
    transfer               = map['transfer'];
    gender                 = map['gender'];
    className   = map['class_name'];
    sectionName = map['section_name'];
    dob                    = map['dob'];
    mobileNumber           = map['mobile_number'];
    address                = map['address'];
    religion               = map['religion'];
    bloodGroup             = map['blood_group'];
    category               = map['category'];
    city                   = map['city'];
    state                  = map['state'];
    pincode                = map['pincode'];
    aadharNumber           = map['aadhar_number'];
    fatherName             = map['father_name'];
    fatherOccupation       = map['father_occupation'];
    fatherMobile           = map['father_mobile'];
    motherName             = map['mother_name'];
    motherOccupation       = map['mother_occupation'];
    motherMobile           = map['mother_mobile'];
    guardianName           = map['guardian_name'];
    emergencyContactNumber = map['emergency_contact_number'];
    status                 = map['status'];
    createdAt              = map['created_at'];
    updatedAt              = map['updated_at'];
    deletedAt              = map['deleted_at'];
    name                   = map['name'];
    userEmail              = map['user_email'];
    studentPhotoUrl        = map['student_photo_url'];
    fatherPhotoUrl         = map['father_photo_url'];
    motherPhotoUrl         = map['mother_photo_url'];
    aadharCardUrl          = map['aadhar_card_url'];
    feeHeads = json["fee_heads"] != null
        ? List<String>.from(json["fee_heads"])
        : [];
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id'               : studentId,
      'school_id'                : schoolId,
      'user_id'                  : userId,
      'class_id'                 : classId,
      'section_id'               : sectionId,
      'admission_no'             : admissionNo,
      'roll_no'                  : rollNo,
      'academic_year'            : academicYear,
      'passed_out'               : passedOut,
      'transfer'                 : transfer,
      'gender'                   : gender,
      'class_name'   : className,
      'section_name' : sectionName,
      'dob'                      : dob,
      'mobile_number'            : mobileNumber,
      'address'                  : address,
      'religion'                 : religion,
      'blood_group'              : bloodGroup,
      'category'                 : category,
      'city'                     : city,
      'state'                    : state,
      'pincode'                  : pincode,
      'aadhar_number'            : aadharNumber,
      'father_name'              : fatherName,
      'father_occupation'        : fatherOccupation,
      'father_mobile'            : fatherMobile,
      'mother_name'              : motherName,
      'mother_occupation'        : motherOccupation,
      'mother_mobile'            : motherMobile,
      'guardian_name'            : guardianName,
      'emergency_contact_number' : emergencyContactNumber,
      'status'                   : status,
      'created_at'               : createdAt,
      'updated_at'               : updatedAt,
      'deleted_at'               : deletedAt,
      'name'                     : name,
      'user_email'               : userEmail,
      'student_photo_url'        : studentPhotoUrl,
      'father_photo_url'         : fatherPhotoUrl,
      'mother_photo_url'         : motherPhotoUrl,
      'aadhar_card_url'          : aadharCardUrl,
      'fee_heads': feeHeads,
    };
  }
}