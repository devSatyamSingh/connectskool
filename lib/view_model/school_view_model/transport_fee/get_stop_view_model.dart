import 'package:flutter/foundation.dart';
import '../../../model/school_model/transport_model/stop_model.dart';
import '../../../repo/school_repo/transport_repo/get_stop_repo.dart';

class GetStopViewModel with ChangeNotifier {

  final _repo = GetStopRepository();

  bool loading = false;

  StopModel stopModel = StopModel();

  setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Future<void> getStopApi(String routeId) async {

    setLoading(true);

    _repo.getStopApi(routeId).then((value) {

      stopModel = value;

      setLoading(false);

    }).onError((error, stackTrace) {

      setLoading(false);

      if (kDebugMode) {
        print(error);
      }

    });
  }
}