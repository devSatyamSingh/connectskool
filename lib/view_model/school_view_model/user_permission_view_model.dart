import 'package:flutter/material.dart';

// Existing model — already has PermissionItem defined
import '../../model/school_model/user_permission_model.dart';
import '../../repo/school_repo/user_permission_repo.dart';
import '../../utils/permission_manager.dart';

class GetUserPermissionViewModel extends ChangeNotifier {

  // ─── State ─────────────────────────────────────────────────────────────────

  bool _loading = false;
  bool get loading => _loading;

  GetUserPermissionModel? _model;
  GetUserPermissionModel? get model => _model;

  Map<int, String> permissionStateMap = {};


  final _repo = GetUserPermissionRepository();

  Future<void> getUserPermissionApi({
    required BuildContext context,
    required int userId,
    required String role,
    bool isCurrentUser = true,
  }) async {
    _setLoading(true);

    try {

      final response = await _repo.getUserPermissionApi(
        userId: userId,
      );

      debugPrint(
        "USER PERMISSION RESPONSE => $response",
      );

      final int statusCode =
          response["status_code"] ?? 200;

      // ==========================
      // API FAILED
      // ==========================
      if (statusCode != 200) {

        debugPrint(
          "Permission API failed => $statusCode",
        );

        // IMPORTANT:
        // login wali permissions ko mat hatao

        _setLoading(false);
        notifyListeners();
        return;
      }

      // ==========================
      // API SUCCESS
      // ==========================
      _model = GetUserPermissionModel.fromJson(
        response,
      );

      _buildStateMap(
        syncPermissionManager: isCurrentUser,
      );

    } catch (e) {

      debugPrint(
        "Permission API Error => $e",
      );
    }

    _setLoading(false);
  }


  void _buildStateMap({bool syncPermissionManager = false}) {

    permissionStateMap.clear();

    final sections = _model?.data?.permissions;

    if (sections == null) return;

    // Sirf un permissions ke keys jo "denied" state me NAHI hai — yeh hi
    // PermissionManager ko diya jayega (Pattern: canAccess() => list me hai
    // to allowed, nahi hai to denied).
    final List<String> effectivePermissions = [];

    sections.forEach((section, items) {

      for (var item in items) {
        print(
            "KEY=${item.key}"
        );

        print(
            "STATE=${item.state}"
        );

        print(
            "ROLE_DEFAULT=${item.roleDefault}"
        );

        debugPrint(
          "KEY=${item.key} STATE=${item.state}",
        );

        if (item.permissionId != null) {

          permissionStateMap[item.permissionId!] =
              item.state ?? 'default';
        }

        // "denied" => is permission ko PermissionManager list me shamil
        // NAHI karna (canAccess() => false ho jayega).
        // "allowed" / "default" (jab role_default true ho ya admin ne
        // explicitly allow kiya ho) => shamil karo.
        if (item.key == null) continue;

        switch (item.state) {

          case "allowed":
            effectivePermissions.add(item.key!);
            break;

          case "denied":
            break;

          case "default":
          default:

            if (item.roleDefault == true) {
              effectivePermissions.add(item.key!);
            }

            break;
        }
      }
    });

    if (syncPermissionManager) {
      PermissionManager.setPermissions(effectivePermissions);
      print(
        "✅ EFFECTIVE PERMISSIONS => $effectivePermissions",
      );

      debugPrint(
        "🔄 PermissionManager SYNCED (current user) => "
            "${effectivePermissions.length} permissions",
      );
    }

    debugPrint(
      "PERMISSION STATE MAP BUILT => ${permissionStateMap.length} entries",
    );

    notifyListeners();
  }


  void updatePermissionState(int permissionId, String newState) {
    permissionStateMap[permissionId] = newState;
    notifyListeners();
  }


  void selectAllInSection(String section, String state) {
    final items = _model?.data?.permissions?[section];
    if (items == null) return;

    for (var item in items) {
      if (item.permissionId != null) {
        permissionStateMap[item.permissionId!] = state;
      }
    }

    notifyListeners();
  }


  void resetAll() {
    permissionStateMap.updateAll((key, value) => 'default');
    notifyListeners();
  }

  bool canAccess(String permissionKey) {

    for (final section in sections) {

      for (final item in getItemsForSection(section)) {

        if (item.key == permissionKey) {

          final state =
          getState(item.permissionId ?? 0);

          if (state == "allowed") {
            return true;
          }

          if (state == "denied") {
            return false;
          }

          return item.roleDefault == true;
        }
      }
    }

    return false;
  }
  List<String> get sections =>
      (_model?.data?.permissions?.keys.toList() ?? [])..sort();

  List<PermissionItem> getItemsForSection(String section) =>
      _model?.data?.permissions?[section] ?? [];

  String getState(int permissionId) =>
      permissionStateMap[permissionId] ?? 'default';

  List<int> get allowedIds => permissionStateMap.entries
      .where((e) => e.value == 'allowed')
      .map((e) => e.key)
      .toList();

  List<int> get deniedIds => permissionStateMap.entries
      .where((e) => e.value == 'denied')
      .map((e) => e.key)
      .toList();


  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}