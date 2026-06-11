class StopModel {
  bool? success;
  String? message;
  List<StopData>? data;

  StopModel({this.success, this.message, this.data});

  StopModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];

    if (json['data'] != null) {
      data = <StopData>[];
      json['data'].forEach((v) {
        data!.add(StopData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['success'] = success;
    dataMap['message'] = message;

    if (data != null) {
      dataMap['data'] = data!.map((v) => v.toJson()).toList();
    }

    return dataMap;
  }
}

class StopData {
  int? transportRouteStopId;
  int? transportRouteId;
  String? stopName;
  String? distanceKm;
  String? baseAmount;
  String? feeFrequency;
  int? status;
  String? createdAt;
  int? totalStudents;

  StopData(
      {this.transportRouteStopId,
        this.transportRouteId,
        this.stopName,
        this.distanceKm,
        this.baseAmount,
        this.feeFrequency,
        this.status,
        this.createdAt,
        this.totalStudents});

  StopData.fromJson(Map<String, dynamic> json) {
    transportRouteStopId = json['transport_route_stop_id'];
    transportRouteId = json['transport_route_id'];
    stopName = json['stop_name'];
    distanceKm = json['distance_km'];
    baseAmount = json['base_amount'];
    feeFrequency = json['fee_frequency'];
    status = json['status'];
    createdAt = json['created_at'];
    totalStudents = json['total_students'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['transport_route_stop_id'] = transportRouteStopId;
    dataMap['transport_route_id'] = transportRouteId;
    dataMap['stop_name'] = stopName;
    dataMap['distance_km'] = distanceKm;
    dataMap['base_amount'] = baseAmount;
    dataMap['fee_frequency'] = feeFrequency;
    dataMap['status'] = status;
    dataMap['created_at'] = createdAt;
    dataMap['total_students'] = totalStudents;
    return dataMap;
  }
}