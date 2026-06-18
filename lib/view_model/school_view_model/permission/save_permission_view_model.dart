import 'package:flutter/material.dart';
import '../../../repo/school_repo/permission/save_user_permission_repo.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class SaveUserPermissionViewModel extends ChangeNotifier {

  final SaveUserPermissionRepository _repo =
  SaveUserPermissionRepository();

  bool _loading = false;
  bool get loading => _loading;

  Future<bool> saveUserPermissionApi({
    required BuildContext context,
    required int userId,
    required Map<int, String> permissionStateMap,
  }) async {

    // // ✅ Pattern C - ViewModel/API level guard
    // if (!PermissionExtensions.canAccess(PermissionKeys.managePermissions)) {
    //   Utils.show("Permission denied", context);
    //   return false;
    // }

    _loading = true;
    notifyListeners();

    try {

      final body = {
        "user_id": userId,
        "permissions": permissionStateMap.entries.map((e) => {
          "permission_id": e.key,
          "state": e.value,
        }).toList(),
      };

      final response = await _repo.saveUserPermissionApi(body);

      _loading = false;
      notifyListeners();

      if (response['success'] == true) {
        return true;
      } else {
        return false;
      }

    } catch (e) {
      _loading = false;
      notifyListeners();
      return false;
    }
  }
}