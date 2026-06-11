import 'package:flutter/material.dart';

// ✅ Existing model — already has PermissionItem defined
import '../../model/school_model/user_permission_model.dart';
import '../../repo/school_repo/user_permission_repo.dart';

class GetUserPermissionViewModel extends ChangeNotifier {

  // ─── State ─────────────────────────────────────────────────────────────────

  bool _loading = false;
  bool get loading => _loading;

  GetUserPermissionModel? _model;
  GetUserPermissionModel? get model => _model;

  /// Flat map: permissionId -> "default" | "allowed" | "denied"
  Map<int, String> permissionStateMap = {};

  // ─── Repository ────────────────────────────────────────────────────────────

  final _repo = GetUserPermissionRepository();

  // ─── Fetch API ─────────────────────────────────────────────────────────────

  Future<void> getUserPermissionApi({
    required BuildContext context,
    required int userId,
    required String role,
  }) async {
    _setLoading(true);

    try {
      final response = await _repo.getUserPermissionApi(
        userId: userId,
      );

      _model = GetUserPermissionModel.fromJson(response);
      _buildStateMap();

    } catch (e) {
      debugPrint('getUserPermissionApi error: $e');
    }

    _setLoading(false);
  }

  // ─── Build State Map ───────────────────────────────────────────────────────

  void _buildStateMap() {
    permissionStateMap.clear();

    final sections = _model?.data?.permissions;
    if (sections == null) return;

    sections.forEach((section, items) {
      for (var item in items) {
        if (item.permissionId != null) {
          permissionStateMap[item.permissionId!] = item.state ?? 'default';
        }
      }
    });

    notifyListeners();
  }

  // ─── Update Single Permission ──────────────────────────────────────────────

  void updatePermissionState(int permissionId, String newState) {
    permissionStateMap[permissionId] = newState;
    notifyListeners();
  }

  // ─── Select All in Section ─────────────────────────────────────────────────

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

  // ─── Reset All ─────────────────────────────────────────────────────────────

  void resetAll() {
    permissionStateMap.updateAll((key, value) => 'default');
    notifyListeners();
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────
  bool canAccess(String permissionKey) {
    for (final section in sections) {
      for (final item in getItemsForSection(section)) {
        if (item.key == permissionKey) {
          return getState(item.permissionId ?? 0) != 'denied';
        }
      }
    }
    return true; // key nahi mili → default allow
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

  // ─── Private ───────────────────────────────────────────────────────────────

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}