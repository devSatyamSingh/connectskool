import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../res/api_url.dart';

class DeleteFeesHeadRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> deleteFeesHeadApi(Map<String, dynamic> data) async {
    try {
      dynamic response = await _apiServices.getDeleteApiResponse(
        ApiUrl.deleteFeesHead,
        data,
      );
      debugPrint("✅ API Raw Response: ${jsonEncode(response)}");
      return response;
    } catch (e) {
      debugPrint('❌ Error occurred during deleteFeesHeadApi: $e');
      rethrow;
    }
  }
}
