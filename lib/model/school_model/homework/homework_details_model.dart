class HomeworkDetailsModel {
  bool? success;
  HomeworkDetailsData? data;

  HomeworkDetailsModel({
    this.success,
    this.data,
  });

  factory HomeworkDetailsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return HomeworkDetailsModel(
      success: json["success"],
      data: json["data"] != null
          ? HomeworkDetailsData.fromJson(json["data"])
          : null,
    );
  }
}

class HomeworkDetailsData {
  int? homeworkId;
  List<StudentSubmission>? students;

  HomeworkDetailsData({
    this.homeworkId,
    this.students,
  });

  factory HomeworkDetailsData.fromJson(
      Map<String, dynamic> json,
      ) {
    return HomeworkDetailsData(
      homeworkId: json["homework_id"],
      students: (json["students"] as List?)
          ?.map(
            (e) => StudentSubmission.fromJson(e),
      )
          .toList() ??
          [],
    );
  }
}

class StudentSubmission {
  int? studentId;
  String? studentName;
  String? rollNo;
  String? status;

  SubmittedFile? submittedFile;

  List<SubmittedPhoto>? submittedPhotos;

  StudentSubmission({
    this.studentId,
    this.studentName,
    this.rollNo,
    this.status,
    this.submittedFile,
    this.submittedPhotos,
  });

  factory StudentSubmission.fromJson(
      Map<String, dynamic> json,
      ) {
    return StudentSubmission(
      studentId: json["student_id"],
      studentName: json["student_name"],
      rollNo: json["roll_no"]?.toString(),
      status: json["status"],
      submittedFile: json["submitted_file"] != null
          ? SubmittedFile.fromJson(
        json["submitted_file"],
      )
          : null,
      submittedPhotos:
      (json["submitted_photos"] as List?)
          ?.map(
            (e) =>
            SubmittedPhoto.fromJson(e),
      )
          .toList() ??
          [],
    );
  }
}


class SubmittedFile {
  String? type;
  String? url;

  SubmittedFile({
    this.type,
    this.url,
  });

  factory SubmittedFile.fromJson(
      Map<String, dynamic> json,
      ) {
    return SubmittedFile(
      type: json["type"],
      url: json["url"],
    );
  }
}

class SubmittedPhoto {
  String? type;
  String? url;

  SubmittedPhoto({
    this.type,
    this.url,
  });

  factory SubmittedPhoto.fromJson(
      Map<String, dynamic> json,
      ) {
    return SubmittedPhoto(
      type: json["type"],
      url: json["url"],
    );
  }
}