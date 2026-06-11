import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/view_model/school_view_model/Exam_management_view_model.dart';
import '../../repo/school_repo/create_exam_repo.dart';
import '../../utils/utils.dart';

class CreateExamViewModel with ChangeNotifier {
  final _loginRepo = CreateExamRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<bool> createExamApi(
      dynamic examTypeId,
      dynamic examName,
      dynamic term,
      dynamic weightagePercentage,
      dynamic academicYear,
      dynamic startDate,
      dynamic endDate,
      dynamic resultDate,
      context,
      ) async {

    setLoading(true);

    Map data = {
      "exam_type_id": examTypeId,
      "exam_name": examName,
      "term": term,
      "weightage_percentage": weightagePercentage,
      "academic_year": academicYear,
      "start_date": startDate,
      "end_date": endDate,
      "result_date": resultDate
    };

    /// 🔹 REQUEST PRINT
    if (kDebugMode) {
      print("CREATE EXAM REQUEST 👉 $data");
    }

    try {

      final response = await _loginRepo.createExamApi(data);

      /// 🔹 RESPONSE PRINT
      if (kDebugMode) {
        print("CREATE EXAM RESPONSE 👉 $response");
      }

      setLoading(false);

      final statusCode = response['status_code'];
      final message = response['message'];

      if (statusCode == 200 || statusCode == 201) {

        Utils.show(message ?? "Exam created successfully", context);

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

      /// 🔹 ERROR PRINT
      if (kDebugMode) {
        print("CREATE EXAM ERROR 👉 $e");
      }

      Utils.show("Network error", context);

      return false;
    }
  }
  // Future<bool> createExamApi(
  //     dynamic examTypeId,
  //     dynamic examName,
  //     dynamic academicYear,
  //     dynamic startDate,
  //     dynamic endDate,
  //     dynamic resultDate,
  //
  //     context,
  //     ) async
  // {
  //   setLoading(true);
  //
  //   Map data = {
  //     "exam_type_id": examTypeId,
  //     "exam_name": examName,
  //     "academic_year": academicYear,
  //     "start_date": startDate,
  //     "end_date": endDate,
  //     "result_date": resultDate
  //
  //   };
  //
  //   try {
  //     final response = await _loginRepo.createExamApi(data);
  //
  //     setLoading(false);
  //
  //     final statusCode = response['status_code'];
  //     final message = response['message'];
  //
  //     if (statusCode == 200 || statusCode == 201) {
  //       Utils.show(message ?? "Class created successfully", context);
  //
  //       Navigator.pop(context);
  //       Provider.of<ExamManagementViewModel>(
  //         context,
  //         listen: false,
  //       ).examManagementApi(context);
  //       // Navigator.pushReplacementNamed(
  //       //   context,
  //       //   RoutesName.classesPage,
  //       // );
  //
  //       return true;
  //     } else if (statusCode == 400) {
  //       Utils.show(message ?? "Invalid data", context);
  //       return false;
  //     } else if (statusCode == 401) {
  //       Utils.show("Unauthorized user", context);
  //       return false;
  //     } else if (statusCode == 500) {
  //       Utils.show("Server error. Try again later", context);
  //       return false;
  //     } else {
  //       Utils.show("Something went wrong", context);
  //       return false;
  //     }
  //   } catch (e) {
  //     setLoading(false);
  //     if (kDebugMode) print("API Error: $e");
  //
  //     Utils.show("Network error", context);
  //     return false;
  //   }
  // }
}
