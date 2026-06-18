import 'package:flutter/material.dart';
import '../../../model/school_model/timetable/classes_time_table_model.dart';
import '../../../repo/school_repo/classes/get_classes_time_table_repo.dart';

class GetClassesTimeTableViewModel with ChangeNotifier {

  final _repo = GetClassTimeTableRepository();

  bool _loading = false;
  bool get loading => _loading;

  List<TimeTableData> timetableList = [];
  void setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

  Future<void> getTimeTable({
    required int classId,
    required int sectionId,
  }) async {

    setLoading(true);

    try {

      final response =
      await _repo.getClassTimeTableApi(classId, sectionId);

      setLoading(false);

      if (response['success'] == true) {
        timetableList = (response['data'] as List)
            .map((e) => TimeTableData.fromJson(e))
            .toList();
      } else {
        timetableList = [];
      }

      notifyListeners();

    } catch (e) {

      setLoading(false);
      debugPrint("TimeTable Error: $e");
    }
  }
}