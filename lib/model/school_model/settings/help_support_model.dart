class SupportTicketModel {
  bool? success;
  String? message;
  TicketData? data;

  SupportTicketModel({
    this.success,
    this.message,
    this.data,
  });

  SupportTicketModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];

    data = json['data'] != null
        ? TicketData.fromJson(json['data'])
        : null;
  }
}

class TicketData {
  int? supportTicketId;

  TicketData({
    this.supportTicketId,
  });

  TicketData.fromJson(Map<String, dynamic> json) {
    supportTicketId = json['support_ticket_id'];
  }
}