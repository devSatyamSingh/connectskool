import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// KEY NAMES — single source of truth, koi bhi magic string nahi
class _Keys {
  static const userId       = 'user_id';
  static const accessToken  = 'access_token';
  static const studentId    = 'student_id';
  static const schoolId     = 'school_id';
  static const role         = 'role';
  static const classId      = 'class_id';
  static const sectionId    = 'section_id';
  static const permissions  = 'permissions';

  /// Ye key KABHI clear() se nahi hati.
  /// Android uninstall pe ye automatically delete ho jaati hai.
  /// Next install pe missing hogi → fresh install detect → force login.
  static const appInstalled = 'app_installed_flag';

  /// Onboarding sirf pehli baar dikhta hai.
  /// Uninstall pe ye bhi delete hogi → reinstall pe onboarding dobara dikhega.
  static const onboardingDone = 'onboarding_done';

  /// Jo FCM topics subscribe kiye unka snapshot.
  /// Logout ya next login pe isi se exact unsubscribe hoga — cross-school bug fix.
  static const subscribedSchoolId  = 'subscribed_school_id';
  static const subscribedRole      = 'subscribed_role';
  static const subscribedUserId    = 'subscribed_user_id';
  static const subscribedClassId   = 'subscribed_class_id';
  static const subscribedSectionId = 'subscribed_section_id';
}

class UserViewModel with ChangeNotifier {

  // ─── Install / Onboarding Detection ──────────────────────────────────────

  /// false = fresh install (ya reinstall) → force login + onboarding
  Future<bool> isAppPreviouslyInstalled() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_Keys.appInstalled) ?? false;
  }

  Future<void> markAppInstalled() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_Keys.appInstalled, true);
  }

  Future<bool> isOnboardingDone() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_Keys.onboardingDone) ?? false;
  }

  Future<void> markOnboardingDone() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_Keys.onboardingDone, true);
  }

  // ─── User ID (String — consistent with saveUser dynamic) ─────────────────

  Future<bool> saveUser(dynamic userId) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_Keys.userId, userId.toString());
    notifyListeners();
    return true;
  }

  /// Returns String? — splash & login use int.tryParse() to convert if needed
  Future<String?> getUser() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_Keys.userId);
  }

  // ─── Token ────────────────────────────────────────────────────────────────

  Future<bool> saveToken(String token) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_Keys.accessToken, token);
    notifyListeners();
    return true;
  }

  Future<String?> getToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_Keys.accessToken);
  }

  // ─── Student ID ───────────────────────────────────────────────────────────

  Future<bool> saveStudentId(int studentId) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_Keys.studentId, studentId);
    notifyListeners();
    return true;
  }

  Future<int?> getStudentId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(_Keys.studentId);
  }

  // ─── School ID ────────────────────────────────────────────────────────────

  Future<void> saveSchoolId(dynamic schoolId) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_Keys.schoolId, schoolId.toString());
  }

  Future<String?> getSchoolId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_Keys.schoolId);
  }

  // ─── Role ─────────────────────────────────────────────────────────────────

  Future<bool> saveRole(String role) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_Keys.role, role);
    notifyListeners();
    return true;
  }

  Future<String?> getRole() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_Keys.role);
  }

  // ─── Class ID ─────────────────────────────────────────────────────────────

  Future<void> saveClassId(dynamic classId) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_Keys.classId, classId?.toString() ?? "");
  }

  Future<String?> getClassId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_Keys.classId);
  }

  // ─── Section ID ───────────────────────────────────────────────────────────

  Future<void> saveSectionId(dynamic sectionId) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_Keys.sectionId, sectionId?.toString() ?? "");
  }

  Future<String?> getSectionId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_Keys.sectionId);
  }

  // ─── Permissions ──────────────────────────────────────────────────────────

  Future<void> savePermissions(List<dynamic> permissions) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList(
      _Keys.permissions,
      permissions.map((e) => e.toString()).toList(),
    );
  }

  Future<List<String>> getPermissions() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getStringList(_Keys.permissions) ?? [];
  }

  // ─── Subscribed FCM Session ───────────────────────────────────────────────
  // Login ke baad exactly jo topics subscribe kiye unka snapshot save karo.
  // Logout ya next login pe isi snapshot se unsubscribe hoga — guaranteed match.

  Future<void> saveSubscribedSession({
    required dynamic schoolId,
    required String role,
    dynamic userId,
    dynamic classId,
    dynamic sectionId,
  }) async {
    final sp = await SharedPreferences.getInstance();
    await Future.wait([
      sp.setString(_Keys.subscribedSchoolId,  schoolId.toString()),
      sp.setString(_Keys.subscribedRole,       role),
      sp.setString(_Keys.subscribedUserId,     userId?.toString() ?? ""),
      sp.setString(_Keys.subscribedClassId,    classId?.toString() ?? ""),
      sp.setString(_Keys.subscribedSectionId,  sectionId?.toString() ?? ""),
    ]);
  }

  Future<Map<String, String?>> getSubscribedSession() async {
    final sp = await SharedPreferences.getInstance();
    return {
      'schoolId':  sp.getString(_Keys.subscribedSchoolId),
      'role':      sp.getString(_Keys.subscribedRole),
      'userId':    sp.getString(_Keys.subscribedUserId),
      'classId':   sp.getString(_Keys.subscribedClassId),
      'sectionId': sp.getString(_Keys.subscribedSectionId),
    };
  }

  Future<void> clearSubscribedSession() async {
    final sp = await SharedPreferences.getInstance();
    await Future.wait([
      sp.remove(_Keys.subscribedSchoolId),
      sp.remove(_Keys.subscribedRole),
      sp.remove(_Keys.subscribedUserId),
      sp.remove(_Keys.subscribedClassId),
      sp.remove(_Keys.subscribedSectionId),
    ]);
  }

  // ─── Clear All (Logout) ───────────────────────────────────────────────────
  // app_installed_flag aur onboarding_done intentionally preserved hain.
  // Sirf uninstall hi inhe delete karega.

  Future<void> clearUser() async {
    final sp = await SharedPreferences.getInstance();

    // Preserve install & onboarding flags
    final installFlag     = sp.getBool(_Keys.appInstalled);
    final onboardingFlag  = sp.getBool(_Keys.onboardingDone);

    await sp.clear();

    if (installFlag    != null) await sp.setBool(_Keys.appInstalled,   installFlag);
    if (onboardingFlag != null) await sp.setBool(_Keys.onboardingDone, onboardingFlag);

    notifyListeners();
  }
}