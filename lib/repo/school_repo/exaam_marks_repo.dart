import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:school_pro/res/api_url.dart';
import 'package:school_pro/view_model/user_view_model.dart';

class ExamMarksRepository {

  Future<Map<String, dynamic>> getExamMarks({
    required String examId,
    required String timetableId,
    required String classId,
    required String sectionId,
    String? studentId, // optional — agar specific student chahiye
  }) async {
    try {
      final token = await UserViewModel().getToken();

      final Map<String, String> queryParams = {
        'exam_id': examId,
        'timetable_id': timetableId,
        'class_id': classId,
        'section_id': sectionId,
      };

      // student_id optional hai — sirf tab bhejo jab chahiye
      if (studentId != null) {
        queryParams['student_id'] = studentId;
      }

      final uri = Uri.parse(ApiUrl.getExamMarks).replace(
        queryParameters: queryParams,
      );
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 10));

      print("📦 Status: ${response.statusCode}");
      print("📦 Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Something went wrong',
        };
      }

    } on SocketException {
      return {'success': false, 'message': 'No Internet Connection'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}