// ============================================================
//  student_attendance_repository.dart
// ============================================================

import 'package:school_pro/model/school_model/all_attendance_model.dart';
import 'package:school_pro/res/api_url.dart';
import '../../helper/network/network_api_services.dart';

class AllAttendanceRepository {
  final _api = NetworkApiServices();

  /// GET getAllStudentAttendanceByClassSection?class_id=X&section_id=Y&date=yyyy/MM/dd
  Future<AllAttendanceModel> getAttendance({
    required int    classId,
    required int    sectionId,
    required String date,       // yyyy/MM/dd
  }) async {
    final url =
        "${ApiUrl.studentAttendance}?class_id=$classId&section_id=$sectionId&date=$date";

    print("📌 Attendance URL 👉 $url");

    final response = await _api.getGetApiResponse(url);

    print("📌 Attendance Response 👉 $response");

    if (response["success"] == true || response["status_code"] == 200) {
      return AllAttendanceModel.fromJson(Map<String, dynamic>.from(response));
    } else {
      throw Exception(response["message"] ?? "Failed to fetch attendance");
    }
  }
}