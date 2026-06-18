import 'package:flutter/material.dart';
import '../../../model/school_model/timetable/get_school_exam_time_table_model.dart'; // ExamTimeTableModel
import '../../../repo/school_repo/timetable/exam_time_table_repo.dart';

class SchoolExamTimeTableViewModel extends ChangeNotifier {
  final _repo = ExamTimetableRepository();

  ExamTimeTableModel? _examTimeTableModel;
  bool _loading = false;
  String? _error;

  ExamTimeTableModel? get examTimeTableModel => _examTimeTableModel;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> getExamTimetable({
    required int examId,
    required int classId,
    required int sectionId,
    required BuildContext context,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _examTimeTableModel = await _repo.getExamTimetable(
        examId: examId,
        classId: classId,
        sectionId: sectionId,
      );
      print("✅ Timetable loaded: ${_examTimeTableModel?.data?.length} entries");
    } catch (e) {
      _error = e.toString();
      print("❌ Timetable error: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ✅ ExamTimetableData return karo
  List<ExamTimetableData> filterByDay(String day) {
    final list = _examTimeTableModel?.data ?? [];
    if (day == 'All') return list;
    return list.where((e) => e.examDate == day).toList();
  }
}