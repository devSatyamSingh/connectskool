import 'package:flutter/material.dart';

import '../../../repo/school_repo/section/update_section_repo.dart';
import '../../../utils/permission_extensions.dart';
import '../../../utils/permission_keys.dart';
import '../../../utils/utils.dart';

class UpdateSectionViewModel extends ChangeNotifier {

  final SectionRepository _repository = SectionRepository();

  bool _loading = false;
  bool get loading => _loading;

  Future<void> updateSectionApi(
      BuildContext context,
      UpdateSectionRequest request,
      ) async {
    if (!PermissionExtensions.canAccess(
        PermissionKeys.manageSections)) {

      Utils.show(
        "You don't have permission to update section",
        context,
      );

      return;
    }

    _loading = true;
    notifyListeners();

    final success = await _repository.updateSection(request);

    _loading = false;
    notifyListeners();

    if (success) {
      Utils.show("Section Updated Successfully", context);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Section Updated Successfully")),
      // );
    } else {
      Utils.show(
        "Failed to Update Section",
        context,
      );
    }
  }
}