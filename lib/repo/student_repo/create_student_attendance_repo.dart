import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';


class CreateStudentAttendanceRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> createStudentAttendanceApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(ApiUrl.createStudentAttendance,data);
      debugPrint("✅ API Raw Response: ${jsonEncode(response)}");
      return (response);
    } catch (e) {
      debugPrint('❌ Error occurred during createStudentAttendanceApi: $e');
      rethrow;
    }
  }
}
