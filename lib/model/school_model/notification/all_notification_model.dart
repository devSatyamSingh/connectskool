// class AllNotificationModel {
//   bool? success;
//   List<Data>? data;
//
//   AllNotificationModel({this.success, this.data});
//
//   AllNotificationModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['success'] = success;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data {
//   dynamic notificationTypeId;
//   dynamic schoolId;
//   dynamic typeName;
//   dynamic typeCode;
//   dynamic description;
//   dynamic icon;
//   dynamic color;
//   dynamic isSystem;
//   dynamic status;
//   dynamic createdAt;
//   dynamic updatedAt;
//
//   Data(
//       {this.notificationTypeId,
//         this.schoolId,
//         this.typeName,
//         this.typeCode,
//         this.description,
//         this.icon,
//         this.color,
//         this.isSystem,
//         this.status,
//         this.createdAt,
//         this.updatedAt});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     notificationTypeId = json['notification_type_id'];
//     schoolId = json['school_id'];
//     typeName = json['type_name'];
//     typeCode = json['type_code'];
//     description = json['description'];
//     icon = json['icon'];
//     color = json['color'];
//     isSystem = json['is_system'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['notification_type_id'] = notificationTypeId;
//     data['school_id'] = schoolId;
//     data['type_name'] = typeName;
//     data['type_code'] = typeCode;
//     data['description'] = description;
//     data['icon'] = icon;
//     data['color'] = color;
//     data['is_system'] = isSystem;
//     data['status'] = status;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     return data;
//   }
// }
class AllNotificationModel {
  bool? success;
  String? message;
  Data? data;
  Pagination? pagination;

  AllNotificationModel({this.success, this.message, this.data, this.pagination});

  AllNotificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['success'] = success;
    dataMap['message'] = message;

    if (data != null) {
      dataMap['data'] = data!.toJson();
    }
    if (pagination != null) {
      dataMap['pagination'] = pagination!.toJson();
    }

    return dataMap;
  }
}

class Data {
  int? unreadCount;
  List<NotificationItem>? notifications;

  Data({this.unreadCount, this.notifications});

  Data.fromJson(Map<String, dynamic> json) {
    unreadCount = json['unread_count'];

    if (json['notifications'] != null) {
      notifications = <NotificationItem>[];
      json['notifications'].forEach((v) {
        notifications!.add(NotificationItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['unread_count'] = unreadCount;

    if (notifications != null) {
      dataMap['notifications'] =
          notifications!.map((v) => v.toJson()).toList();
    }

    return dataMap;
  }
}

/// Notification Item Model
class NotificationItem {
  int? notificationId;
  String? title;
  String? description;

  NotificationItem({
    this.notificationId,
    this.title,
    this.description,
  });

  NotificationItem.fromJson(Map<String, dynamic> json) {
    notificationId = json['notification_id'];   // ⭐ IMPORTANT
    title = json['title'];
    description = json['description'];          // ⭐ IMPORTANT
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['notification_id'] = notificationId;
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? perPage;
  int? totalItems;
  int? totalPages;

  Pagination({this.currentPage, this.perPage, this.totalItems, this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    perPage = json['per_page'];
    totalItems = json['total_items'];
    totalPages = json['total_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['current_page'] = currentPage;
    data['per_page'] = perPage;
    data['total_items'] = totalItems;
    data['total_pages'] = totalPages;
    return data;
  }
}

