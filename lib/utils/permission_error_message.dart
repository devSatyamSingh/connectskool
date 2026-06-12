import 'package:flutter/material.dart';
import 'package:school_pro/utils/permission_extensions.dart';
import 'package:school_pro/utils/permission_manager.dart';
import 'package:school_pro/utils/utils.dart';

class PermissionGuard {
  static bool check(
    BuildContext context,
    String permission,
    String actionName,
  ) {
    debugPrint(
      "Checking Permission => $permission",
    );

    debugPrint(
      "Current Permissions => ${PermissionManager.permissions}",
    );
    if (PermissionExtensions.canAccess(permission)) {
      return true;
    }

    Utils.show(
      "$actionName permission has been disabled by your administrator.",
      context,
      type: "warning",
    );

    return false;
  }
}
