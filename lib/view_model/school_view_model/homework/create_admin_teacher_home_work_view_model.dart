import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/teacher/add_teachers_repo.dart';
import 'package:school_pro/repo/school_repo/homework/create_admin_teacher_homework.dart';
import 'package:school_pro/view_model/school_view_model/accountant/all_accountant_list_view_model.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class CreateAdminTeachersHomeworkViewModel with ChangeNotifier {
  final _loginRepo = CreateAdminTeachersHomeworkRepository();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> createAdminTeachersApi({
    required BuildContext context,
    required String classId,
    required String sectionId,
    required String subjectId,
    required String description,
    String? dueDate,

    File? submissionPdf,
    File? submissionPhoto,

    required int allowSubmission,
  }) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.teacherCreateHomework)) {

      Utils.show(
        "You don't have permission to create homework",
        context,
      );

      return false;
    }
    setLoading(true);

    try {
      ///  Fields Map — PDF ka sirf naam bhejte hain
      final Map<String, String> fields = {
        "class_id": classId,
        "section_id": sectionId,
        "subject_id": subjectId,
        "description": description,
        "allow_submission": allowSubmission.toString(),
      };
if (dueDate != null && dueDate.trim().isNotEmpty) {
  fields["due_date"] = dueDate.trim();
}

      final Map<String, dynamic> files = {};

      if (submissionPdf != null) {
        files["submission_pdf"] = submissionPdf;
      }

      if (submissionPhoto != null) {
        files["submission_photos"] = submissionPhoto;
      }

      print("Fields Map => $fields");

      final response = await _loginRepo.createAdminTeachersApi(fields, files);
      print("Status Code => ${response["status_code"]}");
      print("Message => ${response["message"]}");

      setLoading(false);

      if (response["status_code"] == 200 || response["status_code"] == 201) {
        Utils.show(response["message"] ?? "Homework Created", context);
        Navigator.pop(context);
        return true;
      } else {
        Utils.show(response["message"] ?? "Something went wrong", context);
        return false;
      }
    } catch (e, stackTrace) {
      setLoading(false);
      print("Error => $e");
      print("StackTrace => $stackTrace");
      Utils.show("Network error", context);
      return false;
    }
  }
}
