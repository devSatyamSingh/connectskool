
import 'package:flutter/foundation.dart';

import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';
class AllRolePermissionsRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> allRolePermissionsApi() async {
    try {
      return await _apiServices.getGetApiResponse(ApiUrl.allPermissions);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during allRolePermissionsApi: $e');
      }
      rethrow;
    }
  }
}
