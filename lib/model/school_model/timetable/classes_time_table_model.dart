class ClassesTimeTableModel {
  bool? success;
  List<TimeTableData>? data;

  ClassesTimeTableModel({this.success, this.data});

  ClassesTimeTableModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <TimeTableData>[];
      json['data'].forEach((v) {
        data!.add(TimeTableData.fromJson(v));
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

class TimeTableData {
  dynamic timetableId;
  dynamic dayOfWeek;
  dynamic startTime;
  dynamic endTime;
  dynamic classId;
  dynamic className;
  dynamic sectionId;
  dynamic sectionName;
  dynamic subjectId;
  dynamic subjectName;
  dynamic teacherId;
  dynamic teacherName;

  TimeTableData(
      {this.timetableId,
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
        this.teacherName});

  TimeTableData.fromJson(Map<String, dynamic> json) {
    timetableId = json['timetable_id'];
    dayOfWeek = json['day_of_week'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    classId = json['class_id'];
    className = json['class_name'];
    sectionId = json['section_id'];
    sectionName = json['section_name'];
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    teacherId = json['teacher_id'];
    teacherName = json['teacher_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timetable_id'] = timetableId;
    data['day_of_week'] = dayOfWeek;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['class_id'] = classId;
    data['class_name'] = className;
    data['section_id'] = sectionId;
    data['section_name'] = sectionName;
    data['subject_id'] = subjectId;
    data['subject_name'] = subjectName;
    data['teacher_id'] = teacherId;
    data['teacher_name'] = teacherName;
    return data;
  }
}
