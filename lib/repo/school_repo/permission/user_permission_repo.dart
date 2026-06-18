import 'package:flutter/foundation.dart';

import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../res/api_url.dart';

class GetUserPermissionRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> getUserPermissionApi({
    required int userId,
  }) async {
    try {
      return await _apiServices.getGetApiResponse(
        '${ApiUrl.getUserPermission}/$userId/permissions',
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during getUserPermissionApi: $e');
      }
      rethrow;
    }
  }
}