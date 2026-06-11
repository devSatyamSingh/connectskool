
import 'package:flutter/foundation.dart';

import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';
class StudentAttendanceRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> studentAttendanceApi() async {
    try {
      return await _apiServices.getGetApiResponse(ApiUrl.studentAttendance);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during studentAttendanceApi: $e');
      }
      rethrow;
    }
  }
}
