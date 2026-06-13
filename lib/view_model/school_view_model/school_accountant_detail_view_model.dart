import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_pro/model/school_model/school_accountant_detail_model.dart';
import 'package:school_pro/repo/school_repo/school_accountant_detail_repo.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';

class SchoolAccountantDetailViewModel with ChangeNotifier {
  final _repository = SchoolAccountantDetailRepository();

  bool _loading = false;
  bool get loading => _loading;

  SchoolAccountantDetailModel? _schoolAccountantDetailModel;
  SchoolAccountantDetailModel? get schoolAccountantDetailModel => _schoolAccountantDetailModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> schoolAccountantDetailApi(int accountantId, BuildContext context) async {

    if (!PermissionExtensions.canAccess(
        PermissionKeys.viewAccountants)) {

      Utils.show(
        "You don't have permission to view accountant details",
        context,
      );

      return;
    }
    setLoading(true);
    try {
      final response = await _repository.schoolAccountantDetailApi(accountantId);

      if (response != null) {
        _schoolAccountantDetailModel = SchoolAccountantDetailModel.fromJson(
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