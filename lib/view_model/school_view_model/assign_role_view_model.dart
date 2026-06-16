import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/repo/school_repo/assign_role_repo.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';

class AssignRoleViewModel with ChangeNotifier {

  final _loginRepo = AssignRoleRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<bool> assignRoleApi(
      BuildContext context,
      String role,
      List<int> permissionIds, {
        bool showMessage = true,
      }) async {
    print("========== ASSIGN ==========");
    print("ROLE => $role");


    // // ✅ Pattern C - ViewModel/API level guard
    // if (!PermissionExtensions.canAccess(PermissionKeys.managePermissions)) {
    //   if (showMessage) Utils.show("Permission denied", context);
    //   return false;
    // }

    setLoading(true);

    Map<String, dynamic> data = {
      "role": role,
      "permission_ids": permissionIds,
    };

    try {

      print("📤 Assign Role Body: $data");

      final response = await _loginRepo.assignRoleApi(data);

      setLoading(false);

      final statusCode = response['status_code'];
      final message = response['message'];

      if (statusCode == 200 || statusCode == 201) {

        if (showMessage) {
          Utils.show(message ?? "Permission assigned successfully", context);
        }

        return true;

      } else if (statusCode == 400) {

        if (showMessage) Utils.show(message ?? "Invalid data", context);
        return false;

      } else if (statusCode == 401) {

        if (showMessage) Utils.show("Unauthorized user", context);
        return false;

      } else if (statusCode == 500) {

        if (showMessage) Utils.show("Server error. Try again later", context);
        return false;

      } else {

        if (showMessage) Utils.show("Something went wrong", context);
        return false;
      }

    } catch (e) {

      setLoading(false);

      if (kDebugMode) print("API Error: $e");

      if (showMessage) Utils.show("Network error", context);

      return false;
    }
  }

// Future<bool> assignRoleApi(
//     BuildContext context,
//     String role,
//     List<int> permissionIds,
//     ) async
// {
//
//   setLoading(true);
//
//   Map<String, dynamic> data = {
//     "role": role,
//     "permission_ids": permissionIds,
//   };
//
//   try {
//
//     print("📤 Assign Role Body: $data");
//
//     final response = await _loginRepo.assignRoleApi(data);
//
//     setLoading(false);
//
//     final statusCode = response['status_code'];
//     final message = response['message'];
//
//     if (statusCode == 200 || statusCode == 201) {
//
//       Utils.show(message ?? "Permission assigned successfully", context);
//
//       return true;
//
//     } else if (statusCode == 400) {
//
//       Utils.show(message ?? "Invalid data", context);
//       return false;
//
//     } else if (statusCode == 401) {
//
//       Utils.show("Unauthorized user", context);
//       return false;
//
//     } else if (statusCode == 500) {
//
//       Utils.show("Server error. Try again later", context);
//       return false;
//
//     } else {
//
//       Utils.show("Something went wrong", context);
//       return false;
//     }
//
//   } catch (e) {
//
//     setLoading(false);
//     if (kDebugMode) print("API Error: $e");
//
//     Utils.show("Network error", context);
//     return false;
//   }
// }
}