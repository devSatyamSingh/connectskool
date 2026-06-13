import 'package:flutter/material.dart';
import 'package:school_pro/repo/teacher_repo/teacher_attendance_repo.dart';
import '../../model/accountant_model/accountant_attendance_model.dart';
import '../../model/teacher_model/teacher_attendance_model.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';

// class TeacherAttendanceViewModel with ChangeNotifier {
//
//   final _repo = TeacherAttendanceRepository();
//
//   bool loading = false;
//
//   List<TeacherAttendanceModel> attendanceList = [];
//
//   Future<void> getTeacherAttendance(String date) async {
//
//     loading = true;
//     notifyListeners();
//
//     try {
//
//       final response = await _repo.getTeacherAttendance(
//         attendanceDate: date,
//       );
//
//       if (response != null &&
//           response["status_code"] == 200 &&
//           response["success"] == true) {
//
//         List data = response["data"] ?? [];
//
//         attendanceList =
//             data.map((e) => TeacherAttendanceModel.fromJson(e)).toList();
//
//       } else {
//         attendanceList = [];
//       }
//
//     } catch (e) {
//
//       debugPrint("Attendance Error: $e");
//       attendanceList = [];
//
//     }
//
//     loading = false;
//     notifyListeners();
//   }
// }
class TeacherAttendanceViewModel with ChangeNotifier {

  final _repo = TeacherAttendanceRepository();

  bool loading = false;

  List<AttendanceData> attendanceList = [];   // ✅ FIXED

  Future<void> getTeacherAttendance(String date, BuildContext context) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.viewOneTeacherAttendance)) {

      Utils.show(
        "You don't have permission to view attendance",
        context,
      );

      return;
    }

    loading = true;
    notifyListeners();

    try {

      final response = await _repo.getTeacherAttendance(
        attendanceDate: date,
      );

      if (response != null &&
          response["status_code"] == 200 &&
          response["success"] == true) {

        List data = response["data"] ?? [];

        attendanceList =
            data.map((e) => AttendanceData.fromJson(e)).toList();

      } else {
        attendanceList = [];
      }

    } catch (e) {

      debugPrint("Attendance Error: $e");
      attendanceList = [];

    }

    loading = false;
    notifyListeners();
  }
}