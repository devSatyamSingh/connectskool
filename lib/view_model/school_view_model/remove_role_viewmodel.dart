import 'package:flutter/material.dart';

import '../../repo/school_repo/remove_role_repo.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';

class RemoveRoleViewModel extends ChangeNotifier {
  final _repo = RemoveRoleRepository();

  bool _loading = false;

  bool get loading => _loading;

  Future<bool> removeRoleApi(
      BuildContext context,
      String role,
      List<int> ids,
      ) async {

    // ✅ Pattern C - ViewModel/API level guard
    // if (!PermissionExtensions.canAccess(PermissionKeys.managePermissions)) {
    //   Utils.show("Permission denied", context);
    //   return false;
    // }

    _loading = true;
    notifyListeners();

    try {
      final response = await _repo.removeRoleApi({
        "role": role,
        "permission_ids": ids,
      });

      _loading = false;
      notifyListeners();

      return response["success"] == true;
    } catch (_) {
      _loading = false;
      notifyListeners();

      return false;
    }
  }
}