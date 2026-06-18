class AllSubjectsModel {
  bool? success;
  List<Data>? data;

  AllSubjectsModel({this.success, this.data});

  AllSubjectsModel.fromJson(Map<String, dynamic> json) {
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
  int? subjectId;
  String? subjectName;
  String? assessmentModel;
  int? status;

  Data({this.subjectId, this.subjectName, this.assessmentModel, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    assessmentModel = json['assessment_model'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject_id'] = subjectId;
    data['subject_name'] = subjectName;
    data['assessment_model'] = assessmentModel;
    data['status'] = status;
    return data;
  }
}
