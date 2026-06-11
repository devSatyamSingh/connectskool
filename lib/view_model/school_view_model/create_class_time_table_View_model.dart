import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/create_class_timetable_repo.dart';
import 'package:school_pro/view_model/school_view_model/Exam_management_view_model.dart';
import '../../utils/utils.dart';

class CreateClassTimetableViewModel with ChangeNotifier {

  final _loginRepo = CreateClassTimeTableRepository();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> createClassTimeTableApi(
      dynamic classId,
      dynamic sectionId,
      dynamic subjectId,
      dynamic teacherId,
      dynamic dayOfWeek,
      dynamic startTime,
      dynamic endTime,
      context,
      ) async {

    print("========== CREATE TIMETABLE API ==========");

    print("classId: $classId");
    print("sectionId: $sectionId");
    print("subjectId: $subjectId");
    print("teacherId: $teacherId");
    print("dayOfWeek: $dayOfWeek");
    print("startTime: $startTime");
    print("endTime: $endTime");

    setLoading(true);

    Map data = {
      "class_id": classId,
      "section_id": sectionId,
      "subject_id": subjectId,
      "teacher_id": teacherId,
      "day_of_week": dayOfWeek,
      "start_time": startTime,
      "end_time": endTime
    };

    print("API Request Body: $data");

    try {

      final response = await _loginRepo.createClassTimeTableApi(data);

      print("API Response: $response");

      setLoading(false);

      final statusCode = response['status_code'];
      final message = response['message'];

      print("Status Code: $statusCode");
      print("Message: $message");

      if (statusCode == 200 || statusCode == 201) {

        Utils.show(message ?? "Timetable created successfully", context);

        Navigator.pop(context);

        Provider.of<ExamManagementViewModel>(
          context,
          listen: false,
        ).examManagementApi(context);

        return true;

      } else if (statusCode == 400) {

        Utils.show(message ?? "Invalid data", context);
        return false;

      } else if (statusCode == 401) {

        Utils.show("Unauthorized user", context);
        return false;

      } else if (statusCode == 500) {

        Utils.show("Server error. Try again later", context);
        return false;

      } else {

        Utils.show("Something went wrong", context);
        return false;
      }

    } catch (e) {

      setLoading(false);

      if (kDebugMode) {
        print("API Error: $e");
      }

      Utils.show("Network error", context);

      return false;
    }
  }
}