import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/model/school_model/exam_management_model.dart';
import 'package:school_pro/repo/school_repo/exam_management_repo.dart';
import 'package:school_pro/utils/utils.dart';

// class ExamManagementViewModel extends ChangeNotifier {
//   final _allStudentListRepo = ExamManagementRepository();
//
//   bool _loading = false;
//   bool get loading => _loading;
//
//   ExamManagementModel? _examManagementModel;
//   ExamManagementModel? get examManagementModel => _examManagementModel;
//
//   void setLoading(bool value) {
//     _loading = value;
//     notifyListeners();
//   }
//
//   void setModelData(ExamManagementModel value) {
//     _examManagementModel = value;
//     notifyListeners();
//   }
//
//   Future<void> examManagementApi(BuildContext context) async {
//     setLoading(true);
//
//     try {
//       final response = await _allStudentListRepo.examManagementApi();
//
//       final int statusCode = response['status_code'];
//
//       switch (statusCode) {
//         case 200:
//           final body = Map<String, dynamic>.from(response);
//           body.remove('status_code');
//
//           final model = ExamManagementModel.fromJson(body);
//           setModelData(model);
//           break;
//
//         case 401:
//           Utils.show("Unauthorized user", context);
//           break;
//
//         case 403:
//           Utils.show("Access denied", context);
//           break;
//
//         case 404:
//           Utils.show("Students not found", context);
//           break;
//
//         case 500:
//           Utils.show("Server error", context);
//           break;
//
//         case 0:
//           Utils.show("No Internet Connection", context);
//           break;
//
//         default:
//           Utils.show(response['message'] ?? "Something went wrong", context);
//       }
//     } catch (e) {
//       Utils.show("Failed to load students", context);
//     } finally {
//       setLoading(false);
//     }
//   }
// }
class ExamManagementViewModel extends ChangeNotifier {
  final _repo = ExamManagementRepository();

  bool _loading = false;
  bool get loading => _loading;

  ExamManagementModel? _examManagementModel;
  ExamManagementModel? get examManagementModel => _examManagementModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setModelData(ExamManagementModel value) {
    _examManagementModel = value;
    notifyListeners();
  }

  Future<void> examManagementApi(BuildContext context) async {
    setLoading(true);

    try {
      final response = await _repo.examManagementApi();
      final int statusCode = response['status_code'];

      if (statusCode == 200) {
        final body = Map<String, dynamic>.from(response);
        body.remove('status_code');

        setModelData(ExamManagementModel.fromJson(body));
      }
      else if (statusCode == 401) {
        _safeToast(context, "Unauthorized user");
      }
      else if (statusCode == 403) {
        _safeToast(context, "Access denied");
      }
      else if (statusCode == 404) {
        _safeToast(context, "Exams not found");
      }
      else if (statusCode == 500) {
        _safeToast(context, "Server error");
      }
      else if (statusCode == 0) {
        _safeToast(context, "No Internet Connection");
      }
      else {
        _safeToast(context, response['message'] ?? "Something went wrong");
      }
    } catch (e) {
      if (kDebugMode) print(e);
      _safeToast(context, "Failed to load exams");
    }

    setLoading(false);
  }

  /// 🔒 context safe toast
  void _safeToast(BuildContext context, String msg) {
    if (context.mounted) {
      Utils.show(msg, context);
    }
  }
}
