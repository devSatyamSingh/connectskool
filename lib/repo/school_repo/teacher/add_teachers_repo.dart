import 'package:flutter/foundation.dart';

import '../../../helper/network/network_api_services.dart';
import '../../../res/api_url.dart';

class AddTeachersRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<dynamic> addTeachersApi( Map<String, String> fields,
      Map<String, dynamic> files,) async {
    try {
      dynamic response = await _apiServices.getPostApiFormData(
          ApiUrl.registerTeacher,
          fields,
          files
      );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error in addTeachersApi→ $e");
      }
      rethrow;
    }
  }
}