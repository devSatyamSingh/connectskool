import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/school_model/student/student_form_model.dart';
import '../../../repo/school_repo/student/add_student_repo.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';
import '../../../view_model/school_view_model/student/all_student_list_view_model.dart';


class AddStudentViewModel with ChangeNotifier {
  final _repo = AddStudentRepository();

  bool _loading = false;
  bool get loading => _loading;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> addStudent({
    required BuildContext context,
    required StudentFormModel form,
  }) async {
    if (!PermissionExtensions.canAccess(PermissionKeys.addStudent)) {
      Utils.show("You don't have permission to add student", context);
      return false;
    }

    _setLoading(true);

    try {
      final response = await _repo.addStudentApi(form);

      _setLoading(false);

      if (kDebugMode) debugPrint("📥 AddStudent VM Response: $response");

      final code = response["status_code"];
      if (code == 200 || code == 201) {
        Utils.show(response["message"] ?? "Student added successfully", context);
        if (context.mounted) {
          Provider.of<AllStudentListVieModel>(context, listen: false)
              .allStudentListApi(context);
        }
        return true;
      } else {
        Utils.show(response["message"] ?? "Something went wrong", context);
        return false;
      }
    } catch (e) {
      _setLoading(false);
      if (kDebugMode) debugPrint("🚨 AddStudent VM Error: $e");
      Utils.show("Network error", context);
      return false;
    }
  }
}