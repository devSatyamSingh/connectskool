class AllPermissionsModel {
  bool? success;
  String? message;

  Map<String, List<PermissionItem>> permissions = {};

  AllPermissionsModel.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    message = json["message"];

    final data = Map<String, dynamic>.from(json["data"] ?? {});

    data.forEach((section, value) {
      permissions[section] = (value as List)
          .map((e) => PermissionItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    });
  }
}

class PermissionItem {
  int? permissionId;
  String? key;
  String? description;

  PermissionItem.fromJson(Map<String, dynamic> json) {
    permissionId = json["permission_id"];
    key = json["key"];
    description = json["description"];
  }
}
