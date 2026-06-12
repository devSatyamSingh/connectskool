import 'permission_manager.dart';

class PermissionExtensions {
  PermissionExtensions._();

  static bool canAccess(String permission) {
    return PermissionManager.has(permission);
  }

  static bool canAccessAny(
      List<String> permissions,
      ) {
    return PermissionManager.hasAny(
      permissions,
    );
  }

  static bool canAccessAll(
      List<String> permissions,
      ) {
    return PermissionManager.hasAll(
      permissions,
    );
  }
}