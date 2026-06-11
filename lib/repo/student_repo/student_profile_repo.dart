import 'package:flutter/foundation.dart';
import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';

// class StudentProfileRepository {
//   final BaseApiServices _apiServices = NetworkApiServices();
//
//   Future<dynamic> studentProfileApi() async {
//     try {
//       final url =
//           "${ApiUrl.studentProfile}";
//
//       debugPrint("🌐 studentProfileApi API URL: $url");
//
//       final response = await _apiServices.getGetApiResponse(url);
//
//       debugPrint("📥 studentProfileApi API Response: $response");
//
//       return response;
//     } catch (e) {
//       debugPrint("❌ Repository Error: $e");
//       rethrow;
//     }
//   }
//
// }
class StudentProfileRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> studentProfileApi() async {
    try {
      return await _apiServices.getGetApiResponse(ApiUrl.studentProfile);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during studentProfileApi: $e');
      }
      rethrow;
    }
  }
}
