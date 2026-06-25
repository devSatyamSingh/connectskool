import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/school_model/student/student_form_model.dart';
import '../../../repo/school_repo/student/edit_student_repo.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';
import '../../../view_model/school_view_model/student/all_student_list_view_model.dart';


class EditStudentViewModel with ChangeNotifier {
  final _repo = EditStudentRepository();

  bool _loading = false;
  bool get loading => _loading;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> editStudent({
    required BuildContext context,
    required String studentId,
    required StudentFormModel form,
  }) async {
    if (!PermissionExtensions.canAccess(PermissionKeys.editStudent)) {
      Utils.show("You don't have permission to edit student", context);
      return false;
    }

    _setLoading(true);

    try {
      final response = await _repo.editStudentApi(
        studentId: studentId,
        form: form,
      );

      _setLoading(false);

      if (kDebugMode) debugPrint("📥 EditStudent VM Response: $response");

      final code = response["status_code"];
      if (code == 200 || code == 201) {
        Utils.show(response["message"] ?? "Student updated successfully", context);
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
      if (kDebugMode) debugPrint("🚨 EditStudent VM Error: $e");
      Utils.show("Network error", context);
      return false;
    }
  }
}