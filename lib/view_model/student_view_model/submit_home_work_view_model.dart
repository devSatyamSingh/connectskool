// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:school_pro/repo/student_repo/submit_home_work_repo.dart';
// import 'package:school_pro/view_model/school_view_model/all_accountant_list_view_model.dart';
// import '../../utils/utils.dart';
//
// class SubmitHomeworkViewModel with ChangeNotifier {
//   final _loginRepo = SubmitHomeworkRepository();
//
//   bool _loading = false;
//   bool get loading => _loading;
//
//   void setLoading(bool value) {
//     _loading = value;
//     notifyListeners();
//   }
//
//   Future<bool> submitHomeworkApi({
//     required BuildContext context,
//     required String homeworkId,
//     File? attachments,
//   }) async {
//     setLoading(true);
//
//     try {
//       final Map<String, String> fields = {
//         "homework_id": homeworkId
//       };
//
//       final Map<String, dynamic> files = {
//         "attachments": attachments,
//       };
//
//       final response = await _loginRepo.submitHomeworkApi(fields, files);
//
//       setLoading(false);
//
//       if (response["status_code"] == 200 ||
//           response["status_code"] == 201) {
//         Utils.show(response["message"] ?? "Accountant added", context);
//
//         Provider.of<AllAccountantListVieModel>(
//           context,
//           listen: false,
//         ).allAccountantListApi(context);
//
//         return true;
//       } else {
//         Utils.show(response["message"] ?? "Something went wrong", context);
//         return false;
//       }
//     } catch (e) {
//       setLoading(false);
//       if (kDebugMode) {
//         print("Add Accountant Error: $e");
//       }
//       Utils.show("Network error", context);
//       return false;
//     }
//   }
// }
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/student_repo/submit_home_work_repo.dart';
import 'package:school_pro/view_model/school_view_model/all_accountant_list_view_model.dart';
import 'package:school_pro/view_model/student_view_model/student_home_work_view_model.dart';
import '../../utils/utils.dart';

class SubmitHomeworkViewModel with ChangeNotifier {
  final SubmitHomeworkRepository _repo =
  SubmitHomeworkRepository();

  bool _loading = false;
  bool get loading => _loading;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }



  Future<bool> submitHomeworkApi({
    required BuildContext context,
    required String homeworkId,
    File? attachments,
  }) async {
    _setLoading(true);

    try {
      final Map<String, String> fields = {
        "homework_id": homeworkId,
      };

      final Map<String, dynamic> files = {
        "submission_pdf": attachments,
      };

      final response =
      await _repo.submitHomeworkApi(
        fields,
        files,
      );

      if (response["status_code"] == 200 ||
          response["status_code"] == 201) {

        /// Instant UI Update
        final homeworkVm =
        Provider.of<StudentHomeworkViewModel>(
          context,
          listen: false,
        );

        /// Sync with server
        await homeworkVm.studentHomeWorkApi(
          context,
        );

        Utils.show(
          response["message"] ??
              "Homework submitted successfully",
          context,
        );

        return true;
      }

      Utils.show(
        response["message"] ??
            "Something went wrong",
        context,
      );

      return false;
    } catch (e) {
      if (kDebugMode) {
        print(
          "Submit Homework Error => $e",
        );
      }

      Utils.show(
        "Network error",
        context,
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }
}