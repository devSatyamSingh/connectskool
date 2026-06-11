
import 'package:flutter/foundation.dart';

import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';

class AuthRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> loginApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse(ApiUrl.login, data);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during loginApi: $e');
      }
      rethrow;
    }
  }
  Future<dynamic> logoutApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse(ApiUrl.logout, data);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during logout: $e');
      }
      rethrow;
    }
  }

}