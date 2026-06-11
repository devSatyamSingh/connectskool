class AllStudentListModel {
  bool? success;
  dynamic message;
  List<StudentData>? data;
  Pagination? pagination;

  AllStudentListModel({this.success, this.message, this.data, this.pagination});

  AllStudentListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StudentData>[];
      json['data'].forEach((v) {
        data!.add(StudentData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class StudentData {
  int? userId;
  dynamic name;
  dynamic userEmail;
  int? status;
  int? studentId;
  int? schoolId;
  int? classId;
  int? sectionId;
  dynamic admissionNo;
  dynamic rollNo;
  dynamic gender;
  dynamic dob;
  dynamic mobileNumber;
  dynamic fatherName;
  dynamic motherName;
  dynamic address;
  dynamic religion;
  dynamic academicYear;
  int? passedOut;
  int? transfer;
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
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  dynamic className;
  dynamic sectionName;
  dynamic studentPhotoUrl;
  dynamic fatherPhotoUrl;
  dynamic motherPhotoUrl;
  dynamic aadharCardUrl;

  StudentData(
      {this.userId,
        this.name,
        this.userEmail,
        this.status,
        this.studentId,
        this.schoolId,
        this.classId,
        this.sectionId,
        this.admissionNo,
        this.rollNo,
        this.gender,
        this.dob,
        this.mobileNumber,
        this.fatherName,
        this.motherName,
        this.address,
        this.religion,
        this.academicYear,
        this.passedOut,
        this.transfer,
        this.bloodGroup,
        this.category,
        this.aadharNumber,
        this.fatherOccupation,
        this.fatherMobile,
        this.motherOccupation,
        this.motherMobile,
        this.guardianName,
        this.emergencyContactNumber,
        this.city,
        this.state,
        this.pincode,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.className,
        this.sectionName,
        this.studentPhotoUrl,
        this.fatherPhotoUrl,
        this.motherPhotoUrl,
        this.aadharCardUrl});

  StudentData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    userEmail = json['user_email'];
    status = json['status'];
    studentId = json['student_id'];
    schoolId = json['school_id'];
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
    academicYear = json['academic_year'];
    passedOut = json['passed_out'];
    transfer = json['transfer'];
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    className = json['class_name'];
    sectionName = json['section_name'];
    studentPhotoUrl = json['student_photo_url'];
    fatherPhotoUrl = json['father_photo_url'];
    motherPhotoUrl = json['mother_photo_url'];
    aadharCardUrl = json['aadhar_card_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['user_email'] = userEmail;
    data['status'] = status;
    data['student_id'] = studentId;
    data['school_id'] = schoolId;
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
    data['academic_year'] = academicYear;
    data['passed_out'] = passedOut;
    data['transfer'] = transfer;
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
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['class_name'] = className;
    data['section_name'] = sectionName;
    data['student_photo_url'] = studentPhotoUrl;
    data['father_photo_url'] = fatherPhotoUrl;
    data['mother_photo_url'] = motherPhotoUrl;
    data['aadhar_card_url'] = aadharCardUrl;
    return data;
  }
}

class Pagination {
  int? page;
  int? limit;
  int? total;
  int? totalPages;

  Pagination({this.page, this.limit, this.total, this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    data['total'] = total;
    data['totalPages'] = totalPages;
    return data;
  }
}
