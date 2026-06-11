import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../model/school_model/all_student_list_model.dart';
import '../../res/api_url.dart';


class AcademicRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> academicApi() async {
    try {
      return await _apiServices.getGetApiResponse(ApiUrl.academicYear);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during academicApi: $e');
      }
      rethrow;
    }
  }
}
