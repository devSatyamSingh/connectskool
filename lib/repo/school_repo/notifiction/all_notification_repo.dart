
import 'package:flutter/foundation.dart';

import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../res/api_url.dart';
class AllNotificationRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> allNotificationApi() async {
    try {
      return await _apiServices.getGetApiResponse(ApiUrl.allNotification);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during allNotificationApi: $e');
      }
      rethrow;
    }
  }
}
