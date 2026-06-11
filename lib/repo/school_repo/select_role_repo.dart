
import 'package:flutter/foundation.dart';

import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';
// class SelectRoleRepository {
//   final BaseApiServices _apiServices = NetworkApiServices();
//
//   Future<dynamic> selectRoleApi() async {
//     try {
//       return await _apiServices.getGetApiResponse(ApiUrl.selectRole);
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error occurred during selectRoleApi: $e');
//       }
//       rethrow;
//     }
//   }
// }
class SelectRoleRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> selectRoleApi(String role) async {
    try {
      return await _apiServices.getGetApiResponse(
        ApiUrl.selectRole(role),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during selectRoleApi: $e');
      }
      rethrow;
    }
  }
}
