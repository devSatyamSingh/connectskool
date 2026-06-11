class SelectRoleModel {
  bool? success;
  String? message;
  Data? data;

  SelectRoleModel({this.success, this.message, this.data});

  SelectRoleModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? role;
  List<Permissions>? permissions;

  Data({this.role, this.permissions});

  Data.fromJson(Map<String, dynamic> json) {
    role = json['role'];

    if (json['permissions'] != null) {
      permissions = [];

      for (final item in json['permissions']) {
        permissions!.add(
          Permissions.fromJson(
            Map<String, dynamic>.from(item),
          ),
        );
      }
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role'] = role;
    if (permissions != null) {
      data['permissions'] = permissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class Permissions {
//   int? permissionId;
//   String? section;
//   String? key;
//   String? description;
//
//   Permissions({this.permissionId, this.section, this.key, this.description});
//
//   Permissions.fromJson(Map<String, dynamic> json) {
//     permissionId = json['permission_id'];
//     section = json['section'];
//     key = json['key'];
//     description = json['description'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['permission_id'] = permissionId;
//     data['section'] = section;
//     data['key'] = key;
//     data['description'] = description;
//     return data;
//   }
// }
class Permissions {
  int? permissionId;
  String? section;
  String? key;
  String? description;
  bool? isAssigned;

  Permissions({
    this.permissionId,
    this.section,
    this.key,
    this.description,
    this.isAssigned,
  });

  Permissions.fromJson(Map<String, dynamic> json) {
    permissionId = json['permission_id'];
    section = json['section'];
    key = json['key'];
    description = json['description'];

    isAssigned = json['is_assigned'] == true;
  }

  Map<String, dynamic> toJson() {
    return {
      'permission_id': permissionId,
      'section': section,
      'key': key,
      'description': description,
      'is_assigned': isAssigned,
    };
  }
}