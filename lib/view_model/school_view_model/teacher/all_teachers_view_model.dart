import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/model/school_model/teacher/all_teachers_list_model.dart';
import 'package:school_pro/repo/school_repo/teacher/all_teachers_list_repo.dart';
import 'package:school_pro/utils/utils.dart';

class AllTeachersListVieModel extends ChangeNotifier {
  final _allStudentListRepo = AllTeachersListRepository();

  bool _loading = false;
  bool get loading => _loading;

  bool _loadingMore = false;
  bool get loadingMore => _loadingMore;

  int _currentPage = 1;
  int _totalPages = 1;
  bool get hasMore => _currentPage < _totalPages;

  List<AllTeacherModel> _teachers = [];
  List<AllTeacherModel> get teachers => _teachers;

  AllTeachersListModel? _allTeachersListModel;
  AllTeachersListModel? get allTeachersListModel => _allTeachersListModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setModelData(AllTeachersListModel value) {
    _allTeachersListModel = value;
    notifyListeners();
  }

  void clearTeachers() {
    _teachers = [];
    _allTeachersListModel = null;
    _currentPage = 1;
    _totalPages = 1;
    notifyListeners();
  }

  // ✅ Pehla page (initial load / pull-to-refresh)
  Future<void> allTeachersListApi(BuildContext context) async {
    _currentPage = 1;
    _teachers = [];
    setLoading(true);

    try {
      final response = await _allStudentListRepo.allTeachersListApi(
        page: _currentPage,
        limit: 20,
      );

      final int statusCode = response['status_code'] ?? 0;

      switch (statusCode) {
        case 200:
          final body = Map<String, dynamic>.from(response);
          body.remove('status_code');

          final model = AllTeachersListModel.fromJson(body);
          _allTeachersListModel = model;
          _teachers = model.data;
          _totalPages = model.pagination?.totalPages ?? 1;

          if (kDebugMode) {
            print("✅ Teachers fetched (page 1): ${model.data.length}");
          }
          break;

        case 401:
          Utils.show("Unauthorized user", context);
          break;
        case 403:
          Utils.show("Access denied", context);
          break;
        case 404:
          Utils.show("Teachers not found", context);
          break;
        case 500:
          Utils.show("Server error", context);
          break;
        case 0:
          Utils.show("No Internet Connection", context);
          break;
        default:
          Utils.show(response['message'] ?? "Something went wrong", context);
      }
    } catch (e) {
      print("❌ Exception fetching teachers: $e");
      Utils.show("Failed to load teachers", context);
    } finally {
      setLoading(false);
    }
  }

  // ✅ "View More" click par next page load karega
  Future<void> loadMoreTeachers(BuildContext context) async {
    if (_loadingMore || !hasMore) return;

    _loadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await _allStudentListRepo.allTeachersListApi(
        page: nextPage,
        limit: 20,
      );

      final int statusCode = response['status_code'] ?? 0;

      if (statusCode == 200) {
        final body = Map<String, dynamic>.from(response);
        body.remove('status_code');

        final model = AllTeachersListModel.fromJson(body);
        _teachers.addAll(model.data);
        _currentPage = nextPage;
        _totalPages = model.pagination?.totalPages ?? _totalPages;

        if (kDebugMode) {
          print("✅ Teachers fetched (page $nextPage): ${model.data.length}, total loaded: ${_teachers.length}");
        }
      } else {
        Utils.show(response['message'] ?? "Something went wrong", context);
      }
    } catch (e) {
      print("❌ Load more teachers error: $e");
      Utils.show("Failed to load more teachers", context);
    } finally {
      _loadingMore = false;
      notifyListeners();
    }
  }
}