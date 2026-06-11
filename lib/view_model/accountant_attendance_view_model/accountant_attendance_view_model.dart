// import 'package:flutter/material.dart';
// import '../../model/accountant_model/accountant_attendance_model.dart';
// import '../../repo/accountant_repo/accountant_attendance_repo.dart';
//
// class AccountantAttendanceViewModel with ChangeNotifier {
//
//   final _repo = AccountantAttendanceRepository();
//
//   bool loading = false;
//
//   List<AccountantAttendanceModel> attendanceList = [];
//
//   Future<void> getAccountantAttendance(String date) async {
//
//     loading = true;
//     notifyListeners();
//
//     final response = await _repo.getAccountantAttendance(
//       attendanceDate: date,   // ✅ FIX
//     );
//
//     if (response["status_code"] == 200 &&
//         response["success"] == true) {
//
//       List data = response["data"] ?? [];
//
//       attendanceList =
//           data.map((e) => AccountantAttendanceModel.fromJson(e)).toList();
//     } else {
//       attendanceList = [];
//     }
//
//     loading = false;
//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';
import '../../model/accountant_model/accountant_attendance_model.dart';
import '../../repo/accountant_repo/accountant_attendance_repo.dart';

class AccountantAttendanceViewModel with ChangeNotifier {

  final _repo = AccountantAttendanceRepository();

  bool loading = false;

  List<AccountantAttendanceModel> attendanceList = [];

  Future<void> getAccountantAttendance(String date) async {

    loading = true;
    notifyListeners();

    try {

      final response = await _repo.getAccountantAttendance(
        attendanceDate: date,
      );

      if (response != null &&
          response["status_code"] == 200 &&
          response["success"] == true) {

        List data = response["data"] ?? [];

        attendanceList =
            data.map((e) => AccountantAttendanceModel.fromJson(e)).toList();

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