import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/model/school_model/student/all_student_list_model.dart';
import 'package:school_pro/repo/school_repo/student/all_student_list_repo.dart';
import 'package:school_pro/utils/utils.dart';

import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';

class AllStudentListVieModel extends ChangeNotifier {
  final _allStudentListRepo = AllStudentListRepository();

  bool _loading = false;
  bool get loading => _loading;

  bool _loadingMore = false;
  bool get loadingMore => _loadingMore;

  int _currentPage = 1;
  int _totalPages = 1;
  bool get hasMore => _currentPage < _totalPages;

  List<StudentData> _students = [];
  List<StudentData> get students => _students;

  AllStudentListModel? _allStudentListModel;
  AllStudentListModel? get allStudentListModel => _allStudentListModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void clearStudents() {
    _students = [];
    _allStudentListModel = null;
    _currentPage = 1;
    _totalPages = 1;
    notifyListeners();
  }

  // Pehla page load karne ke liye (pull to refresh / initial load)
  Future<void> allStudentListApi(
      BuildContext context, {
        String? classId,
        String? sectionId,
        bool showMessage = false,
      }) async {
    if (!PermissionExtensions.canAccess(PermissionKeys.viewAllStudent)) {
      if (showMessage) {
        Utils.show("You don't have permission to view all student", context);
      }
      return;
    }

    _currentPage = 1;
    _students = [];
    setLoading(true);

    try {
      final response = await _allStudentListRepo.allStudentListApi(
        classId: classId,
        sectionId: sectionId,
        page: _currentPage,
        limit: 20,
      );

      final int statusCode = response['status_code'] ?? 200;

      if (statusCode == 200) {
        final body = Map<String, dynamic>.from(response);
        body.remove('status_code');

        final model = AllStudentListModel.fromJson(body);
        _allStudentListModel = model;
        _students = model.data ?? [];
        _totalPages = model.pagination?.totalPages ?? 1;
      } else {
        // apna existing switch-case error handling yahan rakho
      }
    } catch (e) {
      debugPrint("Student List Error => $e");
    } finally {
      setLoading(false);
    }
  }

  // Scroll end par agla page load karne ke liye
  Future<void> loadMoreStudents(
      BuildContext context, {
        String? classId,
        String? sectionId,
      }) async {
    if (_loadingMore || !hasMore) return;

    _loadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await _allStudentListRepo.allStudentListApi(
        classId: classId,
        sectionId: sectionId,
        page: nextPage,
        limit: 20,
      );

      final int statusCode = response['status_code'] ?? 200;
      if (statusCode == 200) {
        final body = Map<String, dynamic>.from(response);
        body.remove('status_code');

        final model = AllStudentListModel.fromJson(body);
        _students.addAll(model.data ?? []);
        _currentPage = nextPage;
        _totalPages = model.pagination?.totalPages ?? _totalPages;
      }
    } catch (e) {
      debugPrint("Load more error => $e");
    } finally {
      _loadingMore = false;
      notifyListeners();
    }
  }
}