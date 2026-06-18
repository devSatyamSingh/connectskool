// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:school_pro/repo/accountant_repo/create_accountant_attebndance_repo.dart';
// import 'package:school_pro/repo/student_repo/create_student_attendance_repo.dart';
// import 'package:school_pro/view_model/school_view_model/all_classes_view_model.dart';
//
// import '../../utils/utils.dart';
//
// class CreateStudentAttendanceViewModel with ChangeNotifier {
//   final _loginRepo = CreateStudentAttendanceRepository();
//   bool _loading = false;
//   bool get loading => _loading;
//   setLoading(bool value) {
//     _loading = value;
//     notifyListeners();
//   }
//
//   Future<bool> createStudentAttendanceApi(
//       dynamic accountantId,
//       dynamic attendanceDate,
//       dynamic status,
//       dynamic remarks,
//       context,
//       ) async {
//     setLoading(true);
//
//     Map data = {
//       "accountant_id": accountantId,
//       "attendance_date": attendanceDate,
//       "status": status,
//       "remarks": remarks
//     };
//
//     try {
//       final response = await _loginRepo.createStudentAttendanceApi(data);
//
//       setLoading(false);
//
//       final statusCode = response['status_code'];
//       final message = response['message'];
//
//       if (statusCode == 200 || statusCode == 201) {
//         Utils.show(message ?? "Class created successfully", context);
//
//         Provider.of<AllClassesViewModel>(
//           context,
//           listen: false,
//         ).allClassesApi(context);
//         Navigator.pop(context);
//         // Navigator.pushReplacementNamed(
//         //   context,
//         //   RoutesName.classesPage,
//         // );
//
//         return true;
//       } else if (statusCode == 400) {
//         Utils.show(message ?? "Invalid data", context);
//         return false;
//       } else if (statusCode == 401) {
//         Utils.show("Unauthorized user", context);
//         return false;
//       } else if (statusCode == 500) {
//         Utils.show("Server error. Try again later", context);
//         return false;
//       } else {
//         Utils.show("Something went wrong", context);
//         return false;
//       }
//     } catch (e) {
//       setLoading(false);
//       if (kDebugMode) print("API Error: $e");
//
//       Utils.show("Network error", context);
//       return false;
//     }
//   }
// }
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/student_repo/create_student_attendance_repo.dart';
import 'package:school_pro/view_model/school_view_model/classes/all_classes_view_model.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';
class CreateStudentAttendanceViewModel with ChangeNotifier {
  final _repo = CreateStudentAttendanceRepository();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  /// Payload shape (matches Postman):
  /// {
  ///   "class_id": 74,
  ///   "section_id": 76,
  ///   "attendance_date": "2026-01-20",
  ///   "students": [
  ///     {"student_id": 124, "status": "P", "remarks": ""},
  ///     {"student_id": 19,  "status": "A", "remarks": "Sick"},
  ///     ...
  ///   ]
  /// }
  Future<bool> createStudentAttendanceApi({
    required int classId,
    required int sectionId,
    required String attendanceDate,
    required List<Map<String, dynamic>> students,
    required BuildContext context,
  }) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.markStudentAttendance)) {

      Utils.show(
        "You don't have permission to mark attendance",
        context,
      );

      return false;
    }
    setLoading(true);

    final Map<String, dynamic> data = {
      "class_id": classId,
      "section_id": sectionId,
      "attendance_date": attendanceDate, // yyyy-MM-dd
      "students": students,
    };

    try {
      final response = await _repo.createStudentAttendanceApi(data);
      setLoading(false);

      final statusCode = response['status_code'];
      final message = response['message'];

      if (statusCode == 200 || statusCode == 201) {
        Utils.show(message ?? "Attendance created successfully", context);
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
      if (kDebugMode) print("API Error: $e");
      Utils.show("Network error", context);
      return false;
    }
  }
}
