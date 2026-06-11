// class GenerateAdmitCardModel {
//   bool? success;
//   AdmitCardData? data;
//
//   GenerateAdmitCardModel({this.success, this.data});
//
//   GenerateAdmitCardModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     data = json['data'] != null ? AdmitCardData.fromJson(json['data']) : null;
//   }
// }
//
// class AdmitCardData {
//   ExamInfo? examInfo;
//   ClassInfo? classInfo;
//   List<Students>? students;
//
//   AdmitCardData({this.examInfo, this.classInfo, this.students});
//
//   AdmitCardData.fromJson(Map<String, dynamic> json) {
//     examInfo = json['exam_info'] != null
//         ? ExamInfo.fromJson(json['exam_info'])
//         : null;
//
//     classInfo = json['class_info'] != null
//         ? ClassInfo.fromJson(json['class_info'])
//         : null;
//
//     if (json['students'] != null) {
//       students = [];
//       json['students'].forEach((v) {
//         students!.add(Students.fromJson(v));
//       });
//     }
//   }
// }
//
// class ExamInfo {
//   int? examId;
//   String? examName;
//
//   ExamInfo({this.examId, this.examName});
//
//   ExamInfo.fromJson(Map<String, dynamic> json) {
//     examId = json['exam_id'];
//     examName = json['exam_name'];
//   }
// }
//
// class ClassInfo {
//   String? className;
//   String? sectionName;
//
//   ClassInfo({this.className, this.sectionName});
//
//   ClassInfo.fromJson(Map<String, dynamic> json) {
//     className = json['class_name'];
//     sectionName = json['section_name'];
//   }
// }
//
// class Students {
//   int? studentId;
//   String? name;
//   String? admissionNo;
//
//   Students({this.studentId, this.name, this.admissionNo});
//
//   Students.fromJson(Map<String, dynamic> json) {
//     studentId = json['student_id'];
//     name = json['name'];
//     admissionNo = json['admission_no'];
//   }
// }
// ════════════════════════════════════════════════════════════════════════════
// generate_admit_card_model.dart
// ════════════════════════════════════════════════════════════════════════════

class GenerateAdmitCardModel {
  bool? success;
  AdmitCardResponseData? data;

  GenerateAdmitCardModel({this.success, this.data});

  GenerateAdmitCardModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? AdmitCardResponseData.fromJson(json['data'])
        : null;
  }
}

// ── Top-level data wrapper ────────────────────────────────────────────────────
class AdmitCardResponseData {
  SchoolInfo?      schoolInfo;
  ExamInfo?        examInfo;
  ClassInfo?       classInfo;
  List<Students>?  students;
  List<String>?    instructions;

  AdmitCardResponseData({
    this.schoolInfo,
    this.examInfo,
    this.classInfo,
    this.students,
    this.instructions,
  });

  AdmitCardResponseData.fromJson(Map<String, dynamic> json) {
    schoolInfo = json['school_info'] != null
        ? SchoolInfo.fromJson(json['school_info'])
        : null;

    examInfo = json['exam_info'] != null
        ? ExamInfo.fromJson(json['exam_info'])
        : null;

    classInfo = json['class_info'] != null
        ? ClassInfo.fromJson(json['class_info'])
        : null;

    if (json['students'] != null) {
      students = <Students>[];
      for (final v in json['students'] as List) {
        students!.add(Students.fromJson(v as Map<String, dynamic>));
      }
    }

    if (json['instructions'] != null) {
      instructions = List<String>.from(json['instructions'] as List);
    }
  }
}

// ── School info ───────────────────────────────────────────────────────────────
class SchoolInfo {
  String? schoolName;
  String? address;
  String? phone;
  String? email;
  String? website;

  SchoolInfo({
    this.schoolName,
    this.address,
    this.phone,
    this.email,
    this.website,
  });

  SchoolInfo.fromJson(Map<String, dynamic> json) {
    schoolName = json['school_name'];
    address    = json['address'];
    phone      = json['phone'];
    email      = json['email'];
    website    = json['website'];
  }
}

// ── Exam info ─────────────────────────────────────────────────────────────────
class ExamInfo {
  int?    examId;
  String? examName;
  String? academicYear;
  String? startDate;
  String? endDate;

  ExamInfo({
    this.examId,
    this.examName,
    this.academicYear,
    this.startDate,
    this.endDate,
  });

  ExamInfo.fromJson(Map<String, dynamic> json) {
    examId       = json['exam_id'];
    examName     = json['exam_name'];
    academicYear = json['academic_year'];
    startDate    = json['start_date'];
    endDate      = json['end_date'];
  }
}

// ── Class info ────────────────────────────────────────────────────────────────
class ClassInfo {
  String? className;
  String? sectionName;

  ClassInfo({this.className, this.sectionName});

  ClassInfo.fromJson(Map<String, dynamic> json) {
    className   = json['class_name'];
    sectionName = json['section_name'];
  }
}

// ── Student ───────────────────────────────────────────────────────────────────
class Students {
  int?                 studentId;
  String?              name;
  dynamic              rollNo;       // null in API
  String?              admissionNo;
  String?              regNo;
  String?              dob;
  String?              fatherName;
  String?              motherName;
  String?              address;
  String?              studentPhoto; // null in API but kept for future
  List<ExamSchedule>?  examSchedule;

  Students({
    this.studentId,
    this.name,
    this.rollNo,
    this.admissionNo,
    this.regNo,
    this.dob,
    this.fatherName,
    this.motherName,
    this.address,
    this.studentPhoto,
    this.examSchedule,
  });

  Students.fromJson(Map<String, dynamic> json) {
    studentId    = json['student_id'];
    name         = json['name'];
    rollNo       = json['roll_no'];
    admissionNo  = json['admission_no'];
    regNo        = json['reg_no'];
    dob          = json['dob'];
    fatherName   = json['father_name'];
    motherName   = json['mother_name'];
    address      = json['address'];
    studentPhoto = json['student_photo'];

    if (json['exam_schedule'] != null) {
      examSchedule = <ExamSchedule>[];
      for (final v in json['exam_schedule'] as List) {
        examSchedule!.add(
            ExamSchedule.fromJson(v as Map<String, dynamic>));
      }
    }
  }
}

// ── Exam schedule row ─────────────────────────────────────────────────────────
class ExamSchedule {
  String? examDate;    // "18-09-2025"
  String? day;         // "Thu"
  String? shift;       // "1st"
  String? startTime;   // "10:00 AM"
  String? endTime;     // "01:00 PM"
  String? subjectName; // "Science"
  String? roomNo;      // "A-12"

  ExamSchedule({
    this.examDate,
    this.day,
    this.shift,
    this.startTime,
    this.endTime,
    this.subjectName,
    this.roomNo,
  });

  ExamSchedule.fromJson(Map<String, dynamic> json) {
    examDate    = json['exam_date'];
    day         = json['day'];
    shift       = json['shift'];
    startTime   = json['start_time'];
    endTime     = json['end_time'];
    subjectName = json['subject_name'];
    roomNo      = json['room_no'];
  }

  /// Combined display: "Thu 18-09-2025"
  String get dayDate => '${day ?? ''} ${examDate ?? ''}'.trim();

  /// Combined time: "10:00 AM To 01:00 PM"
  String get timeRange =>
      '${startTime ?? ''} To ${endTime ?? ''}'.trim();
}