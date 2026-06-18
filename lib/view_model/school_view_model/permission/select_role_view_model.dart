// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:school_pro/repo/school_repo/select_role_repo.dart';
// // import 'package:school_pro/utils/utils.dart';
// //
// // import '../../repo/school_repo/select_role_model.dart';
// //
// // class SelectRoleViewModel extends ChangeNotifier {
// //   final _repo = SelectRoleRepository();
// //   bool? isAssigned;
// //   bool _loading = false;
// //   bool get loading => _loading;
// //
// //   SelectRoleModel? _model;
// //   SelectRoleModel? get model => _model;
// //
// //   void setLoading(bool value) {
// //     _loading = value;
// //     notifyListeners();
// //   }
// //
// //   void setModel(SelectRoleModel value) {
// //     _model = value;
// //     notifyListeners();
// //   }
// //   // void preparePermissions() {
// //   //
// //   //   final permissions = _model?.data?.permissions;
// //   //
// //   //   if (permissions == null || permissions.isEmpty) {
// //   //     permissionState = {};
// //   //     notifyListeners();
// //   //     return;
// //   //   }
// //   //
// //   //   Map<String, Map<int, bool>> temp = {};
// //   //
// //   //   for (var item in permissions) {
// //   //
// //   //     String section = item.section ?? "Other";
// //   //     int id = item.permissionId ?? 0;
// //   //
// //   //     if (!temp.containsKey(section)) {
// //   //       temp[section] = {};
// //   //     }
// //   //
// //   //     // 🔥 old value preserve karega
// //   //     temp[section]![id] =
// //   //         permissionState[section]?[id] ?? false;
// //   //   }
// //   //
// //   //   permissionState = temp;
// //   //
// //   //   notifyListeners();
// //   // }
// //   void preparePermissions() {
// //
// //     final permissions = model?.data?.permissions;
// //
// //     if (permissions == null || permissions.isEmpty) {
// //       permissionState = {};
// //       notifyListeners();
// //       return;
// //     }
// //
// //     Map<String, Map<int, bool>> temp = {};
// //
// //     for (var item in permissions) {
// //
// //       String section = item.section ?? "Other";
// //       int id = item.permissionId ?? 0;
// //
// //       if (!temp.containsKey(section)) {
// //         temp[section] = {};
// //       }
// //
// //       // 🔥 YAHI MAIN FIX HAI
// //       // API se jo value aa rahi hai wahi set karo
// //
// //       temp[section]![id] = item.isAssigned == true;
// //     }
// //
// //     permissionState = temp;
// //
// //     notifyListeners();
// //   }
// //   Map<String, Map<int, bool>> permissionState = {};
// //   Future<void> selectRoleApi(
// //       BuildContext context,
// //       String role,
// //       ) async {
// //     setLoading(true);
// //
// //     try {
// //       final response = await _repo.selectRoleApi(role);
// //
// //       final int statusCode = response['status_code'] ?? 0;
// //
// //       switch (statusCode) {
// //         case 200:
// //           final body = Map<String, dynamic>.from(response);
// //           body.remove('status_code');
// //
// //           final model = SelectRoleModel.fromJson(body);
// //           setModel(model);
// //           break;
// //
// //         case 401:
// //           Utils.show("Unauthorized user", context);
// //           break;
// //
// //         case 403:
// //           Utils.show("Access denied", context);
// //           break;
// //
// //         case 500:
// //           Utils.show("Server error", context);
// //           break;
// //
// //         default:
// //           Utils.show(response['message'] ?? "Error", context);
// //       }
// //     } catch (e) {
// //       Utils.show("Failed to load role", context);
// //     } finally {
// //       setLoading(false);
// //     }
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:school_pro/repo/school_repo/select_role_repo.dart';
// import 'package:school_pro/repo/school_repo/save_user_permission_repo.dart';
// import 'package:school_pro/utils/utils.dart';
// import '../../repo/school_repo/select_role_model.dart';
//
// class SelectRoleViewModel extends ChangeNotifier {
//
//   final _repo = SelectRoleRepository();
//   final _saveRepo = SaveUserPermissionRepository();
//
//   bool _loading = false;
//   bool get loading => _loading;
//
//   SelectRoleModel? _model;
//   SelectRoleModel? get model => _model;
//
//   /// 🔥 MAIN PERMISSION STATE MAP
//   /// section -> (permissionId -> true/false)
//   Map<String, Map<int, bool>> permissionState = {};
//
//   /// loading for individual switch
//   Map<int, bool> permissionLoading = {};
//
//   void setLoading(bool value) {
//     _loading = value;
//     notifyListeners();
//   }
//   void setModel(SelectRoleModel value) {
//     _model = value;
//     preparePermissions(); // ← har baar API data se overwrite
//     notifyListeners();
//   }
//   // void setModel(SelectRoleModel value) {
//   //   _model = value;
//   //   preparePermissions(); // 👈 IMPORTANT
//   //   notifyListeners();
//   // }
//
//   // =========================================================
//   // 🔥 PREPARE PERMISSIONS FROM API
//   // =========================================================
//   // void preparePermissions() {
//   //
//   //   final permissions = model?.data?.permissions;
//   //
//   //   if (permissions == null || permissions.isEmpty) {
//   //     permissionState = {};
//   //     notifyListeners();
//   //     return;
//   //   }
//   //
//   //   Map<String, Map<int, bool>> temp = {};
//   //
//   //   for (var item in permissions) {
//   //
//   //     String section = item.section ?? "Other";
//   //     int id = item.permissionId ?? 0;
//   //
//   //     if (!temp.containsKey(section)) {
//   //       temp[section] = {};
//   //     }
//   //
//   //     /// ✅ SAFE CHECK (agar isAssigned model me na ho)
//   //     bool assigned = false;
//   //
//   //     if (item.isAssigned != null) {
//   //       assigned = item.isAssigned == true;
//   //     }
//   //
//   //     temp[section]![id] = assigned;
//   //   }
//   //
//   //   permissionState = temp;
//   //
//   //   notifyListeners();
//   // }
//   void preparePermissions() {
//     final permissions = model?.data?.permissions;
//
//     if (permissions == null || permissions.isEmpty) {
//       permissionState = {};
//       notifyListeners();
//       return;
//     }
//
//     Map<String, Map<int, bool>> temp = {};
//
//     for (var item in permissions) {
//       String section = item.section ?? "Other";
//       int id = item.permissionId ?? 0;
//
//       if (!temp.containsKey(section)) {
//         temp[section] = {};
//       }
//
//       // API se jo value aa rahi hai wahi set karo
//       temp[section]![id] = item.isAssigned == true;
//     }
//
//     permissionState = temp;
//     notifyListeners();
//   }
//   // =========================================================
//   // 🔥 TOGGLE PERMISSION (UI SWITCH)
//   // =========================================================
//   void updatePermission(
//       String section,
//       int permissionId,
//       bool value,
//       ) {
//
//     permissionState[section]?[permissionId] = value;
//     notifyListeners();
//   }
//
//   // =========================================================
//   // 🔥 CALL SELECT ROLE API
//   // =========================================================
//   Future<void> selectRoleApi(
//       BuildContext context,
//       String role,
//       ) async {
//
//     setLoading(true);
//
//     try {
//
//       final response = await _repo.selectRoleApi(role);
//
//       final int statusCode = response['status_code'] ?? 0;
//
//       switch (statusCode) {
//
//         case 200:
//
//           final body = Map<String, dynamic>.from(response);
//           body.remove('status_code');
//
//           final model = SelectRoleModel.fromJson(body);
//
//           setModel(model);
//
//           break;
//
//         case 401:
//           Utils.show("Unauthorized user", context);
//           break;
//
//         case 403:
//           Utils.show("Access denied", context);
//           break;
//
//         case 500:
//           Utils.show("Server error", context);
//           break;
//
//         default:
//           Utils.show(response['message'] ?? "Error", context);
//       }
//
//     } catch (e) {
//
//       Utils.show("Failed to load role", context);
//
//     } finally {
//
//       setLoading(false);
//     }
//   }
//
//   // =========================================================
//   // 🔥 SAVE USER PERMISSIONS API
//   // =========================================================
//   Future<void> saveUserPermissions(
//       BuildContext context,
//       int userId,
//       ) async {
//
//     List<Map<String, dynamic>> permissionList = [];
//
//     permissionState.forEach((section, perms) {
//
//       perms.forEach((id, selected) {
//
//         permissionList.add({
//           "permission_id": id,
//           "state": selected ? "granted" : "denied"
//         });
//
//       });
//
//     });
//
//     Map<String, dynamic> requestBody = {
//       "user_id": userId,
//       "permissions": permissionList
//     };
//
//     try {
//
//       final response =
//       await _saveRepo.saveUserPermissionApi(requestBody);
//
//       final int statusCode = response['status_code'] ?? 0;
//
//       if (statusCode == 200) {
//
//         Utils.show("Permissions Saved Successfully", context);
//
//       } else {
//
//         Utils.show(response['message'] ?? "Failed to Save", context);
//
//       }
//
//     } catch (e) {
//
//       Utils.show("Error saving permissions", context);
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:school_pro/repo/school_repo/permission/select_role_repo.dart';
import 'package:school_pro/repo/school_repo/permission/save_user_permission_repo.dart';
import 'package:school_pro/utils/utils.dart';
import '../../../model/school_model/permission/all_permissions_model.dart';
import '../../../repo/school_repo/permission/all_role_permissions_repo.dart';
import '../../../model/school_model/permission/select_role_model.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';

class SelectRoleViewModel extends ChangeNotifier {
  final _repo = SelectRoleRepository();
  final _saveRepo = SaveUserPermissionRepository();
  final _allPermissionRepo = AllRolePermissionsRepository();

  Map<int, PermissionItem> permissionDetails = {};

  bool _loading = false;
  bool get loading => _loading;

  SelectRoleModel? _model;
  SelectRoleModel? get model => _model;

  Map<String, Map<int, bool>> permissionState = {};
  Map<int, bool> permissionLoading = {};

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setModel(SelectRoleModel value) {
    _model = value;
    notifyListeners();
  }

  void preparePermissions(String role) {
    final permissions = model?.data?.permissions;

    if (permissions == null || permissions.isEmpty) {
      permissionState = {};
      notifyListeners();
      return;
    }

    Map<String, Map<int, bool>> temp = {};

    for (var item in permissions) {
      String section = item.section ?? "Other";
      int id = item.permissionId ?? 0;

      if (!temp.containsKey(section)) {
        temp[section] = {};
      }

      temp[section]![id] = item.isAssigned == true;
    }

    permissionState = temp;

    // ✅ API se aaya to locally save karo
    // _savePermissionsLocally(role, permissionState);

    notifyListeners();
  }


  Future<void> selectRoleApi(BuildContext context, String role) async {

    setLoading(true);

    try {
      final response = await _repo.selectRoleApi(role);

      final int statusCode = response['status_code'] ?? 0;

      switch (statusCode) {
        case 200:
          final body = Map<String, dynamic>.from(response);

          body.remove('status_code');

          final model = SelectRoleModel.fromJson(body);

          setModel(model);

          break;

        default:
          Utils.show(response['message'] ?? "Error", context);
      }
    } catch (e) {
      Utils.show("Failed to load role", context);
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadRolePermissions(BuildContext context, String role) async {


    setLoading(true);

    try {
      final allResponse = await _allPermissionRepo.allRolePermissionsApi();

      final roleResponse = await _repo.selectRoleApi(role);

      print("ALL RESPONSE => $allResponse");
      print("ROLE RESPONSE => $roleResponse");

      final roleBody = Map<String, dynamic>.from(roleResponse);

      roleBody.remove("status_code");

      final allModel =
      AllPermissionsModel.fromJson(
        Map<String, dynamic>.from(allResponse),
      );


      final roleModel = SelectRoleModel.fromJson(
        Map<String, dynamic>.from(roleBody),
      );

      print("========== ROLE CHECK ==========");
      print("SELECTED ROLE => $role");

      for (var p in roleModel.data?.permissions ?? []) {
        print(
          "ROLE=$role | ID=${p.permissionId} | KEY=${p.key}",
        );
      }

      permissionState.clear();

      final assignedIds =
          roleModel.data?.permissions
              ?.map((e) => e.permissionId ?? 0)
              .toSet() ??
          <int>{};

      print("ALL PERMISSIONS => ${allModel.permissions.length}");

      print("ROLE PERMISSIONS => ${assignedIds.length}");

      allModel.permissions.forEach((section, list) {

        permissionState[section] = {};

        for (var item in list) {

          permissionDetails[item.permissionId ?? 0] = item;

          permissionState[section]![item.permissionId ?? 0] =
              assignedIds.contains(item.permissionId);
        }
      });

      print("FINAL STATE => ${permissionState.length}");

      notifyListeners();
    } catch (e) {
      print("LOAD ROLE ERROR => $e");

      Utils.show("Failed to load permissions", context);
    } finally {
      setLoading(false);
    }
  }

  // =========================================================
  // 🔥 SAVE USER PERMISSIONS API
  // =========================================================
  Future<void> saveUserPermissions(BuildContext context, int userId) async {

    List<Map<String, dynamic>> permissionList = [];

    permissionState.forEach((section, perms) {
      perms.forEach((id, selected) {
        permissionList.add({
          "permission_id": id,
          "state": selected ? "granted" : "denied",
        });
      });
    });

    Map<String, dynamic> requestBody = {
      "user_id": userId,
      "permissions": permissionList,
    };

    try {
      final response = await _saveRepo.saveUserPermissionApi(requestBody);
      final int statusCode = response['status_code'] ?? 0;

      if (statusCode == 200) {
        Utils.show("Permissions Saved Successfully", context);
      } else {
        Utils.show(response['message'] ?? "Failed to Save", context);
      }
    } catch (e) {
      Utils.show("Error saving permissions", context);
    }
  }
}
