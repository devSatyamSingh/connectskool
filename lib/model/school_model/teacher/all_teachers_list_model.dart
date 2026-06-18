class AllTeachersListModel {
  final bool? success;
  final String? message;
  final List<AllTeacherModel> data;
  final Pagination? pagination;

  AllTeachersListModel({
    this.success,
    this.message,
    this.data = const [],
    this.pagination,
  });

  factory AllTeachersListModel.fromJson(Map<String, dynamic> json) {
    return AllTeachersListModel(
      success: json['success'],
      message: json['message']?.toString(),
      data: json['data'] != null
          ? List<AllTeacherModel>.from(
          json['data'].map((v) => AllTeacherModel.fromJson(v)))
          : [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((v) => v.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

class AllTeacherModel {
  final int? userId;
  final String? name;
  final String? userEmail;
  final int? status;
  final int? teacherId;
  final int? schoolId;
  final String? qualification;
  final String? fatherName;
  final String? motherName;
  final String? mobileNumber;
  final String? address;
  final int? experienceYears;
  final String? joiningDate;
  final String? employeeId;
  final String? gender;
  final String? dob;
  final String? employmentType;
  final String? designation;
  final String? teacherPhotoUrl;
  final String? aadharCardUrl;

  AllTeacherModel({
    this.userId,
    this.name,
    this.userEmail,
    this.status,
    this.teacherId,
    this.schoolId,
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
    this.teacherPhotoUrl,
    this.aadharCardUrl,
  });

  factory AllTeacherModel.fromJson(Map<String, dynamic> json) {
    return AllTeacherModel(
      userId: json['user_id'],
      name: json['name'],
      userEmail: json['user_email'],
      status: json['status'],
      teacherId: json['teacher_id'],
      schoolId: json['school_id'],
      qualification: json['qualification'],
      fatherName: json['father_name'],
      motherName: json['mother_name'],
      mobileNumber: json['mobile_number'],
      address: json['address'],
      experienceYears: json['experience_years'],
      joiningDate: json['joining_date'],
      employeeId: json['employee_id'],
      gender: json['gender'],
      dob: json['dob'],
      employmentType: json['employment_type'],
      designation: json['designation'],
      teacherPhotoUrl: json['teacher_photo_url'],
      aadharCardUrl: json['aadhar_card_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'user_email': userEmail,
      'status': status,
      'teacher_id': teacherId,
      'school_id': schoolId,
      'qualification': qualification,
      'father_name': fatherName,
      'mother_name': motherName,
      'mobile_number': mobileNumber,
      'address': address,
      'experience_years': experienceYears,
      'joining_date': joiningDate,
      'employee_id': employeeId,
      'gender': gender,
      'dob': dob,
      'employment_type': employmentType,
      'designation': designation,
      'teacher_photo_url': teacherPhotoUrl,
      'aadhar_card_url': aadharCardUrl,
    };
  }
}

class Pagination {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  Pagination({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
    };
  }
}