import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/create_admin_marksheet_repo.dart';
import 'package:school_pro/repo/school_repo/create_classes_repo.dart';
import 'package:school_pro/utils/routes/routes_name.dart';
import 'package:school_pro/view_model/school_view_model/all_classes_view_model.dart';

import '../../utils/utils.dart';

// class CreateAdminMarkSheetViewModel with ChangeNotifier {
//   final _loginRepo = CreateAdminMarkSheetRepository();
//   bool _loading = false;
//   bool get loading => _loading;
//   setLoading(bool value) {
//     _loading = value;
//     notifyListeners();
//   }
//
//   Future<bool> createAdminMarkSheetApi(
//       dynamic studentId,
//       dynamic subjectId,
//       dynamic term,
//       dynamic grade,
//       dynamic academicYear,
//       context,
//       ) async {
//     setLoading(true);
//
//     Map data = {
//       "student_id": studentId,
//       "subject_id": subjectId,
//       "term": term,
//       "grade": grade,
//       "academic_year": academicYear,
//     };
//
//     try {
//       final response = await _loginRepo.createAdminMarkSheetApi(data);
//
//       setLoading(false);
//
//       final statusCode = response['status_code'];
//       final message = response['message'];
//
//       if (statusCode == 200 || statusCode == 201) {
//         Utils.show(message ?? "Marksheet created successfully", context);
//
//         Provider.of<AllClassesViewModel>(
//           context,
//           listen: false,
//         ).allClassesApi(context);
//         // Navigator.pop(context);
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
class CreateAdminMarkSheetViewModel with ChangeNotifier {
  final _loginRepo = CreateAdminMarkSheetRepository();
  bool _loading = false;
  bool get loading => _loading;

  // ✅ ADD THIS
  String? lastError;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> createAdminMarkSheetApi(
      dynamic studentId,
      dynamic subjectId,
      dynamic term,
      dynamic grade,
      dynamic academicYear,
      context,
      ) async {
    setLoading(true);
    lastError = null; // ✅ reset on each call

    Map data = {
      "student_id": studentId,
      "subject_id": subjectId,
      "term": term,
      "grade": grade,
      "academic_year": academicYear,
    };

    try {
      final response = await _loginRepo.createAdminMarkSheetApi(data);
      setLoading(false);

      final statusCode = response['status_code'];
      final message = response['message'];

      if (statusCode == 200 || statusCode == 201) {
        Utils.show(message ?? "Marksheet created successfully", context);
        Provider.of<AllClassesViewModel>(context, listen: false).allClassesApi(context);
        return true;
      } else {
        lastError = message ?? ""; // ✅ store error message
        Utils.show(message ?? "Something went wrong", context);
        return false;
      }
    } catch (e) {
      setLoading(false);
      lastError = e.toString(); // ✅ store exception
      if (kDebugMode) print("API Error: $e");
      Utils.show("Network error", context);
      return false;
    }
  }
}