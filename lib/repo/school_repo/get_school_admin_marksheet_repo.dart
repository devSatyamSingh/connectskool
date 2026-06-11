// import 'package:school_pro/res/api_url.dart';
//
// import '../../helper/network/base_api_services.dart';
// import '../../helper/network/network_api_services.dart';
//
// class GetCoScholasticRepo {
//
//   BaseApiServices apiServices = NetworkApiServices();
//
//   Future<dynamic> getCoScholasticGradesApi(
//       String studentId,
//       String academicYear,
//       ) async {
//
//     String url =
//         "${ApiUrl.getAdminMarkSheet}?student_id=$studentId&academic_year=$academicYear";
//
//     dynamic response = await apiServices.getGetApiResponse(url);
//
//     return response;
//   }
// }
import 'package:school_pro/res/api_url.dart';

import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';

class GetCoScholasticRepo {

  BaseApiServices apiServices = NetworkApiServices();

  Future<dynamic> getCoScholasticGradesApi(
      String studentId,
      String academicYear,
      ) async {

    String url =
        "${ApiUrl.getAdminMarkSheet}?student_id=$studentId&academic_year=$academicYear";

    // 🔍 Debug prints
    print("📌 API URL: $url");
    print("📌 Student ID: $studentId");
    print("📌 Academic Year: $academicYear");

    try {
      dynamic response = await apiServices.getGetApiResponse(url);

      // ✅ Response print
      print("✅ API Response: $response");

      return response;

    } catch (e) {
      // ❌ Error print
      print("❌ API Error: $e");
      rethrow;
    }
  }
}