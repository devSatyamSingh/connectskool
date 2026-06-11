class GetUserPermissionModel {
  bool? success;
  String? message;
  UserPermissionData? data;

  GetUserPermissionModel({this.success, this.message, this.data});

  factory GetUserPermissionModel.fromJson(dynamic json) {
    // ✅ Fix: cast dynamic -> Map<String, dynamic>
    final map = Map<String, dynamic>.from(json);
    return GetUserPermissionModel(
      success: map['success'],
      message: map['message'],
      data: map['data'] != null
          ? UserPermissionData.fromJson(map['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

// ─────────────────────────────────────────────────────────────────────────────

class UserPermissionData {
  int? userId;
  String? name;
  String? role;

  /// key = section name (e.g. "students", "fees")
  /// value = list of permissions in that section
  Map<String, List<PermissionItem>>? permissions;

  UserPermissionData({
    this.userId,
    this.name,
    this.role,
    this.permissions,
  });

  factory UserPermissionData.fromJson(dynamic json) {
    // ✅ Fix: cast dynamic -> Map<String, dynamic>
    final map = Map<String, dynamic>.from(json);

    Map<String, List<PermissionItem>> permsMap = {};

    if (map['permissions'] != null) {
      // ✅ Fix: cast nested map properly
      final raw = Map<String, dynamic>.from(map['permissions']);
      raw.forEach((section, list) {
        if (list is List) {
          permsMap[section] = list
              .map((e) => PermissionItem.fromJson(e))
              .toList();
        }
      });
    }

    return UserPermissionData(
      userId: map['user_id'],
      name: map['name'],
      role: map['role'],
      permissions: permsMap,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> permsJson = {};
    permissions?.forEach((section, list) {
      permsJson[section] = list.map((e) => e.toJson()).toList();
    });
    return {
      'user_id': userId,
      'name': name,
      'role': role,
      'permissions': permsJson,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class PermissionItem {
  int? permissionId;
  String? key;
  String? description;
  bool? roleDefault;
  String? state; // "default" | "allowed" | "denied"

  PermissionItem({
    this.permissionId,
    this.key,
    this.description,
    this.roleDefault,
    this.state,
  });

  factory PermissionItem.fromJson(dynamic json) {
    // ✅ Fix: cast dynamic -> Map<String, dynamic>
    final map = Map<String, dynamic>.from(json);
    return PermissionItem(
      permissionId: map['permission_id'],
      key: map['key'],
      description: map['description'],
      roleDefault: map['role_default'],
      state: map['state'],
    );
  }

  Map<String, dynamic> toJson() => {
    'permission_id': permissionId,
    'key': key,
    'description': description,
    'role_default': roleDefault,
    'state': state,
  };
}