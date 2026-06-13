import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/model/student_model/student_attendance_model.dart';
import 'package:school_pro/repo/student_repo/student_attendance_repo.dart';
import 'package:school_pro/utils/utils.dart';

import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';

class StudentAttendanceViewModel extends ChangeNotifier {
  final _allStudentListRepo = StudentAttendanceRepository();

  bool _loading = false;
  bool get loading => _loading;

  StudentAttendanceModel? _studentAttendanceModel;
  StudentAttendanceModel? get studentAttendanceModel => _studentAttendanceModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setModelData(StudentAttendanceModel value) {
    _studentAttendanceModel = value;
    notifyListeners();
  }

  // Future<void> studentAttendanceApi(BuildContext context) async {
  //   setLoading(true);
  //
  //   try {
  //     final response = await _allStudentListRepo.studentAttendanceApi();
  //
  //     final int statusCode = response['status_code'] ?? 0;
  //
  //     switch (statusCode) {
  //       case 200:
  //         final body = Map<String, dynamic>.from(response);
  //
  //         // Remove status_code as it's not part of the model
  //         body.remove('status_code');
  //
  //         // Parse data array and pagination
  //         final model = StudentAttendanceModel.fromJson(body);
  //         setModelData(model);
  //
  //         // print("✅ Teachers fetched: ${model.data?.length ?? 0}");
  //         break;
  //
  //       case 401:
  //         Utils.show("Unauthorized user", context);
  //         break;
  //
  //       case 403:
  //         Utils.show("Access denied", context);
  //         break;
  //
  //       case 404:
  //         Utils.show("Notification not found", context);
  //         break;
  //
  //       case 500:
  //         Utils.show("Server error", context);
  //         break;
  //
  //       case 0:
  //         Utils.show("No Internet Connection", context);
  //         break;
  //
  //       default:
  //         Utils.show(response['message'] ?? "Something went wrong", context);
  //     }
  //   } catch (e) {
  //     print("❌ Exception fetching teachers: $e");
  //     Utils.show("Failed to load teachers", context);
  //   } finally {
  //     setLoading(false);
  //   }
  // }
  Future<void> studentAttendanceApi(BuildContext context) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.viewOneStudentAttendance)) {

      Utils.show(
        "You don't have permission to view attendance",
        context,
      );

      return;
    }
    setLoading(true);

    try {
      final response = await _allStudentListRepo.studentAttendanceApi();

      print("FULL RESPONSE 👉 $response");

      final model = StudentAttendanceModel.fromJson(
        Map<String, dynamic>.from(response as Map),
      );

      print("DATA LENGTH 👉 ${model.data?.length}");

      setModelData(model);

    } catch (e) {
      print("❌ Exception: $e");
      Utils.show("Failed to load attendance", context);
    } finally {
      setLoading(false);
    }
  }}
