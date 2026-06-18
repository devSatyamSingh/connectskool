import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/exam_marks/create_exam_marks_repo.dart';
import 'package:school_pro/view_model/school_view_model/classes/all_classes_view_model.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class CreateExamMarksViewModel with ChangeNotifier {
  final _loginRepo = CreateExamMarksRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> createExamMarksApi(
      dynamic timetableId,
      dynamic studentId,
      dynamic marksObtained,
      dynamic isAbsent,
      dynamic remarks,
      context,
      ) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.assignMarks)) {

      Utils.show(
        "Permission denied",
        context,
      );

      return false;
    }
    setLoading(true);

    Map data = {
      "timetable_id": timetableId,
      "student_id": studentId,
      "marks_obtained": marksObtained,
      "is_absent": isAbsent,
      "remarks": remarks,
    };

    try {
      final response = await _loginRepo.createExamMarksApi(data);

      setLoading(false);

      final statusCode = response['status_code'];
      final message = response['message'];

      if (statusCode == 200 || statusCode == 201) {
        Utils.show(message ?? "Class created successfully", context);

        Provider.of<AllClassesViewModel>(
          context,
          listen: false,
        ).allClassesApi(context);
        Navigator.pop(context);
        // Navigator.pushReplacementNamed(
        //   context,
        //   RoutesName.classesPage,
        // );

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
      if (kDebugMode) print("API Error: $e");

      Utils.show("Network error", context);
      return false;
    }
  }
}
