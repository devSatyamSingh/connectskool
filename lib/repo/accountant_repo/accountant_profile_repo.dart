import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';


class AccountantProfileRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> accountantProfileApi() async {
    try {
      return await _apiServices.getGetApiResponse(ApiUrl.accountantProfile);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during accountantProfileApi: $e');
      }
      rethrow;
    }
  }
}
