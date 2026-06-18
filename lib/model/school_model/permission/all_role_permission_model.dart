class AllRolePermissionsModel {
  bool? success;
  String? message;
  Data? data;

  AllRolePermissionsModel({this.success, this.message, this.data});

  AllRolePermissionsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "data": data?.toJson(),
    };
  }
}

class Data {
  List<PermissionItem>? accountant;
  List<PermissionItem>? classes;
  List<PermissionItem>? fees;
  List<PermissionItem>? homework;
  List<PermissionItem>? notices;
  List<PermissionItem>? notification;
  List<PermissionItem>? payments;
  List<PermissionItem>? reports;
  List<PermissionItem>? school;
  List<PermissionItem>? sections;
  List<PermissionItem>? settings;
  List<PermissionItem>? students;
  List<PermissionItem>? subjects;
  List<PermissionItem>? teacher;
  List<PermissionItem>? teachers;
  List<PermissionItem>? timetable;

  Data({
    this.accountant,
    this.classes,
    this.fees,
    this.homework,
    this.notices,
    this.notification,
    this.payments,
    this.reports,
    this.school,
    this.sections,
    this.settings,
    this.students,
    this.subjects,
    this.teacher,
    this.teachers,
    this.timetable,
  });

  Data.fromJson(Map<String, dynamic> json) {
    accountant = _parseList(json['accountant']);
    classes = _parseList(json['classes']);
    fees = _parseList(json['fees']);
    homework = _parseList(json['homework']);
    notices = _parseList(json['notices']);
    notification = _parseList(json['notification']);
    payments = _parseList(json['payments']);
    reports = _parseList(json['reports']);
    school = _parseList(json['school']);
    sections = _parseList(json['sections']);
    settings = _parseList(json['settings']);
    students = _parseList(json['students']);
    subjects = _parseList(json['subjects']);
    teacher = _parseList(json['teacher']);
    teachers = _parseList(json['teachers']);
    timetable = _parseList(json['timetable']);
  }

  List<PermissionItem>? _parseList(dynamic jsonList) {
    if (jsonList == null) return null;
    return List<PermissionItem>.from(
      jsonList.map((e) => PermissionItem.fromJson(e)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "accountant": accountant?.map((e) => e.toJson()).toList(),
      "classes": classes?.map((e) => e.toJson()).toList(),
      "fees": fees?.map((e) => e.toJson()).toList(),
      "homework": homework?.map((e) => e.toJson()).toList(),
      "notices": notices?.map((e) => e.toJson()).toList(),
      "notification": notification?.map((e) => e.toJson()).toList(),
      "payments": payments?.map((e) => e.toJson()).toList(),
      "reports": reports?.map((e) => e.toJson()).toList(),
      "school": school?.map((e) => e.toJson()).toList(),
      "sections": sections?.map((e) => e.toJson()).toList(),
      "settings": settings?.map((e) => e.toJson()).toList(),
      "students": students?.map((e) => e.toJson()).toList(),
      "subjects": subjects?.map((e) => e.toJson()).toList(),
      "teacher": teacher?.map((e) => e.toJson()).toList(),
      "teachers": teachers?.map((e) => e.toJson()).toList(),
      "timetable": timetable?.map((e) => e.toJson()).toList(),
    };
  }
}

class PermissionItem {
  int? permissionId;
  String? key;
  String? description;

  PermissionItem({
    this.permissionId,
    this.key,
    this.description,
  });

  PermissionItem.fromJson(Map<String, dynamic> json) {
    permissionId = json['permission_id'];
    key = json['key'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    return {
      "permission_id": permissionId,
      "key": key,
      "description": description,
    };
  }
}
