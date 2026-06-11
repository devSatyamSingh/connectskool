import 'package:flutter/material.dart';

import '../../repo/school_repo/update_section_repo.dart';
import '../../utils/utils.dart';

class UpdateSectionViewModel extends ChangeNotifier {

  final SectionRepository _repository = SectionRepository();

  bool _loading = false;
  bool get loading => _loading;

  Future<void> updateSectionApi(
      BuildContext context,
      UpdateSectionRequest request,
      ) async {

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to Update Section")),
      );
    }
  }
}