import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/transport_repo/create_route_repo.dart';
import 'package:school_pro/repo/school_repo/transport_repo/create_stop_repo.dart';
import 'package:school_pro/repo/school_repo/transport_repo/create_student_transport_fee_repo.dart';
import 'package:school_pro/view_model/school_view_model/fine_rule_view_model.dart';

import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class CreateStudentTransportFeeViewModel with ChangeNotifier {
  final _loginRepo = CreateStudentTransportFeeRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<bool> createStudentTransportFeeApi(
      dynamic studentId,
      dynamic transportRouteId,
      dynamic transportRouteStopId,
      dynamic academicYear,
      dynamic academicYearEnd,
      dynamic assignedOn,
      context,
      ) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.manageTransport)) {

      Utils.show(
        "You don't have permission to perform this action.",
        context,
      );

      return false;
    }

    setLoading(true);

    Map data = {
      "student_id": studentId,
      "transport_route_id": transportRouteId,
      "transport_route_stop_id": transportRouteStopId,
      "academic_year": academicYear,
      "academic_year_end": academicYearEnd,
      "assigned_on": assignedOn,
    };

    // ✅ Request Data Print
    if (kDebugMode) {
      print("----- Create Student Transport Fee API Request -----");
      print("student_id: $studentId");
      print("transport_route_id: $transportRouteId");
      print("transport_route_stop_id: $transportRouteStopId");
      print("academic_year: $academicYear");
      print("academic_year_end: $academicYearEnd");
      print("assigned_on: $assignedOn");
      print("Full Request Body: $data");
    }

    try {
      final response = await _loginRepo.createStudentTransportFeeApi(data);

      setLoading(false);

      // ✅ Response Print
      if (kDebugMode) {
        print("----- API Response -----");
        print(response);
      }

      final statusCode = response['status_code'];
      final message = response['message'];

      // ✅ Status Print
      if (kDebugMode) {
        print("Status Code: $statusCode");
        print("Message: $message");
      }

      if (statusCode == 200 || statusCode == 201) {
        Utils.show(message ?? "Route created successfully", context);

        Provider.of<FineRuleViewModel>(
          context,
          listen: false,
        ).fineRuleApi(context);

        Navigator.pop(context);

        return true;

      } else if (statusCode == 400) {
        Utils.show(message ?? "Invalid data", context);
        return false;

      } else if (statusCode == 401) {
        Utils.show(message ?? "Unauthorized user", context);
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

      if (kDebugMode) {
        print("----- API Error -----");
        print(e);
      }

      Utils.show("Network error", context);
      return false;
    }
  }
  // Future<bool> createStudentTransportFeeApi(
  //     dynamic studentId,
  //     dynamic transportRouteId,
  //     dynamic transportRouteStopId,
  //     dynamic academicYear,
  //     dynamic academicYearEnd,
  //     dynamic assignedOn,
  //
  //     context,
  //     ) async
  // {
  //   setLoading(true);
  //
  //   Map data = {
  //     "student_id": studentId,
  //     "transport_route_id": transportRouteId,
  //     "transport_route_stop_id": transportRouteStopId,
  //     "academic_year":academicYear,
  //     "academic_year_end":academicYearEnd,
  //     "assigned_on":assignedOn,
  //   };
  //
  //   try {
  //     final response = await _loginRepo.createStudentTransportFeeApi(data);
  //
  //     setLoading(false);
  //
  //     final statusCode = response['status_code'];
  //     final message = response['message'];
  //
  //     if (statusCode == 200 || statusCode == 201) {
  //       Utils.show(message ?? "Route created successfully", context);
  //
  //       Provider.of<FineRuleViewModel>(
  //         context,
  //         listen: false,
  //       ).fineRuleApi(context);
  //       Navigator.pop(context);
  //       // Navigator.pushReplacementNamed(
  //       //   context,
  //       //   RoutesName.classesPage,
  //       // );
  //
  //       return true;
  //     } else if (statusCode == 400) {
  //       Utils.show(message ?? "Invalid data", context);
  //       return false;
  //     } else if (statusCode == 401) {
  //       Utils.show(message ?? "Unauthorized user", context);
  //       return false;
  //     } else if (statusCode == 500) {
  //       Utils.show("Server error. Try again later", context);
  //       return false;
  //     } else {
  //       Utils.show("Something went wrong", context);
  //       return false;
  //     }
  //   } catch (e) {
  //     setLoading(false);
  //     if (kDebugMode) print("API Error: $e");
  //
  //     Utils.show("Network error", context);
  //     return false;
  //   }
  // }
}
