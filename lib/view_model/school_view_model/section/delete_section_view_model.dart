import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/section/delete_section_repo.dart';
import 'package:school_pro/view_model/school_view_model/student/all_student_list_view_model.dart';
import '../../../repo/school_repo/student/delete_student_repo.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class DeleteSectionViewModel with ChangeNotifier {
  final _repo = DeleteSectionRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> deleteSectionApi(
      dynamic sectionId,
      BuildContext context,
      ) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.manageSections)) {

      Utils.show(
        "You don't have permission to delete section",
        context,
      );

      return false;
    }
    setLoading(true);

    Map<String, dynamic> data = {
      "section_id": sectionId,
    };

    try {
      // ✅ Pass the data to repo
      final response = await _repo.deleteSectionApi(data);

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
