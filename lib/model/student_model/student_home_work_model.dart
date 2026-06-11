class StudentHomeworkModel {
  bool? success;
  List<StudentProfileData>? data;

  StudentHomeworkModel({
    this.success,
    this.data,
  });

  StudentHomeworkModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];

    if (json['data'] != null) {
      data = <StudentProfileData>[];
      for (final item in json['data']) {
        data!.add(StudentProfileData.fromJson(item));
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": data?.map((e) => e.toJson()).toList(),
    };
  }
}

class StudentProfileData {
  dynamic subjectId;
  String? subjectName;
  dynamic homeworkId;

  String? title;
  String? description;

  String? dueDate;

  int? allowSubmission;

  String? status;
  String? submittedAt;
  String? remarks;

  HomeworkAttachment? attachment;

  List<HomeworkAttachment>? attachmentPhotos;

  HomeworkAttachment? submittedFile;

  List<HomeworkAttachment>? submittedPhotos;

  StudentProfileData({
    this.subjectId,
    this.subjectName,
    this.homeworkId,
    this.title,
    this.description,
    this.dueDate,
    this.allowSubmission,
    this.status,
    this.submittedAt,
    this.remarks,
    this.attachment,
    this.attachmentPhotos,
    this.submittedFile,
    this.submittedPhotos,
  });

  StudentProfileData.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    homeworkId = json['homework_id'];

    title = json['title'];
    description = json['description'];

    dueDate = json['due_date'];

    allowSubmission = json['allow_submission'];

    status = json['status'];
    submittedAt = json['submitted_at'];
    remarks = json['remarks'];

    attachment = json['attachment'] != null
        ? HomeworkAttachment.fromJson(json['attachment'])
        : null;

    if (json['attachment_photos'] != null) {
      attachmentPhotos = <HomeworkAttachment>[];

      for (final item in json['attachment_photos']) {
        attachmentPhotos!.add(
          HomeworkAttachment.fromJson(item),
        );
      }
    }



    submittedFile = json['submitted_file'] != null
        ? HomeworkAttachment.fromJson(json['submitted_file'])
        : null;

    if (json['submitted_photos'] != null) {
      submittedPhotos = <HomeworkAttachment>[];

      for (final item in json['submitted_photos']) {
        submittedPhotos!.add(
          HomeworkAttachment.fromJson(item),
        );
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "subject_id": subjectId,
      "subject_name": subjectName,
      "homework_id": homeworkId,
      "title": title,
      "description": description,
      "due_date": dueDate,
      "allow_submission": allowSubmission,
      "status": status,
      "submitted_at": submittedAt,
      "remarks": remarks,
      "attachment": attachment?.toJson(),
      "attachment_photos":
      attachmentPhotos?.map((e) => e.toJson()).toList(),
      "submitted_file": submittedFile?.toJson(),
      "submitted_photos":
      submittedPhotos?.map((e) => e.toJson()).toList(),
    };
  }

  String get submittedPdfName {
    if (submittedFile?.url == null) return '';

    return submittedFile!.url!
        .split('/')
        .last;
  }

  String get teacherPdfName {
    if (attachment?.url == null) return '';

    return attachment!.url!
        .split('/')
        .last;
  }

  /// Helper Methods

  bool get isSubmitted =>
      status == "submitted" || submittedAt != null;

  bool get isOnlineSubmission =>
      allowSubmission == 1;

  bool get isOfflineSubmission =>
      allowSubmission == 0 || allowSubmission == null;

  bool get hasPdf =>
      attachment != null;

  bool get hasPhotos =>
      attachmentPhotos?.isNotEmpty ?? false;

  bool get hasSubmittedPdf =>
      submittedFile != null;

  bool get hasSubmittedPhotos =>
      submittedPhotos?.isNotEmpty ?? false;
}

class HomeworkAttachment {
  String? type;
  String? url;

  HomeworkAttachment({
    this.type,
    this.url,
  });

  HomeworkAttachment.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "url": url,
    };
  }
}