import 'package:flutter/material.dart';

import '../../../model/school_model/settings/cms_model.dart';
import '../../../repo/school_repo/settings/cms_repo.dart';

class CmsViewModel extends ChangeNotifier {
  final CmsRepository _repository = CmsRepository();

  bool _loading = false;

  bool get loading => _loading;

  CmsModel? _cmsModel;

  CmsModel? get cmsModel => _cmsModel;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> getCmsPages() async {
    try {
      setLoading(true);

      _cmsModel = await _repository.getAllCmsPages();
    } catch (e) {
      debugPrint("CMS Error => $e");
    } finally {
      setLoading(false);
    }
  }

  CmsPage? getPageByType(String pageType) {
    if (_cmsModel == null) {
      return null;
    }

    try {
      return _cmsModel!.data!.pages!.firstWhere(
        (page) => page.pageType == pageType,
      );
    } catch (e) {
      return null;
    }
  }
}
