import 'package:flutter/foundation.dart';

import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../res/api_url.dart';

class GetAllTransportStudentsRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> getStudents(String academicYear) async {
    try {
      return await _apiServices.getGetApiResponse(
        "${ApiUrl.getAllTransportStudents}"
        "?academic_year=$academicYear",
      );
    } catch (e) {
      if (kDebugMode) {
        print("GetAllTransportStudentsRepo Error => $e");
      }

      rethrow;
    }
  }
}
