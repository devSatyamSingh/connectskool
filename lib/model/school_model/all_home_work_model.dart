class AllHomeworkModel {
  bool? success;
  List<HomeworkData>? data;

  AllHomeworkModel({this.success, this.data});

  factory AllHomeworkModel.fromJson(Map<String, dynamic> json) {
    return AllHomeworkModel(
      success: json['success'],
      data: json['data'] != null
          ? List<HomeworkData>.from(
              (json['data'] as List).map(
                (x) => HomeworkData.fromJson(
                  Map<String, dynamic>.from(x), // ✅ fix
                ),
              ),
            )
          : [],
    );
  }
}

class HomeworkData {
  int? homeworkId;
  String? description;
  String? dueDate;
  String? createdAt;
  String? createdByRole;
  String? className;
  String? sectionName;
  String? subjectName;
  int? totalStudents;
  String? submittedCount;
  String? pendingCount;
  String? lateCount;
  dynamic attachment;
  String? allowSubmission;
  dynamic submissionPdf;
  dynamic submissionPhotos;

  HomeworkData({
    this.homeworkId,
    this.description,
    this.dueDate,
    this.createdAt,
    this.createdByRole,
    this.className,
    this.sectionName,
    this.subjectName,
    this.totalStudents,
    this.submittedCount,
    this.pendingCount,
    this.lateCount,
    this.attachment,
    this.allowSubmission,
    this.submissionPdf,
    this.submissionPhotos,
  });

  factory HomeworkData.fromJson(Map<String, dynamic> json) {
    return HomeworkData(
      homeworkId: json['homework_id'],
      description: json['description'],
      dueDate: json['due_date'],
      createdAt: json['created_at'],
      createdByRole: json['created_by_role'],
      className: json['class_name'],
      sectionName: json['section_name'],
      subjectName: json['subject_name'],
      totalStudents: json['total_students'],
      submittedCount: json['submitted_count']?.toString(),
      pendingCount: json['pending_count']?.toString(),
      allowSubmission: json['allow_submission']?.toString(),

      submissionPdf: json['submission_pdf'],

      submissionPhotos: json['submission_photos'],
      lateCount: json['late_count']?.toString(),
      attachment: json['attachment'],
    );
  }
}
