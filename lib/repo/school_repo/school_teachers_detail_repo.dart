import 'package:flutter/foundation.dart';
import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';

class SchoolTeachersRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> schoolTeachersDetailApi(int teacherId) async {
    try {
      final url = "${ApiUrl.schoolTeachersDetail}?teacher_id=$teacherId";

      debugPrint("🌐 Teacher Detail API URL: $url");

      final response = await _apiServices.getGetApiResponse(url);

      debugPrint("📥 Teacher Detail API Response: $response");

      return response;
    } catch (e) {
      debugPrint("❌ Repository Error: $e");
      rethrow;
    }
  }
}
