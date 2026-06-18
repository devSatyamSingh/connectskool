import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/model/school_model/permission/all_role_permission_model.dart';
import 'package:school_pro/repo/school_repo/permission/all_role_permissions_repo.dart';
import 'package:school_pro/utils/utils.dart';

class AllRolePermissionViewModel extends ChangeNotifier {
  final _allStudentListRepo = AllRolePermissionsRepository();

  bool _loading = false;
  bool get loading => _loading;

  AllRolePermissionsModel? _allRolePermissionsModel;
  AllRolePermissionsModel? get allRolePermissionsModel => _allRolePermissionsModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setModelData(AllRolePermissionsModel value) {
    _allRolePermissionsModel = value;
    notifyListeners();
  }

  // Future<void> allRolePermissionsApi(BuildContext context) async {
  //   setLoading(true);
  //
  //   try {
  //     final response = await _allStudentListRepo.allRolePermissionsApi();
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
  //         final model = AllRolePermissionsModel.fromJson(body);
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
  Future<void> allRolePermissionsApi(BuildContext context,
      {required String role}) async {

    setLoading(true);

    try {
      final response = await _allStudentListRepo.allRolePermissionsApi();

      final model = AllRolePermissionsModel.fromJson(response);
      setModelData(model);

    } catch (e) {
      Utils.show("Error loading permissions", context);
    } finally {
      setLoading(false);
    }
  }

}
