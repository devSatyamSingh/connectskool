import 'package:flutter/foundation.dart';

import '../../../helper/network/network_api_services.dart';
import '../../../res/api_url.dart';

class CreateAdminTeachersHomeworkRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<dynamic> createAdminTeachersApi( Map<String, String> fields,
      Map<String, dynamic> files,) async {
    try {
      dynamic response = await _apiServices.getPostApiFormData(
          ApiUrl.createAdminTeacherHomework,
          fields,
          files
      );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error in createAdminTeachersApi→ $e");
      }
      rethrow;
    }
  }
}