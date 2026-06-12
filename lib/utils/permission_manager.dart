import 'dart:developer';

class PermissionManager {
  PermissionManager._();

  static final Set<String> _permissions = {};

  static void setPermissions(List<String> permissions) {
    _permissions
      ..clear()
      ..addAll(
        permissions
            .where((e) => e.trim().isNotEmpty)
            .map((e) => e.trim()),
      );

    log("✅ Permissions Loaded: ${_permissions.length}");
  }

  static List<String> get permissions =>
      _permissions.toList();

  static bool has(String permission) {
    if (permission.isEmpty) return false;

    return _permissions.contains(permission);
  }

  static bool hasAny(List<String> permissions) {
    return permissions.any(
          (permission) => _permissions.contains(permission),
    );
  }

  static bool hasAll(List<String> permissions) {
    return permissions.every(
          (permission) => _permissions.contains(permission),
    );
  }

  static bool get isEmpty => _permissions.isEmpty;

  static bool get isNotEmpty => _permissions.isNotEmpty;

  static void clear() {
    _permissions.clear();
    log("🗑 Permissions Cleared");
  }
}