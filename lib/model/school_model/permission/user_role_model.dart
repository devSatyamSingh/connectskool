class GetUsersByRoleModel {
  bool? success;
  String? message;
  List<UserByRole>? data;

  GetUsersByRoleModel({this.success, this.message, this.data});

  factory GetUsersByRoleModel.fromJson(dynamic json) {
    final map = Map<String, dynamic>.from(json);
    return GetUsersByRoleModel(
      success: map['success'],
      message: map['message'],
      data: map['data'] != null
          ? (map['data'] as List)
          .map((e) => UserByRole.fromJson(e))
          .toList()
          : [],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class UserByRole {
  dynamic userId;
  dynamic name;
  dynamic userEmail;

  /// role-specific id — student_id / teacher_id / accountant_id etc.
  dynamic roleSpecificId;

  UserByRole({
    this.userId,
    this.name,
    this.userEmail,
    this.roleSpecificId,
  });

  factory UserByRole.fromJson(dynamic json) {
    final map = Map<String, dynamic>.from(json);

    // picks whichever role-specific id key is present
    final roleId = map['student_id'] ??
        map['teacher_id'] ??
        map['accountant_id'] ??
        map['admin_id'];

    return UserByRole(
      userId: map['user_id'],
      name: map['name'],
      userEmail: map['user_email'],
      roleSpecificId: roleId,
    );
  }
}