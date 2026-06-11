import 'package:flutter/material.dart';
import '../../model/school_model/exam_marks_model.dart';
import '../../repo/school_repo/exaam_marks_repo.dart';

class ExamMarksViewModel extends ChangeNotifier {
  final ExamMarksRepository _repo = ExamMarksRepository();

  ExamMarksModel? _examMarksModel;
  bool _loading = false;
  String? _errorMessage;

  ExamMarksModel? get examMarksModel => _examMarksModel;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  List<ExamMarksData> get marksList => _examMarksModel?.data ?? [];
  Future<void> getExamMarksApi({
    required String examId,
    required String timetableId,
    required String classId,
    required String sectionId,
    List<Map<String, dynamic>>? students, // ← required se optional karo
    required BuildContext context,
  }) async {
    _loading = true;
    _examMarksModel = null;
    notifyListeners();

    final List<ExamMarksData> allMarks = [];

    // ── Agar students list hai toh har student ke liye call karo ──
    if (students != null && students.isNotEmpty) {
      for (final student in students) {
        final studentId = student['student_id']?.toString();
        if (studentId == null) continue;

        final response = await _repo.getExamMarks(
          examId: examId,
          timetableId: timetableId,
          classId: classId,
          sectionId: sectionId,
          studentId: studentId,
        );

        if (response['success'] == true) {
          final model = ExamMarksModel.fromJson(response['data']);
          if (model.data != null && model.data!.isNotEmpty) {
            allMarks.addAll(model.data!);
          } else {
            allMarks.add(ExamMarksData(
              studentId: int.tryParse(studentId),
              studentName: student['student_name'] ?? '',
              admissionNo: student['admission_no']?.toString() ?? '',
              gender: student['gender'] ?? '',
              marksObtained: null,
              totalMarks: 100,
            ));
          }
        }
      }
    } else {
      // ── Students list nahi — direct call without student_id ──
      final response = await _repo.getExamMarks(
        examId: examId,
        timetableId: timetableId,
        classId: classId,
        sectionId: sectionId,
      );
      if (response['success'] == true) {
        final model = ExamMarksModel.fromJson(response['data']);
        allMarks.addAll(model.data ?? []);
      }
    }

    print("✅ Total marks loaded: ${allMarks.length}");
    _examMarksModel = ExamMarksModel(success: true, message: 'Loaded', data: allMarks);
    _loading = false;
    notifyListeners();
  }
  // Future<void> getExamMarksApi({
  //   required String examId,
  //   required String timetableId,
  //   required String classId,
  //   required String sectionId,
  //   required BuildContext context,
  // }) async
  // {
  //   _loading = true;
  //   _errorMessage = null;
  //   notifyListeners();
  //
  //   final response = await _repo.getExamMarks(
  //     examId: examId,
  //     timetableId: timetableId,
  //     classId: classId,
  //     sectionId: sectionId,
  //   );
  //
  //   print("📦 VM Response: $response");
  //
  //   if (response['success'] == true) {
  //     _examMarksModel = ExamMarksModel.fromJson(response['data']);
  //     print("✅ Marks count: ${_examMarksModel?.data?.length}");
  //   } else {
  //     _errorMessage = response['message'] ?? 'Something went wrong';
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(_errorMessage ?? 'Error'),
  //           backgroundColor: Colors.red,
  //           behavior: SnackBarBehavior.floating,
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(12)),
  //         ),
  //       );
  //     }
  //   }
  //
  //   _loading = false;
  //   notifyListeners();
  // }

  void clearMarks() {
    _examMarksModel = null;
    _errorMessage = null;
    notifyListeners();
  }
}