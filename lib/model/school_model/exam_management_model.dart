// class ExamManagementModel {
//   bool? success;
//   List<Data>? data;
//
//   ExamManagementModel({this.success, this.data});
//
//   ExamManagementModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['success'] = success;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data {
//   dynamic examId;
//   dynamic schoolId;
//   dynamic examTypeId;
//   dynamic examName;
//   dynamic academicYear;
//   dynamic startDate;
//   dynamic endDate;
//   dynamic resultDate;
//   dynamic status;
//   dynamic createdAt;
//   dynamic updatedAt;
//   dynamic deletedAt;
//   dynamic typeName;
//
//   Data(
//       {this.examId,
//         this.schoolId,
//         this.examTypeId,
//         this.examName,
//         this.academicYear,
//         this.startDate,
//         this.endDate,
//         this.resultDate,
//         this.status,
//         this.createdAt,
//         this.updatedAt,
//         this.deletedAt,
//         this.typeName});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     examId = json['exam_id'];
//     schoolId = json['school_id'];
//     examTypeId = json['exam_type_id'];
//     examName = json['exam_name'];
//     academicYear = json['academic_year'];
//     startDate = json['start_date'];
//     endDate = json['end_date'];
//     resultDate = json['result_date'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     deletedAt = json['deleted_at'];
//     typeName = json['type_name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['exam_id'] = examId;
//     data['school_id'] = schoolId;
//     data['exam_type_id'] = examTypeId;
//     data['exam_name'] = examName;
//     data['academic_year'] = academicYear;
//     data['start_date'] = startDate;
//     data['end_date'] = endDate;
//     data['result_date'] = resultDate;
//     data['status'] = status;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['deleted_at'] = deletedAt;
//     data['type_name'] = typeName;
//     return data;
//   }
// }
class ExamManagementModel {
  bool? success;
  List<Data>? data;

  ExamManagementModel({this.success, this.data});

  ExamManagementModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  dynamic examId;
  dynamic schoolId;
  dynamic examTypeId;
  dynamic examName;
  dynamic term;                  // ✅ ADD
  dynamic weightagePercentage;   // ✅ ADD
  dynamic academicYear;
  dynamic startDate;
  dynamic endDate;
  dynamic resultDate;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  dynamic typeName;

  Data({
    this.examId,
    this.schoolId,
    this.examTypeId,
    this.examName,
    this.term,                   // ✅ ADD
    this.weightagePercentage,    // ✅ ADD
    this.academicYear,
    this.startDate,
    this.endDate,
    this.resultDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.typeName,
  });

  Data.fromJson(Map<String, dynamic> json) {
    examId             = json['exam_id'];
    schoolId           = json['school_id'];
    examTypeId         = json['exam_type_id'];
    examName           = json['exam_name'];
    term               = json['term'];                   // ✅ ADD
    weightagePercentage = json['weightage_percentage'];  // ✅ ADD
    academicYear       = json['academic_year'];
    startDate          = json['start_date'];
    endDate            = json['end_date'];
    resultDate         = json['result_date'];
    status             = json['status'];
    createdAt          = json['created_at'];
    updatedAt          = json['updated_at'];
    deletedAt          = json['deleted_at'];
    typeName           = json['type_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['exam_id']              = examId;
    data['school_id']            = schoolId;
    data['exam_type_id']         = examTypeId;
    data['exam_name']            = examName;
    data['term']                 = term;                  // ✅ ADD
    data['weightage_percentage'] = weightagePercentage;   // ✅ ADD
    data['academic_year']        = academicYear;
    data['start_date']           = startDate;
    data['end_date']             = endDate;
    data['result_date']          = resultDate;
    data['status']               = status;
    data['created_at']           = createdAt;
    data['updated_at']           = updatedAt;
    data['deleted_at']           = deletedAt;
    data['type_name']            = typeName;
    return data;
  }
}