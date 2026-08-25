import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/utils/routes/routes.dart';
import 'package:school_pro/utils/routes/routes_name.dart';
import 'package:school_pro/view_model/accountant/accountant_profile_view_model.dart';
import 'package:school_pro/view_model/accountant_attendance_view_model/accountant_attendance_view_model.dart';
import 'package:school_pro/view_model/accountant_attendance_view_model/create_accountant_attendance_view_model.dart';
import 'package:school_pro/view_model/auth_view_model/login_view_model.dart';
import 'package:school_pro/view_model/auth_view_model/academic_view_model.dart';
import 'package:school_pro/view_model/school_view_model/accountant/add_accountant_view_model.dart';
import 'package:school_pro/view_model/school_view_model/exam_mark/create_exam_maerks_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/discontinue_student_fee_viewmodel.dart';
import 'package:school_pro/view_model/school_view_model/student/add_student_view_model.dart';
import 'package:school_pro/view_model/school_view_model/subject/add_subject_view_model.dart';
import 'package:school_pro/view_model/school_view_model/teacher/add_teacher_view_model.dart';
import 'package:school_pro/view_model/school_view_model/accountant/all_accountant_list_view_model.dart';
import 'package:school_pro/view_model/school_view_model/attendance/all_attendance_view_model.dart';
import 'package:school_pro/view_model/school_view_model/classes/all_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/homework/all_home_work_view_model.dart';
import 'package:school_pro/view_model/school_view_model/notification/all_notification_view_model.dart';
import 'package:school_pro/view_model/school_view_model/permission/all_role_permissions_view_model.dart';
import 'package:school_pro/view_model/school_view_model/section/all_scetions_view_model.dart';
import 'package:school_pro/view_model/school_view_model/attendance/all_student_attendance_view_model.dart';
import 'package:school_pro/view_model/school_view_model/student/all_student_list_view_model.dart';
import 'package:school_pro/view_model/school_view_model/subject/all_subjects_view_model.dart';
import 'package:school_pro/view_model/school_view_model/teacher/all_teachers_view_model.dart';
import 'package:school_pro/view_model/school_view_model/permission/assign_role_view_model.dart';
import 'package:school_pro/view_model/school_view_model/settings/cms_viewmodel.dart';
import 'package:school_pro/view_model/school_view_model/co_scholastic/co_scholastic_grade_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/collect_fee_payment_view_model.dart';
import 'package:school_pro/view_model/school_view_model/marksheet/create_admin_mark_sheet_view_model.dart';
import 'package:school_pro/view_model/school_view_model/homework/create_admin_teacher_home_work_view_model.dart';
import 'package:school_pro/view_model/school_view_model/timetable/create_class_time_table_View_model.dart';
import 'package:school_pro/view_model/school_view_model/classes/create_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/exam/create_exam_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/create_fees_head_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/create_fees_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/create_fine_view_model.dart';
import 'package:school_pro/view_model/school_view_model/notification/create_notification_view_model.dart';
import 'package:school_pro/view_model/school_view_model/section/create_section_view_model.dart';
import 'package:school_pro/view_model/school_view_model/timetable/create_time_table_view_model.dart';
import 'package:school_pro/view_model/school_view_model/accountant/delete_accountant_view_model.dart';
import 'package:school_pro/view_model/school_view_model/classes/delete_class_view_model.dart';
import 'package:school_pro/view_model/school_view_model/timetable/delete_classes_time_table_view_model.dart';
import 'package:school_pro/view_model/school_view_model/timetable/delete_exam_time_table_view_model.dart';
import 'package:school_pro/view_model/school_view_model/exam/delete_exam_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/delete_fees_head_view_model.dart';
import 'package:school_pro/view_model/school_view_model/notification/delete_notification_view_model.dart';
import 'package:school_pro/view_model/school_view_model/marksheet/delete_school_admin_marksheet_view_model.dart';
import 'package:school_pro/view_model/school_view_model/section/delete_section_view_model.dart';
import 'package:school_pro/view_model/school_view_model/student/delete_student_view_model.dart';
import 'package:school_pro/view_model/school_view_model/subject/delete_subject_view_model.dart';
import 'package:school_pro/view_model/school_view_model/teacher/delete_teacher_view_model.dart';
import 'package:school_pro/view_model/school_view_model/accountant/edit_accountant_view_model.dart';
import 'package:school_pro/view_model/school_view_model/timetable/edit_class_time_table_view_model.dart';
import 'package:school_pro/view_model/school_view_model/classes/edit_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/exam/edit_exam_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/edit_fees_head_view_model.dart';
import 'package:school_pro/view_model/school_view_model/notification/edit_notification_view_model.dart';
import 'package:school_pro/view_model/school_view_model/student/edit_student_view_model.dart';
import 'package:school_pro/view_model/school_view_model/subject/edit_subject_view_model.dart';
import 'package:school_pro/view_model/school_view_model/teacher/edit_teacher_view_model.dart';
import 'package:school_pro/view_model/school_view_model/exam_mark/exam_marks_view_model.dart';
import 'package:school_pro/view_model/school_view_model/timetable/time_table_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/fees_head_management_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/fees_management_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/fine_rule_view_model.dart';
import 'package:school_pro/view_model/school_view_model/marksheet/generate_admit_card_view_model.dart';
import 'package:school_pro/view_model/school_view_model/marksheet/generate_marksheet_view_model.dart';
import 'package:school_pro/view_model/school_view_model/timetable/get_classes_timetable_view_model.dart';
import 'package:school_pro/view_model/school_view_model/marksheet/get_school_admin_marksheet_view_model.dart';
import 'package:school_pro/view_model/school_view_model/notification/get_send_notification_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/get_student_transport_view_model.dart';
import 'package:school_pro/view_model/school_view_model/settings/help_support_viewmodel.dart';
import 'package:school_pro/view_model/school_view_model/homework/homework_details_viewmodel.dart';
import 'package:school_pro/view_model/school_view_model/notification/mark_as_all_read_notication_view_model.dart';
import 'package:school_pro/view_model/school_view_model/permission/remove_role_viewmodel.dart';
import 'package:school_pro/view_model/school_view_model/permission/save_permission_view_model.dart';
import 'package:school_pro/view_model/school_view_model/accountant/school_accountant_detail_view_model.dart';
import 'package:school_pro/view_model/auth_view_model/school_admin_profile_view_model.dart';
import 'package:school_pro/view_model/school_view_model/timetable/school_exam_time_table_view_model.dart';
import 'package:school_pro/view_model/school_view_model/student/school_student_detail_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/school_student_fee_view_model.dart';
import 'package:school_pro/view_model/school_view_model/teacher/school_teachers_view_model.dart';
import 'package:school_pro/view_model/school_view_model/permission/select_role_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/create_route_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/create_stop_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/create_student_transport_fee_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/delete_route_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/delete_stop_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/discontinue_student_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/get_all_transport_student_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/get_route_student_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/get_route_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/get_stop_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/update_route_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/update_stop_view_model.dart';
import 'package:school_pro/view_model/school_view_model/attendance/update_accountant_aatendance_view_model.dart';
import 'package:school_pro/view_model/school_view_model/marksheet/update_school_admin_mark_sheet_view_model.dart';
import 'package:school_pro/view_model/school_view_model/section/update_section_view_model.dart';
import 'package:school_pro/view_model/school_view_model/attendance/update_student_attendance_view_model.dart';
import 'package:school_pro/view_model/school_view_model/attendance/update_teacher_attendance_view_model.dart';
import 'package:school_pro/view_model/school_view_model/permission/user_permission_view_model.dart';
import 'package:school_pro/view_model/school_view_model/permission/user_role_view_model.dart';
import 'package:school_pro/view_model/student_view_model/create_student_attendance_view_model.dart';
import 'package:school_pro/view_model/student_view_model/student_attendance_view_model.dart';
import 'package:school_pro/view_model/student_view_model/student_fee_view_model.dart';
import 'package:school_pro/view_model/student_view_model/student_home_work_view_model.dart';
import 'package:school_pro/view_model/student_view_model/student_notification_view_model.dart';
import 'package:school_pro/view_model/student_view_model/student_profile_view_model.dart';
import 'package:school_pro/view_model/student_view_model/submit_home_work_view_model.dart';
import 'package:school_pro/view_model/student_view_model/timetable_viewmodel.dart';
import 'package:school_pro/view_model/teacher_view_model/create_teacher_attendance_view_model.dart';
import 'package:school_pro/view_model/teacher_view_model/teacher_attendance_view_model.dart';
import 'package:school_pro/view_model/teacher_view_model/teacher_profile_view_model.dart';
import 'package:school_pro/view_model/auth_view_model/user_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'localization/app_locals.dart';
import 'localization/language_provider.dart';
import 'localization/language_storage.dart';
import 'res/internet_popup.dart';
import 'package:school_pro/view_model/school_view_model/exam/exam_management_view_model.dart';

// ─── Globals ──────────────────────────────────────────────────────────────────

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
  playSound: true,
);


@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

// ─── Main ─────────────────────────────────────────────────────────────────────

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await LanguageStorage.init();                     // ✅ NEW

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    debugPrint("🔄 FCM Token Refreshed: $newToken");
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint("📲 App opened from notification: ${message.notification?.title}");
  });

  final RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    debugPrint("🚀 App launched from notification: ${initialMessage.notification?.title}");
  }

  const AndroidInitializationSettings androidSettings =
  AndroidInitializationSettings('@drawable/ic_notification');
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(android: androidSettings),
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await _initFCMPermission();
  await _reSubscribeTopics();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    debugPrint("📩 Foreground message: ${message.notification?.title}");
    debugPrint("📦 Message data: ${message.data}");

    final senderId = message.data['sender_id'];
    if (senderId != null && senderId.toString().isNotEmpty) {
      final myUserId = await UserViewModel().getUserIdFromToken();
      debugPrint(" sender_id: $senderId | my user_id: $myUserId");
      if (myUserId != null && senderId.toString() == myUserId) {
        debugPrint(" Apni hi notification hai — block kar raha hai");
        return;
      }
    }

    final notification = message.notification;
    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            icon: '@drawable/ic_notification',
          ),
        ),
      );
    }
  });

  runApp(
    EasyLocalization(                                // ✅ NEW — wraps MyApp
      supportedLocales: AppLocales.supported,
      path: 'assets/translations',
      fallbackLocale: AppLocales.defaultLocale,
      startLocale: Locale(LanguageStorage.getLanguageCode()),
      saveLocale: false,
      child: const MyApp(),
    ),
  );
}


Future<void> _initFCMPermission() async {
  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    final token = await messaging.getToken();
    debugPrint("✅ FCM Permission granted | Token: $token");
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    debugPrint("⚠️ FCM Permission provisional (iOS quiet notifications)");
  } else {
    debugPrint("❌ FCM Permission denied — notifications nahi aayengi");
  }
}

// ─── Re-Subscribe on App Start ────────────────────────────────────────────────
// App kill/restart ke baad saved session ke EXACT topics restore karta hai.
// IMPORTANT: Yeh login_view_model.dart ke _buildTopics() se bilkul sync mein hai.
// Dono jagah topics ka logic same hona chahiye — warna mismatch hoga.

Future<void> _reSubscribeTopics() async {
  try {
    final userVM = UserViewModel();

    // Subscribed session se exact topics padhte hain
    // (wahi jo login ke waqt subscribe kiye the)
    final session = await userVM.getSubscribedSession();

    final schoolId  = session['schoolId'];
    final role      = session['role'];
    final userId    = session['userId'];
    final classId   = session['classId'];
    final sectionId = session['sectionId'];

    if (schoolId == null || schoolId.isEmpty ||
        role     == null || role.isEmpty) {
      debugPrint("ℹ️ No saved session — skipping re-subscribe");
      return;
    }

    final messaging = FirebaseMessaging.instance;
    final topics = <String>[
      "school_$schoolId",                     // school-wide
      "school_${schoolId}_role_$role",         // role-based
    ];

    if (userId != null && userId.isNotEmpty) {
      topics.add("user_$userId");
    }

    if (role == "student") {
      if (classId != null && classId.isNotEmpty) {
        topics.add("school_${schoolId}_class_$classId");
      }
      if (classId != null && classId.isNotEmpty &&
          sectionId != null && sectionId.isNotEmpty) {
        topics.add("school_${schoolId}_class_${classId}_section_$sectionId");
      }
    }

    await Future.wait(
      topics.map((t) => messaging.subscribeToTopic(t)),
      eagerError: false,
    );

    debugPrint("✅ Re-subscribed topics: $topics");
  } catch (e) {
    debugPrint("❌ Re-subscribe error: $e");
  }
}

// ─── Screen Dimensions ────────────────────────────────────────────────────────

double screenHeight = 0.0;
double screenWidth = 0.0;

// ─── App Root ─────────────────────────────────────────────────────────────────

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    InternetChecker.init();
  }

  @override
  void dispose() {
    InternetChecker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => AllStudentListVieModel()),
        ChangeNotifierProvider(create: (_) => AllTeachersListVieModel()),
        ChangeNotifierProvider(create: (_) => AllAccountantListVieModel()),
        ChangeNotifierProvider(create: (_) => AllClassesViewModel()),
        ChangeNotifierProvider(create: (_) => CreateClassesViewModel()),
        ChangeNotifierProvider(create: (_) => EditClassesViewModel()),
        ChangeNotifierProvider(create: (_) => AllSectionsViewModel()),
        ChangeNotifierProvider(create: (_) => AllSubjectsVieModel()),
        ChangeNotifierProvider(create: (_) => AddSubjectViewModel()),
        ChangeNotifierProvider(create: (_) => EditSubjectsViewModel()),
        ChangeNotifierProvider(create: (_) => DeleteSubjectViewModel()),
        ChangeNotifierProvider(create: (_) => EditStudentViewModel()),
        ChangeNotifierProvider(create: (_) => DeleteStudentViewModel()),
        ChangeNotifierProvider(create: (_) => EditTeacherViewModel()),
        ChangeNotifierProvider(create: (_) => DeleteTeacherViewModel()),
        ChangeNotifierProvider(create: (_) => EditAccountantViewModel()),
        ChangeNotifierProvider(create: (_) => DeleteAccountantViewModel()),
        ChangeNotifierProvider(create: (_) => FineRuleViewModel()),
        ChangeNotifierProvider(create: (_) => CreateFineViewModel()),
        ChangeNotifierProvider(create: (_) => FeesManagementViewModel()),
        ChangeNotifierProvider(create: (_) => CreateFeesViewModel()),
        ChangeNotifierProvider(create: (_) => FeesHeadManagementViewModel()),
        ChangeNotifierProvider(create: (_) => CreateFeesHeadViewModel()),
        ChangeNotifierProvider(create: (_) => EditFeesHeadViewModel()),
        ChangeNotifierProvider(create: (_) => DeleteFeesHeadViewModel()),
        ChangeNotifierProvider(create: (_) => ExamManagementViewModel()),
        ChangeNotifierProvider(create: (_) => CreateExamViewModel()),
        ChangeNotifierProvider(create: (_) => EditExamViewModel()),
        ChangeNotifierProvider(create: (_) => AddStudentViewModel()),
        ChangeNotifierProvider(create: (_) => AddAccountantViewModel()),
        ChangeNotifierProvider(create: (_) => AddTeachersViewModel()),
        ChangeNotifierProvider(create: (_) => AllHomeWorkViewModel()),
        ChangeNotifierProvider(
            create: (_) => CreateAdminTeachersHomeworkViewModel()),
        ChangeNotifierProvider(create: (_) => SchoolAdminProfileViewModel()),
        ChangeNotifierProvider(create: (_) => TeacherDetailViewModel()),
        ChangeNotifierProvider(create: (_) => SchoolStudentDetailViewModel()),
        ChangeNotifierProvider(
            create: (_) => SchoolAccountantDetailViewModel()),
        ChangeNotifierProvider(create: (_) => AllNotificationViewModel()),
        ChangeNotifierProvider(create: (_) => CreateNotificationViewModel()),
        // ChangeNotifierProvider(create: (_) => EditNotificationViewModel()),
        ChangeNotifierProvider(create: (_) => DeleteNotificationViewModel()),
        ChangeNotifierProvider(
            create: (_) => MarkAsAllReadNotificationViewModel()),
        ChangeNotifierProvider(create: (_) => CreateTimetableViewModel()),
        ChangeNotifierProvider(create: (_) => AllRolePermissionViewModel()),
        ChangeNotifierProvider(create: (_) => SelectRoleViewModel()),
        ChangeNotifierProvider(create: (_) => AssignRoleViewModel()),
        ChangeNotifierProvider(create: (_) => GetSendNotificationViewModel()),
        ChangeNotifierProvider(create: (_) => ExamMarksViewModel()),
        ChangeNotifierProvider(create: (_) => AllAttendanceViewModel()),
        ChangeNotifierProvider(create: (_) => DeleteClassViewModel()),
        ChangeNotifierProvider(
            create: (_) => AllStudentAdminAttendanceViewModel()),
        ChangeNotifierProvider(create: (_) => CreateSectionViewModel()),
        ChangeNotifierProvider(create: (_) => UpdateSectionViewModel()),
        ChangeNotifierProvider(create: (_) => DeleteSectionViewModel()),
        ChangeNotifierProvider(create: (_) => GetUserPermissionViewModel()),
        ChangeNotifierProvider(create: (_) => GetUsersByRoleViewModel()),
        ChangeNotifierProvider(create: (_) => CreateClassTimetableViewModel()),
        ChangeNotifierProvider(create: (_) => GetClassesTimeTableViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => StudentFeesViewModel()),
        ChangeNotifierProvider(create: (_) => AcademicViewModel()),
        ChangeNotifierProvider(create: (_) => CreateExamMarksViewModel()),
        ChangeNotifierProvider(create: (_) => SaveUserPermissionViewModel()),
        ChangeNotifierProvider(create: (_) => EditClassesTimeTableViewModel()),
        ChangeNotifierProvider(
            create: (_) => DeleteClassesTimeTableViewModel()),
        ChangeNotifierProvider(create: (_) => StudentFeeViewModel()),
        ChangeNotifierProvider(create: (_) => CollectFeePaymentViewModel()),
        ChangeNotifierProvider(create: (_) => CreateAdminMarkSheetViewModel()),
        ChangeNotifierProvider(create: (_) => GetCoScholasticViewModel()),
        ChangeNotifierProvider(
            create: (_) => UpdateSchoolAdminMarkSheetViewModel()),
        ChangeNotifierProvider(
            create: (_) => DeleteSchoolAdminMarkSheetViewModel()),
        ChangeNotifierProvider(create: (_) => GenerateAdmitCardViewModel()),
        ChangeNotifierProvider(create: (_) => CreateRouteViewModel()),
        ChangeNotifierProvider(create: (_) => GetRouteViewModel()),
        ChangeNotifierProvider(create: (_) => UpdateRouteViewModel()),
        ChangeNotifierProvider(create: (_) => DeleteRouteViewModel()),
        ChangeNotifierProvider(create: (_) => CreateStopViewModel()),
        ChangeNotifierProvider(create: (_) => GetStopViewModel()),
        ChangeNotifierProvider(create: (_) => UpdateStopViewModel()),
        ChangeNotifierProvider(create: (_) => DeleteStopViewModel()),
        ChangeNotifierProvider(
            create: (_) => CreateStudentTransportFeeViewModel()),
        ChangeNotifierProvider(create: (_) => GetStudentTransportViewModel()),
        ChangeNotifierProvider(create: (_) => GetRouteStudentsViewModel()),
        ChangeNotifierProvider(create: (_) => DiscontinueStudentViewModel()),
        ChangeNotifierProvider(create: (_) => DeleteExamViewModel()),
        ChangeNotifierProvider(create: (_) => SchoolExamTimeTableViewModel()),
        ChangeNotifierProvider(create: (_) => DeleteExamTimeTableViewModel()),
        ChangeNotifierProvider(create: (_) => StudentProfileViewModel()),
        ChangeNotifierProvider(create: (_) => StudentHomeworkViewModel()),
        ChangeNotifierProvider(create: (_) => SubmitHomeworkViewModel()),
        ChangeNotifierProvider(create: (_) => StudentAttendanceViewModel()),
        ChangeNotifierProvider(
            create: (_) => CreateStudentAttendanceViewModel()),
        ChangeNotifierProvider(create: (_) => AccountantAttendanceViewModel()),
        ChangeNotifierProvider(
            create: (_) => CreateAccountantAttendanceViewModel()),
        ChangeNotifierProvider(create: (_) => AccountantProfileViewModel()),
        ChangeNotifierProvider(create: (_) => TeacherAttendanceViewModel()),
        ChangeNotifierProvider(create: (_) => StudentNotificationViewModel()),
        ChangeNotifierProvider(create: (_) => CreateTeacherAttendanceViewModel()),
        ChangeNotifierProvider(create: (_) => TeacherProfileViewModel()),
        ChangeNotifierProvider(create: (_) => UpdateAccountantAttendanceViewModel()),
        ChangeNotifierProvider(create: (_) => UpdateStudentAttendanceViewModel()),
        ChangeNotifierProvider(create: (_) => UpdateTeacherAttendanceViewModel()),
        ChangeNotifierProvider(create: (_) => RemoveRoleViewModel()),
        ChangeNotifierProvider(create: (_) => SupportTicketViewModel()),
        ChangeNotifierProvider(create: (_) => CmsViewModel()),
        ChangeNotifierProvider(create: (_) => SchoolTimetableViewModel()),
        ChangeNotifierProvider(create: (_) => HomeworkDetailsViewModel()),
        ChangeNotifierProvider(create: (_) => GenerateMarksheetViewModel()),
        ChangeNotifierProvider(create: (_) => CoScholasticGradeViewModel()),
        ChangeNotifierProvider(create: (_) => GetAllTransportStudentsViewModel()),
        ChangeNotifierProvider(create: (_) => DiscontinueStudentFeeViewModel()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,   // ✅ NEW
        supportedLocales: context.supportedLocales,               // ✅ NEW
        locale: context.locale,                                   // ✅ NEW
        initialRoute: RoutesName.splash,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        onGenerateRoute: (routeSettings) {
          if (routeSettings.name != null) {
            return MaterialPageRoute(
              builder: Routers.generateRoute(routeSettings.name!),
              settings: routeSettings,
            );
          }
          return null;
        },
      ),
    );
  }
}