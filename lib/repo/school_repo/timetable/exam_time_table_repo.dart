import '../../../helper/network/network_api_services.dart';
import '../../../model/school_model/timetable/get_school_exam_time_table_model.dart';
import '../../../res/api_url.dart';

class ExamTimetableRepository {
  final _api = NetworkApiServices();

  Future<ExamTimeTableModel> getExamTimetable({
    required int examId,
    required int classId,
    required int sectionId,
  }) async {
    final url =
        "${ApiUrl.getExamTimeTable}?exam_id=$examId&class_id=$classId&section_id=$sectionId";

    print(" Exam Timetable API URL  $url");
    final response = await _api.getGetApiResponse(url);
    print(" Exam Timetable API Raw Response  $response");

    if (response["status_code"] == 200 || response["success"] == true) {
      return ExamTimeTableModel.fromJson(Map<String, dynamic>.from(response));
    } else {
      throw Exception(response["message"] ?? "Failed to fetch Exam timetable");
    }
  }
}