import '../../helper/network/network_api_services.dart';
import '../../res/api_url.dart';

class AccountantAttendanceRepository {

  final NetworkApiServices _api = NetworkApiServices();

  /// Get Accountant Attendance
  Future<dynamic> getAccountantAttendance({
    required String attendanceDate,
  }) async {

    try {

      String url =
          "${ApiUrl.accountantAttendance}?attendance_date=$attendanceDate";

      print("Attendance URL: $url");

      final response = await _api.getGetApiResponse(url);

      return response;

    } catch (e) {

      print("AccountantAttendanceRepository Error: $e");

      return {
        "status_code": 500,
        "success": false,
        "message": "Something went wrong",
        "data": []
      };
    }
  }
}