import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../res/api_url.dart';


class UpdateStudentAttendanceRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> updateStudentAttendanceApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPutApiResponse(ApiUrl.updateStudentAttendance,data);
      debugPrint("✅ API Raw Response: ${jsonEncode(response)}");
      return (response);
    } catch (e) {
      debugPrint('❌ Error occurred during updateStudentAttendanceApi: $e');
      rethrow;
    }
  }
}
