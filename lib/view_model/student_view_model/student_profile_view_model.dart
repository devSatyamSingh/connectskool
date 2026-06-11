// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:school_pro/repo/student_repo/student_profile_repo.dart';
// import '../../model/student_model/student_profile_model.dart';
// import '../user_view_model.dart';
//
// class StudentProfileViewModel with ChangeNotifier {
//   final _loginRepo = StudentProfileRepository();
//
//   bool _loading = false;
//   bool get loading => _loading;
//
//   StudentProfileModel? _studentProfileModel;
//   StudentProfileModel? get studentProfileModel => _studentProfileModel;
//
//   void setLoading(bool value) {
//     _loading = value;
//     notifyListeners();
//   }
//
//   void setModelData(StudentProfileModel value) {
//     _studentProfileModel = value;
//     notifyListeners();
//   }
//
//   Future<void> studentProfileApi( BuildContext context) async {
//     // UserViewModel userViewModel = UserViewModel();
//     // int? id = await userViewModel.getStudentId();
//
//     // print("🎯 Student ID From SP: $id");
//
//     // if (id == null) {
//     //   print("❌ Student ID NULL");
//     //   return;
//     // }
//
//     final response = await _loginRepo.studentProfileApi(context);
//     setLoading(true);
//
//     try {
//
//       final response = await _loginRepo.studentProfileApi();
//
//       debugPrint("📥 Raw student profile API Response: $response");
//
//       final Map<String, dynamic> json =
//       Map<String, dynamic>.from(response);
//
//       debugPrint("✅ Parsed student Profile JSON: $json");
//
//       if (json['success'] == true) {
//         final model = StudentProfileModel.fromJson(json);
//
//         // debugPrint(
//         //   "📚 Homework Count: ${model.data?.length ?? 0}",
//         // );
//
//         setModelData(model);
//       } else {
//         debugPrint("⚠️ student profile API failed");
//       }
//     } catch (e, stack) {
//       debugPrint("❌ student profile API error: $e");
//       debugPrint("🧵 StackTrace: $stack");
//     }
//
//     setLoading(false);
//   }
//
// }
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/repo/student_repo/student_profile_repo.dart';
import '../../model/student_model/student_profile_model.dart';

class StudentProfileViewModel with ChangeNotifier {
  final StudentProfileRepository _loginRepo = StudentProfileRepository();

  bool _loading = false;
  bool get loading => _loading;

  StudentProfileModel? _studentProfileModel;
  StudentProfileModel? get studentProfileModel => _studentProfileModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setModelData(StudentProfileModel value) {
    _studentProfileModel = value;
    notifyListeners();
  }

  Future<void> studentProfileApi(BuildContext context) async {
    setLoading(true);

    try {
      final response = await _loginRepo.studentProfileApi();

      debugPrint("📥 Raw API Response: $response");

      if (response == null) {
        debugPrint("❌ API returned null response");
        return;
      }

      final Map<String, dynamic> json =
      Map<String, dynamic>.from(response);

      debugPrint("✅ Parsed JSON: $json");

      if (json['success'] == true) {
        final model = StudentProfileModel.fromJson(json);
        setModelData(model);
      } else {
        debugPrint("⚠️ API failed: ${json['message']}");
      }
    } catch (e, stack) {
      debugPrint("❌ API Error: $e");
      debugPrint("🧵 StackTrace: $stack");
    } finally {
      setLoading(false);
    }
  }
}