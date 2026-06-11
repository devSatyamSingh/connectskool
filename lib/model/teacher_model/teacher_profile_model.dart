class TeacherProfileModel {
  bool? success;
  Data? data;

  TeacherProfileModel({this.success, this.data});

  TeacherProfileModel.fromJson(Map<String, dynamic> json) {
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
  dynamic employeeId;
  dynamic gender;
  dynamic dob;
  dynamic employmentType;
  dynamic designation;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic name;
  dynamic userEmail;
  dynamic teacherPhotoUrl;
  dynamic aadharCardUrl;

  Data(
      {this.teacherId,
        this.schoolId,
        this.userId,
        this.qualification,
        this.fatherName,
        this.motherName,
        this.mobileNumber,
        this.address,
        this.experienceYears,
        this.joiningDate,
        this.employeeId,
        this.gender,
        this.dob,
        this.employmentType,
        this.designation,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.userEmail,
        this.teacherPhotoUrl,
        this.aadharCardUrl});

  Data.fromJson(Map<String, dynamic> json) {
    teacherId = json['teacher_id'];
    schoolId = json['school_id'];
    userId = json['user_id'];
    qualification = json['qualification'];
    fatherName = json['father_name'];
    motherName = json['mother_name'];
    mobileNumber = json['mobile_number'];
    address = json['address'];
    experienceYears = json['experience_years'];
    joiningDate = json['joining_date'];
    employeeId = json['employee_id'];
    gender = json['gender'];
    dob = json['dob'];
    employmentType = json['employment_type'];
    designation = json['designation'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    userEmail = json['user_email'];
    teacherPhotoUrl = json['teacher_photo_url'];
    aadharCardUrl = json['aadhar_card_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['teacher_id'] = teacherId;
    data['school_id'] = schoolId;
    data['user_id'] = userId;
    data['qualification'] = qualification;
    data['father_name'] = fatherName;
    data['mother_name'] = motherName;
    data['mobile_number'] = mobileNumber;
    data['address'] = address;
    data['experience_years'] = experienceYears;
    data['joining_date'] = joiningDate;
    data['employee_id'] = employeeId;
    data['gender'] = gender;
    data['dob'] = dob;
    data['employment_type'] = employmentType;
    data['designation'] = designation;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['name'] = name;
    data['user_email'] = userEmail;
    data['teacher_photo_url'] = teacherPhotoUrl;
    data['aadhar_card_url'] = aadharCardUrl;
    return data;
  }
}
