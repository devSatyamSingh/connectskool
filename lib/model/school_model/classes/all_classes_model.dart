class AllClassesModel {
  bool? success;
  List<Data>? data;

  AllClassesModel({this.success, this.data});

  AllClassesModel.fromJson(Map<String, dynamic> json) {
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
  int? classId;
  String? className;
  String? classCode;
  int? status;

  Data({this.classId, this.className, this.classCode, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    classId = json['class_id'];
    className = json['class_name'];
    classCode = json['class_code'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['class_id'] = classId;
    data['class_name'] = className;
    data['class_code'] = classCode;
    data['status'] = status;
    return data;
  }
}
