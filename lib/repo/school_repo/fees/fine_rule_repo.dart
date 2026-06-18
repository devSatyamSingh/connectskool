import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../model/school_model/student/all_student_list_model.dart';
import '../../../res/api_url.dart';


class FineRuleRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> fineRuleApi() async {
    try {
      return await _apiServices.getGetApiResponse(ApiUrl.fineRule);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during fineRuleApi: $e');
      }
      rethrow;
    }
  }
}
