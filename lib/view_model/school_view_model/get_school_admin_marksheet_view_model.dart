
import 'package:flutter/material.dart';
import 'package:school_pro/model/school_model/school_admin_marksheet_model.dart';
import '../../repo/school_repo/get_school_admin_marksheet_repo.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';

class GetCoScholasticViewModel with ChangeNotifier {

  final _repo = GetCoScholasticRepo();
  bool loading = false;
  SchoolAdminMarkSheetModel marksheetModel = SchoolAdminMarkSheetModel();

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }
  Future<void> getCoScholasticGrades(
      String studentId,
      String academicYear,
      BuildContext context,
      ) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.viewMarks)) {

      Utils.show(
        "You don't have permission to perform this action",
        context,
      );

      return;
    }
    setLoading(true);

    try {
      final value =
      await _repo.getCoScholasticGradesApi(studentId, academicYear);

      debugPrint('📦 Raw API response type: ${value.runtimeType}');
      debugPrint('📦 Raw API response: $value');

      Map<String, dynamic> jsonMap;

      if (value is Map) {
        // 🔥 Convert dynamic map to String map safely
        jsonMap = value.map(
              (key, value) => MapEntry(key.toString(), value),
        );

        if (jsonMap.containsKey('status_code')) {
          jsonMap.remove('status_code');
        }
      } else if (value is List) {
        if (value.isNotEmpty && value.first is Map) {
          jsonMap = (value.first as Map).map(
                (key, value) => MapEntry(key.toString(), value),
          );

          jsonMap.remove('status_code');
        } else {
          jsonMap = {'success': false, 'data': null};
        }
      } else {
        jsonMap = {'success': false, 'data': null};
      }

      marksheetModel = SchoolAdminMarkSheetModel.fromJson(jsonMap);

    } catch (error, stack) {
      debugPrint('❌ ERROR in getCoScholasticGrades: $error');
      debugPrint('📍 Stack: $stack');
    } finally {
      setLoading(false);
    }
  }
  // Future<void> getCoScholasticGrades(
  //     String studentId,
  //     String academicYear,
  //     BuildContext context,
  //     ) async
  // {
  //   setLoading(true);
  //   try {
  //     final value = await _repo.getCoScholasticGradesApi(studentId, academicYear);
  //
  //     debugPrint('📦 Raw API response type: ${value.runtimeType}');
  //     debugPrint('📦 Raw API response: $value');
  //
  //     Map<String, dynamic> jsonMap;
  //
  //     if (value is Map) {
  //       // 🔥 YAHI CHANGE KARNA HAI
  //       jsonMap = value.map(
  //             (key, value) => MapEntry(key.toString(), value),
  //       );
  //
  //       if (jsonMap.containsKey('status_code')) {
  //         jsonMap.remove('status_code');
  //       }
  //     } else if (value is List) {
  //       // ✅ Repo wraps response as List — extract first element
  //       if (value.isNotEmpty && value.first is Map) {
  //         jsonMap = Map<String, dynamic>.from(value.first as Map);
  //         if (jsonMap.containsKey('status_code')) {
  //           jsonMap.remove('status_code');
  //         }
  //       } else {
  //         debugPrint('⚠️ Empty or invalid list response');
  //         jsonMap = {'success': false, 'data': null};
  //       }
  //     } else {
  //       debugPrint('⚠️ Unknown response type: ${value.runtimeType}');
  //       jsonMap = {'success': false, 'data': null};
  //     }
  //
  //     marksheetModel = SchoolAdminMarkSheetModel.fromJson(jsonMap);
  //     // debugPrint('✅ Parsed marksheet — student: ${marksheetModel.data?.studentInfo?.name}');
  //
  //   } catch (error, stack) {
  //     debugPrint('❌ ERROR in getCoScholasticGrades: $error');
  //     debugPrint('📍 Stack: $stack');
  //   } finally {
  //     setLoading(false);
  //     notifyListeners();
  //   }
  // }
}