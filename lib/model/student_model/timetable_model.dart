class SchoolTimetableModel {
  bool? success;
  List<TimetableData>? data;

  SchoolTimetableModel({
    this.success,
    this.data,
  });

  factory SchoolTimetableModel.fromJson(
      Map<String,dynamic> json) {
    return SchoolTimetableModel(
      success: json['success'],
      data: json['data'] != null
          ? List<TimetableData>.from(
        json['data'].map(
              (x)=>TimetableData.fromJson(x),
        ),
      )
          : [],
    );
  }
}

class TimetableData {

  int? timetableId;
  String? dayOfWeek;
  String? startTime;
  String? endTime;
  String? className;
  String? sectionName;
  String? subjectName;
  String? teacherName;

  TimetableData({
    this.timetableId,
    this.dayOfWeek,
    this.startTime,
    this.endTime,
    this.className,
    this.sectionName,
    this.subjectName,
    this.teacherName,
  });

  factory TimetableData.fromJson(
      Map<String,dynamic> json) {

    return TimetableData(
      timetableId: json['timetable_id'],
      dayOfWeek: json['day_of_week'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      className: json['class_name'],
      sectionName: json['section_name'],
      subjectName: json['subject_name'],
      teacherName: json['teacher_name'],
    );
  }
}