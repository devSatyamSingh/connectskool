import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/timetable/edit_classes_time_table_repo.dart';
import 'package:school_pro/view_model/school_view_model/classes/all_classes_view_model.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class EditClassesTimeTableViewModel with ChangeNotifier {
  final _loginRepo = EditClassesTimetableRepository();
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  Future<bool> editClassTimeTableApi(
      dynamic timetableId,
      dynamic classId,
      dynamic sectionId,
      dynamic subjectId,
      dynamic teacherId,
      dynamic dayOfWeek,
      dynamic startTime,
      dynamic endTime,
      BuildContext context,
      ) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.manageTimetable)) {

      Utils.show(
        "You don't have permission to edit timetable",
        context,
      );

      return false;
    }
    setLoading(true);

    Map data = {
      "timetable_id": timetableId,
      "class_id": classId,
      "section_id":sectionId,
      "subject_id":subjectId,
      "teacher_id":teacherId,
      "day_of_week":dayOfWeek,
      "start_time":startTime,
      "end_time":endTime,
    };


    try {
      final response = await _loginRepo.editClassTimeTableApi(data);

      setLoading(false);

      if (response['status_code'] == 200 ||
          response['status_code'] == 201) {

        Utils.show(response['message'], context);

        Provider.of<AllClassesViewModel>(
          context,
          listen: false,
        ).allClassesApi(context);
        return true; // ✅ bas yahin khatam
      }

      Utils.show(response['message'] ?? "Something went wrong", context);
      return false;

    } catch (e) {
      setLoading(false);
      Utils.show("Network error", context);
      return false;
    }
  }

}
