import 'package:school_pro/utils/permission_manager.dart';

class PermissionExtensions {

  static bool canAccess(
      String permission,
      ) {

    return PermissionManager.has(
      permission,
    );
  }
}