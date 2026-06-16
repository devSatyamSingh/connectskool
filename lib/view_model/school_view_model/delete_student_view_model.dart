import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/view_model/school_view_model/all_student_list_view_model.dart';
import '../../repo/school_repo/delete_student_repo.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/permission_manager.dart';
import '../../utils/utils.dart';

class DeleteStudentViewModel with ChangeNotifier {
  final _repo = DeleteStudentRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> deleteStudentApi(
      dynamic subjectId,
      BuildContext context,
      ) async {

    if (!PermissionExtensions.canAccess(
      PermissionKeys.deleteStudent,
    )) {

      print(
        "DELETE PERMISSION FAILED",
      );

      print(
        "CURRENT PERMISSIONS => ${PermissionManager.permissions}",
      );
      Utils.show(
        "You don't have permission to delete student",
        context,
      );
      return false;
    }
    setLoading(true);

    Map<String, dynamic> data = {
      "student_id": subjectId,
    };

    try {
      print("DELETE REQUEST => $data");
      // ✅ Pass the data to repo
      final response = await _repo.deleteStudentApi(data);

      print("DELETE RESPONSE => $response");
      setLoading(false);

      final statusCode = response['status_code'];
      final message = response['message'];

      if (statusCode == 200 || statusCode == 201) {
        Utils.show(message ?? "Subject deleted successfully", context);

        // Refresh subjects list
        Provider.of<AllStudentListVieModel>(context, listen: false)
            .allStudentListApi(context);

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
        Utils.show("You don't have permission to perform this action, context", context);
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
