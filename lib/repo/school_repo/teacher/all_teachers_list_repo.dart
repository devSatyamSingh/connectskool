import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../res/api_url.dart';
class AllTeachersListRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> allTeachersListApi() async {
    try {
      return await _apiServices.getGetApiResponse(ApiUrl.allTeachersList);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during allTeachersListApi: $e');
      }
      rethrow;
    }
  }
}
