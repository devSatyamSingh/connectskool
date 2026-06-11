import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/model/school_model/school_student_detail_model.dart';
import 'package:school_pro/repo/school_repo/school_student_detail_repository.dart';
import '../../utils/utils.dart';

class SchoolStudentDetailViewModel with ChangeNotifier {
  final _repository = SchoolStudentDetailRepository();

  bool _loading = false;
  bool get loading => _loading;

  SchoolStudentDetailModel? _schoolTeachersDetailModel;
  SchoolStudentDetailModel? get schoolTeachersDetailModel => _schoolTeachersDetailModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> schoolStudentDetailApi(int studentId, BuildContext context) async {
    setLoading(true);
    try {
      final response = await _repository.schoolStudentDetailApi(studentId);

      if (response != null) {
        _schoolTeachersDetailModel = SchoolStudentDetailModel.fromJson(
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