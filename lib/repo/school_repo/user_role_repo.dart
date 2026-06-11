import 'package:flutter/foundation.dart';

import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';

class GetUsersByRoleRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> getUsersByRoleApi({required String role}) async {
    try {
      return await _apiServices.getGetApiResponse(
        '${ApiUrl.getUserRole}/$role',
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during getUsersByRoleApi: $e');
      }
      rethrow;
    }
  }
}