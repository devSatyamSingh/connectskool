// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:school_pro/repo/school_repo/create_time_table_repo.dart';
// import 'package:school_pro/view_model/school_view_model/exam_management_view_model.dart';
// import '../../utils/utils.dart';
//
// class CreateTimetableViewModel with ChangeNotifier {
//   final _loginRepo = CreateExamTimeTableRepository();
//   bool _loading = false;
//   bool get loading => _loading;
//   setLoading(bool value) {
//     _loading = value;
//     notifyListeners();
//   }
//   Future<bool> createExamTimeTableApi(
//       dynamic examId,
//       dynamic classId,
//       dynamic sectionId,
//       dynamic subjectId,
//       dynamic examDate,
//       dynamic teacherId,
//       dynamic dayOfWeek,
//       dynamic startTime,
//       dynamic endTime,
//       dynamic roomNo,
//       dynamic maxMarks,
//       dynamic minPassingMarks,
//       dynamic instructions,
//       context,
//       ) async {
//
//     setLoading(true);
//
//     Map data = {
//       "exam_id": examId,
//       "class_id": classId,
//       "section_id": sectionId,
//       "exam_date": examDate,
//       "subject_id": subjectId,
//       "teacher_id": teacherId,
//       "day_of_week": dayOfWeek,
//       "start_time": startTime,
//       "end_time": endTime,
//       "room_no":roomNo,
//       "max_marks":maxMarks,
//       "min_passing_marks":minPassingMarks,
//       "instructions":instructions
//     };
//
//     print("📤 CREATE TIMETABLE API HIT");
//     print("📤 BODY 👉 $data");
//
//     try {
//
//       final response = await _loginRepo.createExamTimeTableApi(data);
//
//       print("📥 RESPONSE 👉 $response");
//
//       setLoading(false);
//
//       final statusCode = response['status_code'];
//       final message = response['message'];
//
//       print("📌 STATUS CODE 👉 $statusCode");
//       print("📌 MESSAGE 👉 $message");
//
//       if (statusCode == 200 || statusCode == 201) {
//
//         print("✅ CREATE SUCCESS");
//
//         Utils.show(message ?? "Timetable created successfully", context);
//
//         Navigator.pop(context);
//
//         Provider.of<ExamManagementViewModel>(
//           context,
//           listen: false,
//         ).examManagementApi(context);
//
//         return true;
//
//       } else if (statusCode == 400) {
//
//         print("❌ 400 ERROR");
//         Utils.show(message ?? "Invalid data", context);
//         return false;
//
//       } else if (statusCode == 401) {
//
//         print("❌ 401 ERROR");
//         Utils.show("Unauthorized user", context);
//         return false;
//
//       } else if (statusCode == 500) {
//
//         print("❌ 500 ERROR");
//         Utils.show("Server error. Try again later", context);
//         return false;
//
//       } else {
//
//         print("❌ UNKNOWN ERROR");
//         Utils.show("Something went wrong", context);
//         return false;
//       }
//
//     } catch (e) {
//
//       setLoading(false);
//
//       print("❌ EXCEPTION 👉 $e");
//
//       Utils.show("Network error", context);
//       return false;
//     }
//   }
//
//   // Future<bool> createTimeTableApi(
//   //     dynamic classId,
//   //     dynamic sectionId,
//   //     dynamic subjectId,
//   //     dynamic teacherId,
//   //     dynamic dayOfWeek,
//   //     dynamic startTime,
//   //     dynamic endTime,
//   //
//   //     context,
//   //     ) async
//   // {
//   //   setLoading(true);
//   //
//   //   Map data = {
//   //     "class_id": classId,
//   //     "section_id": sectionId,
//   //     "subject_id": subjectId,
//   //     "teacherId": teacherId,
//   //     "day_of_week": dayOfWeek,
//   //     "start_time": startTime,
//   //     "end_time": endTime
//   //
//   //   };
//   //
//   //   try {
//   //     final response = await _loginRepo.createTimeTableApi(data);
//   //
//   //     setLoading(false);
//   //
//   //     final statusCode = response['status_code'];
//   //     final message = response['message'];
//   //
//   //     if (statusCode == 200 || statusCode == 201) {
//   //       Utils.show(message ?? "Class created successfully", context);
//   //
//   //       Navigator.pop(context);
//   //       Provider.of<ExamManagementViewModel>(
//   //         context,
//   //         listen: false,
//   //       ).examManagementApi(context);
//   //       // Navigator.pushReplacementNamed(
//   //       //   context,
//   //       //   RoutesName.classesPage,
//   //       // );
//   //
//   //       return true;
//   //     } else if (statusCode == 400) {
//   //       Utils.show(message ?? "Invalid data", context);
//   //       return false;
//   //     } else if (statusCode == 401) {
//   //       Utils.show("Unauthorized user", context);
//   //       return false;
//   //     } else if (statusCode == 500) {
//   //       Utils.show("Server error. Try again later", context);
//   //       return false;
//   //     } else {
//   //       Utils.show("Something went wrong", context);
//   //       return false;
//   //     }
//   //   } catch (e) {
//   //     setLoading(false);
//   //     if (kDebugMode) print("API Error: $e");
//   //
//   //     Utils.show("Network error", context);
//   //     return false;
//   //   }
//   // }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/timetable/create_time_table_repo.dart';
import 'package:school_pro/view_model/school_view_model/exam/exam_management_view_model.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class CreateTimetableViewModel with ChangeNotifier {
  final _loginRepo = CreateExamTimeTableRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // 12-hour → 24-hour convert
  String _to24Hour(String time12) {
    try {
      final trimmed = time12.trim().toUpperCase();
      final isPM = trimmed.contains('PM');
      final isAM = trimmed.contains('AM');
      final timePart =
      trimmed.replaceAll('AM', '').replaceAll('PM', '').trim();
      final parts = timePart.split(':');
      int hour = int.parse(parts[0]);
      final int minute = int.parse(parts[1]);
      if (isPM && hour != 12) hour += 12;
      if (isAM && hour == 12) hour = 0;
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return time12;
    }
  }

  Future<bool> createExamTimeTableApi(
      int examId,
      int classId,
      String sectionId,
      int subjectId,
      String examDate,
      String startTime,
      String endTime,
      String roomNo,
      int? maxMarks,
      int? minPassingMarks,
      String instructions,
      context,
      ) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.manageTimetable)) {

      Utils.show(
        "You don't have permission to manage timetable",
        context,
      );

      return false;
    }
    setLoading(true);

    final convertedStart = _to24Hour(startTime);
    final convertedEnd   = _to24Hour(endTime);

    final Map data = {
      "exam_id":           examId,
      "class_id":          classId,
      "section_id":        sectionId,
      "subject_id":        subjectId,
      "exam_date":         examDate,
      "start_time":        convertedStart,
      "end_time":          convertedEnd,
      "room_no":           roomNo,
      "max_marks":         maxMarks,
      "min_passing_marks": minPassingMarks,
      "instructions":      instructions,
    };

    print("📤 CREATE TIMETABLE API HIT");
    print("📤 BODY 👉 $data");

    try {
      final response = await _loginRepo.createExamTimeTableApi(data);
      print("📥 RESPONSE 👉 $response");
      setLoading(false);

      final statusCode = response['status_code'];
      final message    = response['message'];

      if (statusCode == 200 || statusCode == 201) {
        Utils.show(message ?? "Timetable created successfully", context);
        Navigator.pop(context);
        Provider.of<ExamManagementViewModel>(context, listen: false)
            .examManagementApi(context);
        return true;
      } else if (statusCode == 400) {
        Utils.show(message ?? "Invalid data", context);
        return false;
      } else if (statusCode == 401) {
        Utils.show("Unauthorized user", context);
        return false;
      } else if (statusCode == 500) {
        Utils.show("Server error. Try again later", context);
        return false;
      } else {
        Utils.show("Something went wrong", context);
        return false;
      }
    } catch (e) {
      setLoading(false);
      print("❌ EXCEPTION 👉 $e");
      Utils.show("Network error", context);
      return false;
    }
  }
}