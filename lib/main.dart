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
import 'package:school_pro/view_model/school_view_model/Exam_management_view_model.dart';
import 'package:school_pro/view_model/school_view_model/academic_view_model.dart';
import 'package:school_pro/view_model/school_view_model/add_accountant_view_model.dart';
import 'package:school_pro/view_model/school_view_model/add_student_view_model.dart';
import 'package:school_pro/view_model/school_view_model/add_subject_view_model.dart';
import 'package:school_pro/view_model/school_view_model/add_teacher_view_model.dart';
import 'package:school_pro/view_model/school_view_model/all_accountant_list_view_model.dart';
import 'package:school_pro/view_model/school_view_model/all_attendance_view_model.dart';
import 'package:school_pro/view_model/school_view_model/all_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/all_home_work_view_model.dart';
import 'package:school_pro/view_model/school_view_model/all_notification_view_model.dart';
import 'package:school_pro/view_model/school_view_model/all_role_permissions_view_model.dart';
import 'package:school_pro/view_model/school_view_model/all_scetions_view_model.dart';
import 'package:school_pro/view_model/school_view_model/all_student_attendance_view_model.dart';
import 'package:school_pro/view_model/school_view_model/all_student_list_view_model.dart';
import 'package:school_pro/view_model/school_view_model/all_subjects_view_model.dart';
import 'package:school_pro/view_model/school_view_model/all_teachers_view_model.dart';
import 'package:school_pro/view_model/school_view_model/assign_role_view_model.dart';
import 'package:school_pro/view_model/school_view_model/cms_viewmodel.dart';
import 'package:school_pro/view_model/school_view_model/co_scholastic_grade_view_model.dart';
import 'package:school_pro/view_model/school_view_model/collect_fee_payment_view_model.dart';
import 'package:school_pro/view_model/school_view_model/create_admin_mark_sheet_view_model.dart';
import 'package:school_pro/view_model/school_view_model/create_admin_teacher_home_work_view_model.dart';
import 'package:school_pro/view_model/school_view_model/create_class_time_table_View_model.dart';
import 'package:school_pro/view_model/school_view_model/create_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/create_exam_maerks_view_model.dart';
import 'package:school_pro/view_model/school_view_model/create_exam_view_model.dart';
import 'package:school_pro/view_model/school_view_model/create_fees_head_view_model.dart';
import 'package:school_pro/view_model/school_view_model/create_fees_view_model.dart';
import 'package:school_pro/view_model/school_view_model/create_fine_view_model.dart';
import 'package:school_pro/view_model/school_view_model/create_notification_view_model.dart';
import 'package:school_pro/view_model/school_view_model/create_section_view_model.dart';
import 'package:school_pro/view_model/school_view_model/create_time_table_view_model.dart';
import 'package:school_pro/view_model/school_view_model/delete_accountant_view_model.dart';
import 'package:school_pro/view_model/school_view_model/delete_class_view_model.dart';
import 'package:school_pro/view_model/school_view_model/delete_classes_time_table_view_model.dart';
import 'package:school_pro/view_model/school_view_model/delete_exam_time_table_view_model.dart';
import 'package:school_pro/view_model/school_view_model/delete_exam_view_model.dart';
import 'package:school_pro/view_model/school_view_model/delete_fees_head_view_model.dart';
import 'package:school_pro/view_model/school_view_model/delete_notification_view_model.dart';
import 'package:school_pro/view_model/school_view_model/delete_school_admin_marksheet_view_model.dart';
import 'package:school_pro/view_model/school_view_model/delete_section_view_model.dart';
import 'package:school_pro/view_model/school_view_model/delete_student_view_model.dart';
import 'package:school_pro/view_model/school_view_model/delete_subject_view_model.dart';
import 'package:school_pro/view_model/school_view_model/delete_teacher_view_model.dart';
import 'package:school_pro/view_model/school_view_model/edit_accountant_view_model.dart';
import 'package:school_pro/view_model/school_view_model/edit_class_time_table_view_model.dart';
import 'package:school_pro/view_model/school_view_model/edit_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/edit_exam_view_model.dart';
import 'package:school_pro/view_model/school_view_model/edit_fees_head_view_model.dart';
import 'package:school_pro/view_model/school_view_model/edit_notification_view_model.dart';
import 'package:school_pro/view_model/school_view_model/edit_student_view_model.dart';
import 'package:school_pro/view_model/school_view_model/edit_subject_view_model.dart';
import 'package:school_pro/view_model/school_view_model/edit_teacher_view_model.dart';
import 'package:school_pro/view_model/school_view_model/exam_marks_view_model.dart';
import 'package:school_pro/view_model/school_view_model/exam_time_table_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees_head_management_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees_management_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fine_rule_view_model.dart';
import 'package:school_pro/view_model/school_view_model/generate_admit_card_view_model.dart';
import 'package:school_pro/view_model/school_view_model/get_classes_timetable_view_model.dart';
import 'package:school_pro/view_model/school_view_model/get_school_admin_marksheet_view_model.dart';
import 'package:school_pro/view_model/school_view_model/get_send_notification_view_model.dart';
import 'package:school_pro/view_model/school_view_model/get_student_transport_view_model.dart';
import 'package:school_pro/view_model/school_view_model/help_support_viewmodel.dart';
import 'package:school_pro/view_model/school_view_model/homework_details_viewmodel.dart';
import 'package:school_pro/view_model/school_view_model/mark_as_all_read_notication_view_model.dart';
import 'package:school_pro/view_model/school_view_model/remove_role_viewmodel.dart';
import 'package:school_pro/view_model/school_view_model/save_permission_view_model.dart';
import 'package:school_pro/view_model/school_view_model/school_accountant_detail_view_model.dart';
import 'package:school_pro/view_model/school_view_model/school_admin_profile_view_model.dart';
import 'package:school_pro/view_model/school_view_model/school_exam_time_table_view_model.dart';
import 'package:school_pro/view_model/school_view_model/school_student_detail_view_model.dart';
import 'package:school_pro/view_model/school_view_model/school_student_fee_view_model.dart';
import 'package:school_pro/view_model/school_view_model/school_teachers_view_model.dart';
import 'package:school_pro/view_model/school_view_model/select_role_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/create_route_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/create_stop_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/create_student_transport_fee_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/delete_route_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/delete_stop_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/discontinue_student_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/get_route_student_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/get_route_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/get_stop_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/update_route_view_model.dart';
import 'package:school_pro/view_model/school_view_model/transport_fee/update_stop_view_model.dart';
import 'package:school_pro/view_model/school_view_model/update_accountant_aatendance_view_model.dart';
import 'package:school_pro/view_model/school_view_model/update_school_admin_mark_sheet_view_model.dart';
import 'package:school_pro/view_model/school_view_model/update_section_view_model.dart';
import 'package:school_pro/view_model/school_view_model/update_student_attendance_view_model.dart';
import 'package:school_pro/view_model/school_view_model/update_teacher_attendance_view_model.dart';
import 'package:school_pro/view_model/school_view_model/user_permission_view_model.dart';
import 'package:school_pro/view_model/school_view_model/user_role_view_model.dart';
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
import 'package:school_pro/view_model/user_view_model.dart';
import 'firebase_options.dart';
import 'helper/network/internet_popup.dart';

// ✅ Global variables
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  // ✅ PEHLE Firebase initialize karo
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ AB Token refresh listener lagao
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    print("🔄 FCM Token Refreshed: $newToken");
    await reSubscribeTopics();
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("✅ App opened from notification: ${message.notification?.title}");
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print("✅ App launched from notification: ${message.notification?.title}");
    }
  });

  // Local notifications init
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await getFCMToken();

  // ✅ AB reSubscribe karo — Firebase already initialized hai
  await reSubscribeTopics();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("✅ Message aaya: ${message.notification?.title}");
    RemoteNotification? notification = message.notification;
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
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });

  runApp(const MyApp());
}

Future<void> getFCMToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // ✅ Yeh add karo
  print("🔔 Permission Status: ${settings.authorizationStatus}");

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    String? token = await messaging.getToken();
    print("✅ FCM Token: $token");
  } else {
    print("❌ Permission denied - notification nahi aayegi");
  }
}

Future<void> reSubscribeTopics() async {
  try {
    final userVM = UserViewModel();
    final role = await userVM.getRole();
    final schoolId = await userVM.getSchoolId();

    if (role != null && schoolId != null) {
      await FirebaseMessaging.instance.subscribeToTopic("school_$schoolId");
      await FirebaseMessaging.instance.subscribeToTopic(
        "school_${schoolId}_role_$role",
      );
      print("✅ Re-subscribed: school_$schoolId");
      print("✅ Re-subscribed: school_${schoolId}_role_$role");
    } else {
      print("⚠️ No saved session — skipping re-subscribe");
    }
  } catch (e) {
    print("❌ Re-subscribe error: $e");
  }
}

double screenHeight = 0.0;
double screenWidth = 0.0;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    InternetChecker.init(); // ADD
  }

  @override
  void dispose() {
    InternetChecker.dispose(); // ADD
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
          create: (_) => CreateAdminTeachersHomeworkViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => SchoolAdminProfileViewModel()),
        ChangeNotifierProvider(create: (_) => TeacherDetailViewModel()),
        ChangeNotifierProvider(create: (_) => SchoolStudentDetailViewModel()),
        ChangeNotifierProvider(
          create: (_) => SchoolAccountantDetailViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => AllNotificationViewModel()),
        ChangeNotifierProvider(create: (_) => CreateNotificationViewModel()),
        ChangeNotifierProvider(create: (_) => EditNotificationViewModel()),
        ChangeNotifierProvider(create: (_) => DeleteNotificationViewModel()),
        ChangeNotifierProvider(
          create: (_) => MarkAsAllReadNotificationViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => TimeTableViewModel()),
        ChangeNotifierProvider(create: (_) => CreateTimetableViewModel()),
        ChangeNotifierProvider(create: (_) => AllRolePermissionViewModel()),
        ChangeNotifierProvider(create: (_) => SelectRoleViewModel()),
        ChangeNotifierProvider(create: (_) => AssignRoleViewModel()),
        ChangeNotifierProvider(create: (_) => GetSendNotificationViewModel()),
        ChangeNotifierProvider(create: (_) => ExamMarksViewModel()),
        ChangeNotifierProvider(create: (_) => AllAttendanceViewModel()),
        ChangeNotifierProvider(create: (_) => DeleteClassViewModel()),
        ChangeNotifierProvider(
          create: (_) => AllStudentAdminAttendanceViewModel(),
        ),
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
          create: (_) => DeleteClassesTimeTableViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => StudentFeeViewModel()),
        ChangeNotifierProvider(create: (_) => CollectFeePaymentViewModel()),
        ChangeNotifierProvider(create: (_) => CreateAdminMarkSheetViewModel()),
        ChangeNotifierProvider(create: (_) => GetCoScholasticViewModel()),
        ChangeNotifierProvider(
          create: (_) => UpdateSchoolAdminMarkSheetViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => DeleteSchoolAdminMarkSheetViewModel(),
        ),
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
          create: (_) => CreateStudentTransportFeeViewModel(),
        ),
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
          create: (_) => CreateStudentAttendanceViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => AccountantAttendanceViewModel()),
        ChangeNotifierProvider(
          create: (_) => CreateAccountantAttendanceViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => AccountantProfileViewModel()),
        ChangeNotifierProvider(create: (_) => TeacherAttendanceViewModel()),
        ChangeNotifierProvider(create: (_) => StudentNotificationViewModel()),
        ChangeNotifierProvider(
          create: (_) => CreateTeacherAttendanceViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => TeacherProfileViewModel()),
        ChangeNotifierProvider(
          create: (_) => UpdateAccountantAttendanceViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => UpdateStudentAttendanceViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => UpdateTeacherAttendanceViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => RemoveRoleViewModel()),
        ChangeNotifierProvider(create: (_) => SupportTicketViewModel()),
        ChangeNotifierProvider(create: (_) => CmsViewModel()),
    ChangeNotifierProvider(create: (_) => SchoolTimetableViewModel()),
        ChangeNotifierProvider(create: (_) => HomeworkDetailsViewModel(),),
        ChangeNotifierProvider(
          create: (_) =>
              CoScholasticGradeViewModel(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
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
