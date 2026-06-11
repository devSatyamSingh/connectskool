// import 'package:school_pro/res/api_url.dart';
// import '../../helper/network/network_api_services.dart';
// import '../../model/school_model/time_table_model.dart';
//
// // class TimetableRepository {
// //
// //   final _api = NetworkApiServices();
// //
// //   /// GET /api/schooladmin/getTimetable?class_id=X&section_id=Y
// //   Future<TimetableModel> getTimetable({
// //     required int classId,
// //     required int sectionId,
// //   }) async {
// //
// //     final url =
// //         "${ApiUrl.timeTable}?class_id=$classId&section_id=$sectionId";
// //
// //     final response = await _api.getGetApiResponse(url);
// //
// //     if (response["status_code"] == 200) {
// //       return TimetableModel.fromJson(response);
// //     } else {
// //       throw Exception(response["message"] ?? "Failed to fetch timetable");
// //     }
// //   }
// // }
// class TimetableRepository {
//
//   final _api = NetworkApiServices();
//
//   Future<TimetableModel> getTimetable({
//     required int classId,
//     required int sectionId,
//   }) async {
//
//     final url =
//         "${ApiUrl.timeTable}?class_id=$classId&section_id=$sectionId";
//
//     final response = await _api.getGetApiResponse(url);
//
//     print("📌 Timetable API Raw Response 👉 $response");
//
//     if (response["status_code"] == 200 || response["success"] == true) {
//
//       return TimetableModel.fromJson(
//         Map<String, dynamic>.from(response),   // ⭐ FIX
//       );
//
//     } else {
//       throw Exception(response["message"] ?? "Failed to fetch timetable");
//     }
//   }
// }
import 'package:school_pro/res/api_url.dart';
import '../../helper/network/network_api_services.dart';
import '../../model/school_model/time_table_model.dart';

class TimetableRepository {
  final _api = NetworkApiServices();

  /// GET /api/schooladmin/getExamTimetable?exam_id=X&class_id=Y&section_id=Z
  Future<TimetableModel> getTimetable({
    required int examId,
    required int classId,
    required int sectionId,
  }) async {
    final url =
        "${ApiUrl.timeTable}?exam_id=$examId&class_id=$classId&section_id=$sectionId";

    print("📌 Timetable API URL 👉 $url");

    final response = await _api.getGetApiResponse(url);

    print("📌 Timetable API Raw Response 👉 $response");

    if (response["status_code"] == 200 || response["success"] == true) {
      return TimetableModel.fromJson(Map<String, dynamic>.from(response));
    } else {
      throw Exception(response["message"] ?? "Failed to fetch timetable");
    }
  }
}