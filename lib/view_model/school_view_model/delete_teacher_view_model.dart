import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/delete_teacher_repo.dart';
import 'package:school_pro/view_model/school_view_model/all_teachers_view_model.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';

class DeleteTeacherViewModel with ChangeNotifier {
  final _repo = DeleteTeacherRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> deleteTeacherApi(
      dynamic teacherId,
      BuildContext context,
      ) async {

    if (!PermissionExtensions.canAccess(
        PermissionKeys.deleteTeacher)) {
      Utils.show(
        "You don't have permission to delete teacher",
        context,
      );
      return false;
    }

    setLoading(true);

    Map<String, dynamic> data = {
      "teacher_id": teacherId,
    };

    try {
      // ✅ Pass the data to repo
      final response = await _repo.deleteTeacherApi(data);

      setLoading(false);

      final statusCode = response['status_code'];
      final message = response['message'];

      if (statusCode == 200 || statusCode == 201) {
        Utils.show(message ?? "Subject deleted successfully", context);

        // Refresh subjects list
        Provider.of<AllTeachersListVieModel>(context, listen: false)
            .allTeachersListApi(context);

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
