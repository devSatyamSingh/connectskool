import 'package:flutter/foundation.dart';

import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';

class AddAccountantRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<dynamic> addAccountantApi( Map<String, String> fields,
      Map<String, dynamic> files,) async {
    try {
      dynamic response = await _apiServices.getPostApiFormData(
          ApiUrl.registerAccountant,
          fields,
          files
      );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error in addAccountantApi→ $e");
      }
      rethrow;
    }
  }
}