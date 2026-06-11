import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/model/school_model/school_teachers_detail_model.dart';
import '../../repo/school_repo/school_teachers_detail_repo.dart';
import '../../utils/utils.dart';

class TeacherDetailViewModel with ChangeNotifier {
  final _repository = SchoolTeachersRepository();

  bool _loading = false;
  bool get loading => _loading;

  SchoolTeachersDetailModel? _schoolTeachersDetailModel;
  SchoolTeachersDetailModel? get schoolTeachersDetailModel => _schoolTeachersDetailModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // Future<void> schoolTeachersDetailApi(int teacherId, BuildContext context) async {
  //   setLoading(true);
  //   try {
  //     final response = await _repository.schoolTeachersDetailApi(teacherId);
  //     _schoolTeachersDetailModel = SchoolTeachersDetailModel.fromJson(response);
  //     notifyListeners();
  //   } catch (e) {
  //     debugPrint("❌ Error fetching teacher detail: $e");
  //     Utils.show("Failed to load teacher details", context);
  //   } finally {
  //     setLoading(false);
  //   }
  // }
  Future<void> schoolTeachersDetailApi(int teacherId, BuildContext context) async {
    setLoading(true);
    try {
      final response = await _repository.schoolTeachersDetailApi(teacherId);

      // Safe cast to Map<String, dynamic>
      if (response != null) {
        _schoolTeachersDetailModel = SchoolTeachersDetailModel.fromJson(
          Map<String, dynamic>.from(response),
        );
        notifyListeners();
      } else {
        Utils.show("No data received", context);
      }
    } catch (e) {
      debugPrint("❌ Error fetching teacher detail: $e");
      Utils.show("Failed to load teacher details", context);
    } finally {
      setLoading(false);
    }
  }

}