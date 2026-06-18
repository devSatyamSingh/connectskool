class AllAccountantListModel {
  bool? success;
  String? message;
  List<AccountantData>? data;
  Pagination? pagination;

  AllAccountantListModel({this.success, this.message, this.data, this.pagination});

  AllAccountantListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    if (json['data'] != null) {
      data = <AccountantData>[];
      json['data'].forEach((v) {
        data!.add(AccountantData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) map['data'] = data!.map((v) => v.toJson()).toList();
    if (pagination != null) map['pagination'] = pagination!.toJson();
    return map;
  }
}

// class AccountantData {
//   String? name;
//   String? userEmail;
//   int? status;
//   int? accountantId;
//   String? qualification;
//   String? accountantPhotoUrl;
//   String? aadharCardUrl;
//
//   AccountantData({
//     this.name,
//     this.userEmail,
//     this.status,
//     this.accountantId,
//     this.qualification,
//     this.accountantPhotoUrl,
//     this.aadharCardUrl,
//   });
//
//   AccountantData.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     userEmail = json['user_email'];
//     status = json['status'];
//     accountantId = json['accountant_id'];
//     qualification = json['qualification'];
//     accountantPhotoUrl = json['accountant_photo_url'];
//     aadharCardUrl = json['aadhar_card_url'];
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'user_email': userEmail,
//       'status': status,
//       'accountant_id': accountantId,
//       'qualification': qualification,
//       'accountant_photo_url': accountantPhotoUrl,
//       'aadhar_card_url': aadharCardUrl,
//     };
//   }
// }
class AccountantData {
  String? name;
  String? userEmail;
  int? status;
  int? accountantId;
  String? qualification;
  String? accountantPhotoUrl;
  String? aadharCardUrl;
  String? fatherName;
  String? motherName;
  String? mobileNumber;
  dynamic experienceYears;
  String? address;
  String? joiningDate;
  String? dob;              // ✅ ADD
  String? employmentType;   // ✅ ADD

  AccountantData({
    this.name,
    this.userEmail,
    this.status,
    this.accountantId,
    this.qualification,
    this.accountantPhotoUrl,
    this.aadharCardUrl,
    this.fatherName,
    this.motherName,
    this.mobileNumber,
    this.experienceYears,
    this.address,
    this.joiningDate,
    this.dob,             // ✅ ADD
    this.employmentType,  // ✅ ADD
  });

  AccountantData.fromJson(Map<String, dynamic> json) {
    name               = json['name'];
    userEmail          = json['user_email'];
    status             = json['status'];
    accountantId       = json['accountant_id'];
    qualification      = json['qualification'];
    accountantPhotoUrl = json['accountant_photo_url'];
    aadharCardUrl      = json['aadhar_card_url'];
    fatherName         = json['father_name'];
    motherName         = json['mother_name'];
    mobileNumber       = json['mobile_number'];
    experienceYears    = json['experience_years'];
    address            = json['address'];
    joiningDate        = json['joining_date'] ?? json['created_at'];
    dob                = json['dob'];              // ✅ ADD
    employmentType     = json['employment_type'];  // ✅ ADD
  }

  Map<String, dynamic> toJson() {
    return {
      'name'                 : name,
      'user_email'           : userEmail,
      'status'               : status,
      'accountant_id'        : accountantId,
      'qualification'        : qualification,
      'accountant_photo_url' : accountantPhotoUrl,
      'aadhar_card_url'      : aadharCardUrl,
      'father_name'          : fatherName,
      'mother_name'          : motherName,
      'mobile_number'        : mobileNumber,
      'experience_years'     : experienceYears,
      'address'              : address,
      'joining_date'         : joiningDate,
      'dob'                  : dob,             // ✅ ADD
      'employment_type'      : employmentType,  // ✅ ADD
    };
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
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
    };
  }
}
