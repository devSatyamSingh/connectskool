class ExamTimeTableModel {
  bool? success;
  List<ExamTimetableData>? data;

  ExamTimeTableModel({this.success, this.data});

  ExamTimeTableModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ExamTimetableData>[];
      json['data'].forEach((v) {
        data!.add(ExamTimetableData.fromJson(v));
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

class ExamTimetableData {
  int? timetableId;
  int? schoolId;
  int? examId;
  int? classId;
  int? sectionId;
  int? subjectId;
  String? examDate;
  String? startTime;
  String? endTime;
  String? roomNo;
  String? maxMarks;
  String? minPassingMarks;
  String? instructions;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? subjectName;

  ExamTimetableData(
      {this.timetableId,
        this.schoolId,
        this.examId,
        this.classId,
        this.sectionId,
        this.subjectId,
        this.examDate,
        this.startTime,
        this.endTime,
        this.roomNo,
        this.maxMarks,
        this.minPassingMarks,
        this.instructions,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.subjectName});

  ExamTimetableData.fromJson(Map<String, dynamic> json) {
    timetableId = json['timetable_id'];
    schoolId = json['school_id'];
    examId = json['exam_id'];
    classId = json['class_id'];
    sectionId = json['section_id'];
    subjectId = json['subject_id'];
    examDate = json['exam_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    roomNo = json['room_no'];
    maxMarks = json['max_marks'];
    minPassingMarks = json['min_passing_marks'];
    instructions = json['instructions'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    subjectName = json['subject_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timetable_id'] = timetableId;
    data['school_id'] = schoolId;
    data['exam_id'] = examId;
    data['class_id'] = classId;
    data['section_id'] = sectionId;
    data['subject_id'] = subjectId;
    data['exam_date'] = examDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['room_no'] = roomNo;
    data['max_marks'] = maxMarks;
    data['min_passing_marks'] = minPassingMarks;
    data['instructions'] = instructions;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['subject_name'] = subjectName;
    return data;
  }
}
// time_table_model.dart — TimetableData class
class TimetableData {
  int? timetableId;
  int? schoolId;
  int? examId;
  int? classId;
  int? sectionId;
  int? subjectId;
  String? examDate;
  String? startTime;
  String? endTime;
  String? roomNo;
  String? maxMarks;
  String? minPassingMarks;
  String? instructions;
  String? createdAt;
  String? updatedAt;
  String? subjectName;
  String? dayOfWeek;      // ← add
  String? teacherName;    // ← add
  String? className;      // ← add
  String? sectionName;    // ← add
  int? teacherId;         // ← add

  TimetableData({
    this.timetableId,
    this.schoolId,
    this.examId,
    this.classId,
    this.sectionId,
    this.subjectId,
    this.examDate,
    this.startTime,
    this.endTime,
    this.roomNo,
    this.maxMarks,
    this.minPassingMarks,
    this.instructions,
    this.createdAt,
    this.updatedAt,
    this.subjectName,
    this.dayOfWeek,
    this.teacherName,
    this.className,
    this.sectionName,
    this.teacherId,
  });

  TimetableData.fromJson(Map<String, dynamic> json) {
    timetableId = json['timetable_id'];
    schoolId = json['school_id'];
    examId = json['exam_id'];
    classId = json['class_id'];
    sectionId = json['section_id'];
    subjectId = json['subject_id'];
    examDate = json['exam_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    roomNo = json['room_no'];
    maxMarks = json['max_marks'];
    minPassingMarks = json['min_passing_marks'];
    instructions = json['instructions'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    subjectName = json['subject_name'];
    dayOfWeek = json['day_of_week'];       // ← API key check karo
    teacherName = json['teacher_name'];    // ← API key check karo
    className = json['class_name'];        // ← API key check karo
    sectionName = json['section_name'];    // ← API key check karo
    teacherId = json['teacher_id'];
  }
}