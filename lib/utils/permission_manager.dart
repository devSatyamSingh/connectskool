import 'dart:developer';

class PermissionManager {
  PermissionManager._();

  static final Set<String> _permissions = {};

  static String _currentRole = "";

  static String get role => _currentRole;

  static void setRole(String role) {
    _currentRole = role;
    log("👤 Current Role => $role");
  }

  static void setPermissions(List<String> permissions) {
    _permissions
      ..clear()
      ..addAll(
        permissions
            .where((e) => e.trim().isNotEmpty)
            .map((e) => e.trim()),
      );

    log("✅ Permissions Loaded: ${_permissions.length}");
    log("✅ Role: $_currentRole");
  }

  static List<String> get permissions => _permissions.toList();

  static bool has(String permission) {

    // 🔥 Admin bypass
    if (_currentRole == "school_admin") {
      return true;
    }

    return _permissions.contains(permission);
  }

  static bool hasAny(List<String> permissions) {

    if (_currentRole == "school_admin") {
      return true;
    }

    return permissions.any(
          (permission) => _permissions.contains(permission),
    );
  }

  static bool hasAll(List<String> permissions) {

    if (_currentRole == "school_admin") {
      return true;
    }

    return permissions.every(
          (permission) => _permissions.contains(permission),
    );
  }

  static void clear() {
    _permissions.clear();
    _currentRole = "";
    log("🗑 Permissions Cleared");
  }
}