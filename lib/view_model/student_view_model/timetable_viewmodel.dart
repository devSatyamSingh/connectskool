import 'package:flutter/material.dart';

import '../../model/student_model/timetable_model.dart';
import '../../repo/student_repo/timetable_repo.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';

class SchoolTimetableViewModel extends ChangeNotifier {
  final _repo = SchoolTimetableRepo();

  bool loading = false;

  SchoolTimetableModel? timetableModel;

  Future<void> getTimetable(
      BuildContext context,
      String classId,
      String sectionId,
      ) async {

    if (!PermissionExtensions.canAccess(
        PermissionKeys.viewTimetable)) {

      Utils.show(
        "You don't have permission to view timetable",
        context,
      );

      return;
    }

    loading = true;
    notifyListeners();

    try {
      final response = await _repo.getTimetable(classId, sectionId);

      timetableModel = SchoolTimetableModel.fromJson(
        Map<String, dynamic>.from(response),
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    loading = false;
    notifyListeners();
  }
}
