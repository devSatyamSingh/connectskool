class RouteModel {
  bool? success;
  String? message;
  List<Data>? data;

  RouteModel({this.success, this.message, this.data});

  RouteModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];

    if (json['data'] != null) {
      data = List<Data>.from(
        json['data'].map((x) => Data.fromJson(x)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "data": data?.map((x) => x.toJson()).toList(),
    };
  }
}

class Data {
  int? transportRouteId;
  String? routeName;
  String? vehicleNo;
  String? driverName;
  String? driverPhone;
  int? status;
  String? createdAt;
  int? totalStops;

  Data({
    this.transportRouteId,
    this.routeName,
    this.vehicleNo,
    this.driverName,
    this.driverPhone,
    this.status,
    this.createdAt,
    this.totalStops,
  });

  Data.fromJson(Map<String, dynamic> json) {
    transportRouteId = json['transport_route_id'];
    routeName = json['route_name'];
    vehicleNo = json['vehicle_no'];
    driverName = json['driver_name'];
    driverPhone = json['driver_phone'];
    status = json['status'];
    createdAt = json['created_at'];
    totalStops = json['total_stops'];
  }

  Map<String, dynamic> toJson() {
    return {
      "transport_route_id": transportRouteId,
      "route_name": routeName,
      "vehicle_no": vehicleNo,
      "driver_name": driverName,
      "driver_phone": driverPhone,
      "status": status,
      "created_at": createdAt,
      "total_stops": totalStops,
    };
  }
}