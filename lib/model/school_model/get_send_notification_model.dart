class GetSendNotificationModel {
  bool? success;
  dynamic message;
  List<NotificationData>? data;
  Pagination? pagination;

  GetSendNotificationModel({
    this.success,
    this.message,
    this.data,
    this.pagination,
  });

  GetSendNotificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];

    if (json['data'] != null) {
      data = (json['data'] as List)
          .map((e) => NotificationData.fromJson(e))
          .toList();
    } else {
      data = [];
    }

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

class NotificationData {
  dynamic notificationId;
  dynamic title;
  dynamic description;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic recipientsCount;
  dynamic readCount;

  NotificationData({
    this.notificationId,
    this.title,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.recipientsCount,
    this.readCount,
  });

  NotificationData.fromJson(Map<String, dynamic> json) {
    notificationId = json['notification_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    recipientsCount = json['recipients_count'];
    readCount = json['read_count'];
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_id': notificationId,
      'title': title,
      'description': description,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'recipients_count': recipientsCount,
      'read_count': readCount,
    };
  }
}

class Pagination {
  dynamic currentPage;
  dynamic perPage;
  dynamic totalItems;
  dynamic totalPages;

  Pagination({
    this.currentPage,
    this.perPage,
    this.totalItems,
    this.totalPages,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    perPage = json['per_page'];
    totalItems = json['total_items'];
    totalPages = json['total_pages'];
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'per_page': perPage,
      'total_items': totalItems,
      'total_pages': totalPages,
    };
  }
}
