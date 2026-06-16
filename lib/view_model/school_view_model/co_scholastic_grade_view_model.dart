import 'package:flutter/material.dart';

import '../../model/school_model/all_student_list_model.dart';
import '../../model/school_model/all_subjects_model.dart';
import '../../model/school_model/co_scholastic_grade_model.dart';
import '../../repo/school_repo/co_scholastic_grade_repo.dart';
import '../../utils/utils.dart';

class CoScholasticGradeViewModel extends ChangeNotifier {
  final CoScholasticGradeRepo _repo = CoScholasticGradeRepo();

  bool _loading = false;

  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  /// ============================
  /// TABLE DATA
  /// ============================

  List<StudentData> students = [];

  List<Data> subjects = [];

  String currentAcademicYear = "";

  String currentTerm = "term1";

  /// student_subject -> grade

  final Map<String, String> selectedGrades = {};

  /// student_subject -> existing row

  final Map<String, CoScholasticGradeData> existingGrades = {};

  CoScholasticGradeModel? _gradeModel;

  CoScholasticGradeModel? get gradeModel => _gradeModel;

  void setModel(CoScholasticGradeModel model) {
    _gradeModel = model;
    notifyListeners();
  }

  String _key(int studentId, int subjectId) {
    return "${studentId}_$subjectId";
  }

  /// ============================
  /// STUDENTS
  /// ============================

  void setStudents(List<StudentData> data) {
    students = data;
    notifyListeners();
  }

  /// ============================
  /// SUBJECTS
  /// ============================

  void setSubjects(List<Data> data) {
    subjects = data
        .where((e) => (e.assessmentModel ?? "").toLowerCase().contains("co"))
        .toList();

    notifyListeners();
  }

  /// ============================
  /// SET GRADE
  /// ============================

  void updateGrade({
    required int studentId,
    required int subjectId,
    required String grade,
  }) {
    selectedGrades[_key(studentId, subjectId)] = grade;

    notifyListeners();
  }

  /// ============================
  /// GET GRADE
  /// ============================

  String? getGrade({required int studentId, required int subjectId}) {
    return selectedGrades[_key(studentId, subjectId)];
  }

  /// ============================
  /// LOAD EXISTING GRADES
  /// ============================

  Future<void> getGradesApi({
    required String studentId,
    required String academicYear,
    required BuildContext context,
  }) async {
    setLoading(true);

    try {
      final response = await _repo.getGradesApi(
        studentId: studentId,
        academicYear: academicYear,
      );

      if (response['status_code'] == 200) {
        final body = Map<String, dynamic>.from(response);

        body.remove('status_code');

        final model = CoScholasticGradeModel.fromJson(body);

        setModel(model);


        for (final item in model.data ?? []) {
          if (item.studentId == null || item.subjectId == null) {
            continue;
          }

          final key = _key(item.studentId!, item.subjectId!);

          if ((item.grade ?? "").isNotEmpty) {

            selectedGrades[key] = item.grade!;

          }

          existingGrades[key] = item;
        }

        notifyListeners();
      }
    } catch (e) {
      Utils.show("Failed to load grades", context);
    } finally {
      setLoading(false);
    }
  }

  /// ============================
  /// CREATE
  /// ============================

  Future<bool> createGradeApi({
    required int studentId,
    required int subjectId,
    required String term,
    required String grade,
    required String academicYear,
    required BuildContext context,
  }) async {
    try {
      final response = await _repo.createGradeApi({
        "student_id": studentId,
        "subject_id": subjectId,
        "term": term,
        "grade": grade,
        "academic_year": academicYear,
      });

      return response['status_code'] == 200 || response['status_code'] == 201;
    } catch (e) {
      return false;
    }
  }

  /// ============================
  /// UPDATE
  /// ============================

  Future<bool> updateGradeApi({
    required int gradeId,
    required String grade,
    required BuildContext context,
  }) async {
    try {
      final response = await _repo.updateGradeApi(
        gradeId: gradeId,
        grade: grade,
      );

      return response['status_code'] == 200;
    } catch (e) {
      return false;
    }
  }

  /// ============================
  /// DELETE
  /// ============================

  Future<bool> deleteGradeApi({
    required int gradeId,
    required BuildContext context,
  }) async {
    try {
      final response = await _repo.deleteGradeApi(gradeId: gradeId);

      return response['status_code'] == 200;
    } catch (e) {
      return false;
    }
  }

  /// ============================
  /// SAVE ALL
  /// ============================

  Future<void> saveAllGrades(BuildContext context) async {
    if (students.isEmpty || subjects.isEmpty) {
      Utils.show("No data found", context);
      return;
    }

    setLoading(true);

    try {
      for (final student in students) {
        for (final subject in subjects) {
          final key = _key(student.studentId!, subject.subjectId!);

          final grade = selectedGrades[key];

          if (grade == null || grade.isEmpty) {
            continue;
          }

          /// Existing

          if (existingGrades.containsKey(key)) {
            final existing = existingGrades[key]!;

            await updateGradeApi(
              gradeId: existing.coScholasticGradesId!,
              grade: grade,
              context: context,
            );
          }
          /// New
          else {
            await createGradeApi(
              studentId: student.studentId!,
              subjectId: subject.subjectId!,
              term: currentTerm,
              grade: grade,
              academicYear: currentAcademicYear,
              context: context,
            );
          }
        }
      }

      Utils.show("Grades Saved Successfully", context);
    } catch (e) {
      Utils.show("Failed To Save Grades", context);
    } finally {
      setLoading(false);
    }
  }

  /// ============================
  /// CLEAR
  /// ============================

  void clear() {
    students.clear();

    subjects.clear();

    selectedGrades.clear();

    existingGrades.clear();

    _gradeModel = null;

    notifyListeners();
  }

  void clearGradeMaps() {

    selectedGrades.clear();

    existingGrades.clear();

    notifyListeners();
  }
}
