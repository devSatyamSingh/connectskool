
import 'package:flutter/foundation.dart';

import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../res/api_url.dart';
class GetSendNotificationRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> getSendNotificationApi() async {
    try {
      return await _apiServices.getGetApiResponse(ApiUrl.getSendNotification);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during getSendNotificationApi: $e');
      }
      rethrow;
    }
  }
}
