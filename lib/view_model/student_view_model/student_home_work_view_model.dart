import 'package:flutter/material.dart';
import 'package:school_pro/model/student_model/student_home_work_model.dart';
import 'package:school_pro/repo/student_repo/student_home_work_repo.dart';
import 'package:school_pro/utils/utils.dart';

class StudentHomeworkViewModel extends ChangeNotifier {
  final StudentHomeworkRepository _repository =
  StudentHomeworkRepository();

  bool _loading = false;
  bool get loading => _loading;

  StudentHomeworkModel? _studentHomeworkModel;
  StudentHomeworkModel? get studentHomeworkModel =>
      _studentHomeworkModel;

  List<StudentProfileData> _homeworkList = [];
  List<StudentProfileData> get homeworkList =>
      List.unmodifiable(_homeworkList);

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> studentHomeWorkApi(BuildContext context) async {
    _setLoading(true);

    try {
      final response =
      await _repository.studentHomeWorkApi();

      final int statusCode =
          response['status_code'] ?? 500;

      if (statusCode == 200) {
        final body =
        Map<String, dynamic>.from(response);

        body.remove('status_code');

        _studentHomeworkModel =
            StudentHomeworkModel.fromJson(body);

        _homeworkList =
            _studentHomeworkModel?.data ?? [];
      } else {
        _handleError(
          statusCode,
          response,
          context,
        );
      }
    } catch (e) {
      debugPrint(
        'Student Homework Error => $e',
      );

      Utils.show(
        "Failed to load homework",
        context,
      );
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshHomework(
      BuildContext context) async {
    await studentHomeWorkApi(context);
  }

  void clearData() {
    _studentHomeworkModel = null;
    _homeworkList.clear();
    notifyListeners();
  }

  void _handleError(
      int statusCode,
      Map response,
      BuildContext context,
      ) {
    switch (statusCode) {
      case 401:
        Utils.show(
          "Unauthorized user",
          context,
        );
        break;

      case 403:
        Utils.show(
          "Access denied",
          context,
        );
        break;

      case 404:
        Utils.show(
          "Homework not found",
          context,
        );
        break;

      case 500:
        Utils.show(
          "Server error",
          context,
        );
        break;

      case 0:
        Utils.show(
          "No Internet Connection",
          context,
        );
        break;

      default:
        Utils.show(
          response['message'] ??
              "Something went wrong",
          context,
        );
    }
  }

  // -------------------------
  // Helper Methods For UI
  // -------------------------

  bool isSubmitted(
      StudentProfileData homework) {
    return homework.status == "submitted" ||
        homework.submittedAt != null;
  }

  bool isPending(
      StudentProfileData homework) {
    return homework.allowSubmission == 1 &&
        homework.submittedAt == null;
  }

  bool isOfflineHomework(
      StudentProfileData homework) {
    return homework.allowSubmission == 0 ||
        homework.allowSubmission == null;
  }

  bool canSubmitOnline(
      StudentProfileData homework) {
    return homework.allowSubmission == 1 &&
        homework.submittedAt == null;
  }

  bool showSubmitAtSchool(
      StudentProfileData homework) {
    return (homework.allowSubmission == 0 ||
        homework.allowSubmission == null) &&
        homework.submittedAt == null;
  }

  bool hasPdf(
      StudentProfileData homework) {
    return homework.attachment != null;
  }

  bool hasPhotos(
      StudentProfileData homework) {
    return homework.attachmentPhotos
        ?.isNotEmpty ??
        false;
  }
}