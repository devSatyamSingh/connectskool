import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../helper/network/base_api_services.dart';
import '../../../helper/network/network_api_services.dart';
import '../../../res/api_url.dart';

class DeleteSChoolAdminMarkSheetRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> deleteSchoolAdminMarkSheetApi(Map<String, dynamic> data) async {
    try {
      dynamic response = await _apiServices.getDeleteApiResponse(
        ApiUrl.deleteCoScholasticGrade, // yahan API ka URL
        data, // pass Map data
      );
      debugPrint("✅ API Raw Response: ${jsonEncode(response)}");
      return response;
    } catch (e) {
      debugPrint('❌ Error occurred during deleteSchoolAdminMarkSheetApi: $e');
      rethrow;
    }
  }
}
