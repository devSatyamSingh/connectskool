class PermissionManager {
  static List<String> _permissions = [];

  static void setPermissions(List<String> permissions) {
    _permissions = permissions;
  }

  static List<String> get permissions => _permissions;

  static bool has(String key) {
    return _permissions.contains(key);
  }

  static void clear() {
    _permissions.clear();
  }
}