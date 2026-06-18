class GenerateMarksheetModel {
  bool? success;
  GenerateMarksheetData? data;

  GenerateMarksheetModel({
    this.success,
    this.data,
  });

  GenerateMarksheetModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];

    data = json['data'] != null
        ? GenerateMarksheetData.fromJson(json['data'])
        : null;
  }
}

class GenerateMarksheetData {
  StudentInfo? studentInfo;
  String? academicYear;
  AttendanceInfo? attendance;

  Map<String, dynamic>? scholastic;

  Map<String, dynamic>? coScholastic;

  String? cgpa;

  dynamic overallPercentage;

  GenerateMarksheetData.fromJson(Map<String, dynamic> json) {
    studentInfo = json['student_info'] != null
        ? StudentInfo.fromJson(json['student_info'])
        : null;

    academicYear = json['academic_year'];

    attendance = json['attendance'] != null
        ? AttendanceInfo.fromJson(json['attendance'])
        : null;

    scholastic = json['scholastic'];

    coScholastic = json['co_scholastic'];

    cgpa = json['cgpa']?.toString();

    overallPercentage = json['overall_percentage'];
  }
}

class AttendanceInfo {
  dynamic totalWorkingDays;

  dynamic presentDays;

  AttendanceInfo.fromJson(
      Map<String, dynamic> json) {
    totalWorkingDays =
    json['total_working_days'];

    presentDays =
    json['present_days'];
  }
}

class StudentInfo {
  int? studentId;

  String? name;

  String? fatherName;

  String? motherName;

  String? dob;

  String? address;

  String? rollNo;

  String? admissionNo;

  String? className;

  String? sectionName;

  int? classId;

  int? sectionId;

  StudentInfo.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id'];

    name = json['name'];

    fatherName = json['father_name'];

    motherName = json['mother_name'];

    dob = json['dob'];

    address = json['address'];

    rollNo = json['roll_no'];

    admissionNo = json['admission_no'];

    className = json['class_name'];

    sectionName = json['section_name'];

    classId = json['class_id'];

    sectionId = json['section_id'];
  }
}