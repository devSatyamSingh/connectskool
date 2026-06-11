class TimetableModel {
  final bool? success;
  final List<TimetableData>? data;

  TimetableModel({this.success, this.data});

  factory TimetableModel.fromJson(Map<String, dynamic> json) {
    return TimetableModel(
      success: json['success'],
      data: json['data'] != null
          ? List<TimetableData>.from(
          json['data'].map((e) => TimetableData.fromJson(e)))
          : [],
    );
  }
}

class TimetableData {
  final dynamic timetableId;
  final dynamic dayOfWeek;
  final dynamic startTime;
  final dynamic endTime;
  final dynamic classId;
  final dynamic className;
  final dynamic sectionId;
  final dynamic sectionName;
  final dynamic subjectId;
  final dynamic subjectName;
  final dynamic teacherId;
  final dynamic teacherName;

  TimetableData({
    this.timetableId,
    this.dayOfWeek,
    this.startTime,
    this.endTime,
    this.classId,
    this.className,
    this.sectionId,
    this.sectionName,
    this.subjectId,
    this.subjectName,
    this.teacherId,
    this.teacherName,
  });

  factory TimetableData.fromJson(Map<String, dynamic> json) {
    return TimetableData(
      timetableId: json['timetable_id'],
      dayOfWeek: json['day_of_week'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      classId: json['class_id'],
      className: json['class_name'],
      sectionId: json['section_id'],
      sectionName: json['section_name'],
      subjectId: json['subject_id'],
      subjectName: json['subject_name'],
      teacherId: json['teacher_id'],
      teacherName: json['teacher_name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'timetable_id': timetableId,
    'day_of_week': dayOfWeek,
    'start_time': startTime,
    'end_time': endTime,
    'class_id': classId,
    'class_name': className,
    'section_id': sectionId,
    'section_name': sectionName,
    'subject_id': subjectId,
    'subject_name': subjectName,
    'teacher_id': teacherId,
    'teacher_name': teacherName,
  };
}