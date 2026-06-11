class StudentNotificationModel {
  final bool? success;
  final dynamic message;
  final StudentNotificationData? data;

  StudentNotificationModel({this.success, this.message, this.data});

  factory StudentNotificationModel.fromJson(Map<String, dynamic> json) {
    return StudentNotificationModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? StudentNotificationData.fromJson(json['data'])
          : null,
    );
  }
}

class StudentNotificationData {
  final dynamic unreadCount;
  final List<StudentNotificationItem>? notifications;

  StudentNotificationData({this.unreadCount, this.notifications});

  factory StudentNotificationData.fromJson(Map<String, dynamic> json) {
    return StudentNotificationData(
      unreadCount: json['unread_count'],
      notifications: json['notifications'] != null
          ? List<StudentNotificationItem>.from(
        json['notifications'].map(
              (x) => StudentNotificationItem.fromJson(x),
        ),
      )
          : [],
    );
  }
}

class StudentNotificationItem {
  final dynamic notificationId;
  final dynamic title;
  final dynamic description;
  final dynamic createdAt;
  final dynamic status;
  final dynamic isRead;
  final dynamic readAt;
  final dynamic senderName;
  final dynamic senderRole;
  final dynamic senderEmail;

  StudentNotificationItem({
    this.notificationId,
    this.title,
    this.description,
    this.createdAt,
    this.status,
    this.isRead,
    this.readAt,
    this.senderName,
    this.senderRole,
    this.senderEmail,
  });

  factory StudentNotificationItem.fromJson(Map<String, dynamic> json) {
    return StudentNotificationItem(
      notificationId: json['notification_id'],
      title:          json['title'],
      description:    json['description'],
      createdAt:      json['created_at'],
      status:         json['status'],
      isRead:         json['is_read'],
      readAt:         json['read_at'],
      senderName:     json['sender_name'],
      senderRole:     json['sender_role'],
      senderEmail:    json['sender_email'],
    );
  }
}