class StudentProfileModel {
  bool? success;
  dynamic message;
  Data? data;

  StudentProfileModel({this.success, this.message, this.data});

  StudentProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(
        Map<String, dynamic>.from(json['data'])
    ) : null;
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
  dynamic studentId;
  dynamic schoolId;
  dynamic userId;
  dynamic classId;
  dynamic sectionId;
  dynamic admissionNo;
  dynamic rollNo;
  dynamic gender;
  dynamic dob;
  dynamic mobileNumber;
  dynamic fatherName;
  dynamic motherName;
  dynamic address;
  dynamic religion;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  dynamic name;
  dynamic userEmail;
  dynamic studentPhotoUrl;
  dynamic fatherPhotoUrl;
  dynamic motherPhotoUrl;
  dynamic aadharCardUrl;
  dynamic academicYear;
  dynamic bloodGroup;
  dynamic category;
  dynamic aadharNumber;
  dynamic fatherOccupation;
  dynamic fatherMobile;
  dynamic motherOccupation;
  dynamic motherMobile;
  dynamic guardianName;
  dynamic emergencyContactNumber;
  dynamic city;
  dynamic state;
  dynamic pincode;
  dynamic className;
  dynamic sectionName;

  Data({
    this.studentId, this.schoolId, this.userId, this.classId, this.sectionId,
    this.admissionNo, this.rollNo, this.gender, this.dob, this.mobileNumber,
    this.fatherName, this.motherName, this.address, this.religion, this.status,
    this.createdAt, this.updatedAt, this.deletedAt, this.name, this.userEmail,
    this.studentPhotoUrl, this.fatherPhotoUrl, this.motherPhotoUrl, this.aadharCardUrl,
    this.academicYear, this.bloodGroup, this.category, this.aadharNumber,
    this.fatherOccupation, this.fatherMobile, this.motherOccupation,
    this.motherMobile, this.guardianName, this.emergencyContactNumber,
    this.city, this.state, this.pincode,this.className,
    this.sectionName,
  });

  Data.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id'];
    schoolId = json['school_id'];
    userId = json['user_id'];
    classId = json['class_id'];
    sectionId = json['section_id'];
    admissionNo = json['admission_no'];
    rollNo = json['roll_no'];
    gender = json['gender'];
    dob = json['dob'];
    mobileNumber = json['mobile_number'];
    fatherName = json['father_name'];
    motherName = json['mother_name'];
    address = json['address'];
    religion = json['religion'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    name = json['name'];
    userEmail = json['user_email'];
    studentPhotoUrl = json['student_photo_url'];
    fatherPhotoUrl = json['father_photo_url'];
    motherPhotoUrl = json['mother_photo_url'];
    aadharCardUrl = json['aadhar_card_url'];
    academicYear = json['academic_year'];
    bloodGroup = json['blood_group'];
    category = json['category'];
    aadharNumber = json['aadhar_number'];
    fatherOccupation = json['father_occupation'];
    fatherMobile = json['father_mobile'];
    motherOccupation = json['mother_occupation'];
    motherMobile = json['mother_mobile'];
    guardianName = json['guardian_name'];
    emergencyContactNumber = json['emergency_contact_number'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    className = json['class_name'];
    sectionName = json['section_name'];
  }

  // ✅ toJson me bhi naye fields add kiye
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['student_id'] = studentId;
    data['school_id'] = schoolId;
    data['user_id'] = userId;
    data['class_id'] = classId;
    data['section_id'] = sectionId;
    data['admission_no'] = admissionNo;
    data['roll_no'] = rollNo;
    data['gender'] = gender;
    data['dob'] = dob;
    data['mobile_number'] = mobileNumber;
    data['father_name'] = fatherName;
    data['mother_name'] = motherName;
    data['address'] = address;
    data['religion'] = religion;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['name'] = name;
    data['user_email'] = userEmail;
    data['student_photo_url'] = studentPhotoUrl;
    data['father_photo_url'] = fatherPhotoUrl;
    data['mother_photo_url'] = motherPhotoUrl;
    data['aadhar_card_url'] = aadharCardUrl;
    data['academic_year'] = academicYear;
    data['blood_group'] = bloodGroup;
    data['category'] = category;
    data['aadhar_number'] = aadharNumber;
    data['father_occupation'] = fatherOccupation;
    data['father_mobile'] = fatherMobile;
    data['mother_occupation'] = motherOccupation;
    data['mother_mobile'] = motherMobile;
    data['guardian_name'] = guardianName;
    data['emergency_contact_number'] = emergencyContactNumber;
    data['city'] = city;
    data['state'] = state;
    data['pincode'] = pincode;
    data['class_name'] = className;
    data['section_name'] = sectionName;
    return data;
  }
}