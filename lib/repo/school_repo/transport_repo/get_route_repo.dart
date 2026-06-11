
import 'package:flutter/foundation.dart';

import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../res/api_url.dart';

class GetRouteRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> getRouteApi() async {
    try {
      return await _apiServices.getGetApiResponse(ApiUrl.getRoutes);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during getRouteApi: $e');
      }
      rethrow;
    }
  }
}
