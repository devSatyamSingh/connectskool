import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';

class AllStudentAdminAttendanceRepository {

  final NetworkApiServices _api = NetworkApiServices();

  Future<dynamic> getStudentAdminAttendance({
    required int classId,
    required int sectionId,
    required String date,
  }) async {

    try {

      String url =
          "${ApiUrl.allStudentAttendance}"
          "?class_id=$classId"
          "&section_id=$sectionId"
          "&date=$date";

      print("Attendance URL 👉 $url");

      final response = await _api.getGetApiResponse(url);

      return response;

    } catch (e) {

      print("getStudentAdminAttendance Error: $e");

      return {
        "status_code": 500,
        "success": false,
        "message": "Something went wrong",
        "data": {}
      };
    }
  }
}