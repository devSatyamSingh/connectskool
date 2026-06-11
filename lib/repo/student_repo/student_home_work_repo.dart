import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';


class StudentHomeworkRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> studentHomeWorkApi() async {
    try {
      return await _apiServices.getGetApiResponse(ApiUrl.studentHomeWork);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during studentHomeWorkApi: $e');
      }
      rethrow;
    }
  }
}
