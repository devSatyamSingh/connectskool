// import 'package:flutter/material.dart';
// import '../../model/school_model/time_table_model.dart';
// import '../../repo/school_repo/exam_timetable_repo.dart';
// import '../../utils/permission_extensions.dart';
// import '../../utils/permission_keys.dart';
// import '../../utils/utils.dart';
//
// class TimeTableViewModel extends ChangeNotifier {
//   final _repo = TimetableRepository();
//
//   TimetableModel? _timetableModel;
//   bool _loading = false;
//   String? _error;
//
//   TimetableModel? get timetableModel => _timetableModel;
//   bool get loading => _loading;
//   String? get error => _error;
//
//   Future<void> getTimetable({
//     required int examId,       // ✅ NEW — required
//     required int classId,
//     required int sectionId,
//     required BuildContext context,
//   }) async {
//     if (!PermissionExtensions.canAccess(
//         PermissionKeys.viewExamTimetable)) {
//
//       Utils.show(
//         "You don't have permission to perform this action",
//         context,
//       );
//
//       return;
//     }
//     _loading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       _timetableModel = await _repo.getTimetable(
//         examId: examId,
//         classId: classId,
//         sectionId: sectionId,
//       );
//       print("✅ Timetable loaded: ${_timetableModel?.data?.length} entries");
//     } catch (e) {
//       _error = e.toString();
//       print("❌ Timetable error: $e");
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }
//
//   /// Filter loaded data by day. Pass 'All' to get everything.
//   List<TimetableData> filterByDay(String day) {
//     final list = _timetableModel?.data ?? [];
//     if (day == 'All') return list;
//     return list.where((e) => e.dayOfWeek == day).toList();
//   }
// }