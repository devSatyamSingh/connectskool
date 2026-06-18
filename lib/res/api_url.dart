class ApiUrl {
  static const String baseUrl = "https://university.fctesting.shop/api";

  // AUTH---------------------------------------------
  static const String login = "$baseUrl/auth/login";
  static const String logout = "$baseUrl/auth/logout";
  static const String schoolAdminProfile = "$baseUrl/schooladmin/getSchoolAdminProfile";
  static const String academicYear = "$baseUrl/schooladmin/getAcademicYears";


  // CLASS---------------------------------------------
  static const String allClassesList = "$baseUrl/schooladmin/getAllClasses";
  static const String createClasses = "$baseUrl/schooladmin/createClass";
  static const String editClasses = "$baseUrl/schooladmin/updateClass";
  static const String deleteClass = "$baseUrl/schooladmin/deleteClass";


  // SECTION---------------------------------------------
  static const String allSections = "$baseUrl/schooladmin/getAllSections?class_id=";
  static const String createSection = "$baseUrl/schooladmin/createSection";
  static const String updateSection = "$baseUrl/schooladmin/updateSection";
  static const String deleteSection = "$baseUrl/schooladmin/deleteSection";


  // SUBJECT---------------------------------------------
  static const String allSubjects = "$baseUrl/schooladmin/getAllSubjects";
  static const String addSubjects = "$baseUrl/schooladmin/createSubject";
  static const String editSubjects = "$baseUrl/schooladmin/updateSubject";
  static const String deleteSubjects = "$baseUrl/schooladmin/deleteSubject";


  // HOMEWORK---------------------------------------------
  static const String allHomework = "$baseUrl/schooladmin/getHomeworks";
  static const String getHomeworkById = "$baseUrl/schooladmin/getHomeworkById";
  static const String createAdminTeacherHomework = "$baseUrl/schooladmin/createTeacherHomework";


  // STUDENT---------------------------------------------
  static const String allStudentList = "$baseUrl/schooladmin/getTotalStudentsListBySchoolId";
  static const String schoolStudentDetail ="$baseUrl/schooladmin/getStudentDetailsById";
  static const String registerStudent = "$baseUrl/schooladmin/registerStudent";
  static const String editStudent = "$baseUrl/schooladmin/updateStudent";
  static const String deleteStudent = "$baseUrl/schooladmin/deleteStudentById";


  // TEACHER---------------------------------------------
  static const String allTeachersList = "$baseUrl/schooladmin/getTotalTeachersListBySchoolId";
  static const String schoolTeachersDetail = "$baseUrl/schooladmin/getTeacherById";
  static const String registerTeacher = "$baseUrl/schooladmin/registerTeacher";
  static const String editTeacher = "$baseUrl/schooladmin/updateTeacher";
  static const String deleteTeacher = "$baseUrl/schooladmin/deleteTeacherById";

  // ACCOUNTANT---------------------------------------------
  static const String allAccountantList = "$baseUrl/schooladmin/getTotalAccountantsListBySchoolId";
  static const String schoolAccountantDetail = "$baseUrl/schooladmin/getAccountantById";
  static const String registerAccountant = "$baseUrl/schooladmin/registerAccountant";
  static const String editAccountant = "$baseUrl/schooladmin/updateAccountant";
  static const String deleteAccountant = "$baseUrl/schooladmin/deleteAccountantById";


  // ATTENDANCE---------------------------------------------
  //STUDENT
  static const String allStudentAttendance = "$baseUrl/schooladmin/getAllStudentAttendanceByClassSection";
  static const String studentAttendance = "$baseUrl/student/getStudentAttendanceForStudentSide";
  static const String createStudentAttendance = "$baseUrl/schooladmin/createAllStudentAttendance";
  static const String updateStudentAttendance = "$baseUrl/schooladmin/updateAllStudentAttendance";
  // TEACHER
  static const String updateTeacherAttendance = "$baseUrl/schooladmin/updateTeacherAttendance";
  static const String teacherAttendance = "$baseUrl/schooladmin/getTeacherAttendance";
  static const String createTeacherAttendance = "$baseUrl/schooladmin/createTeacherAttendance";
  //ACCOUNTANT
  static const String createAccountantAttendance = "$baseUrl/schooladmin/createAccountantAttendance";
  static const String updateAccountant = "$baseUrl/schooladmin/updateAccountantAttendance";
  static const String accountantAttendance = "$baseUrl/schooladmin/getAccountantAttendance";



  // TIMETABLE---------------------------------------------
  static const String getExamTimeTable = "$baseUrl/schooladmin/getExamTimetable";
  static const String createExamTimetable = "$baseUrl/schooladmin/createExamTimetable";
  static const String deleteExamTimeTable = "$baseUrl/schooladmin/deleteExamTimetable";
  static const String createClassTimeTable = "$baseUrl/schooladmin/createTimetable";
  static const String getClassTimeTable = "$baseUrl/schooladmin/getTimetable";
  static const String updateClassTimeTable = "$baseUrl/schooladmin/updateTimetable";
  static const String deleteClassTimeTable = "$baseUrl/schooladmin/deleteTimetable";
  static const String getTimetable = "$baseUrl/schooladmin/getTimetable";


  // FEES---------------------------------------------
  static const String fineRule = "$baseUrl/schooladmin/getAllFineRules";
  static const String createFineRule = "$baseUrl/schooladmin/createFineRule";
  static const String updateFineRule = "$baseUrl/schooladmin/updateFineRule";
  static const String deleteFineRule = "$baseUrl/schooladmin/deleteFineRule";
  static const String allFees = "$baseUrl/schooladmin/getAllFees";
  static const String deleteFee = "$baseUrl/schooladmin/deleteFee";
  static const String createFees = "$baseUrl/schooladmin/createFee";
  static const String feesHead = "$baseUrl/schooladmin/getAllFeeHeads";
  static const String createHeadFees = "$baseUrl/schooladmin/createFeeHead";
  static const String updateFeesHead = "$baseUrl/schooladmin/updateFeeHead";
  static const String deleteFeesHead = "$baseUrl/schooladmin/deleteFeeHead";
  static const String collectFee = "$baseUrl/schooladmin/collectFeePayment";


  // TRANSPORT--------------------------------------------
  static const String createRoute = "$baseUrl/schooladmin/createRoute";
  static const String getRoutes = "$baseUrl/schooladmin/getRoutes";
  static const String updateRoutes = "$baseUrl/schooladmin/updateRoute";
  static const String deleteRoutes = "$baseUrl/schooladmin/deleteRoute";
  static const String createStop = "$baseUrl/schooladmin/createStop";
  static const String getStops = "$baseUrl/schooladmin/getStops";
  static const String updateStops = "$baseUrl/schooladmin/updateStop";
  static const String deleteStops = "$baseUrl/schooladmin/deleteStop";
  static const String assignStudentTransportFee = "$baseUrl/schooladmin/assignStudentTransport";
  static const String getAllTransportStudents = "$baseUrl/schooladmin/getAllTransportStudents";
  static const String getStudentTransport = "$baseUrl/schooladmin/getStudentTransport";
  static const String getRouteStudents = "$baseUrl/schooladmin/getRouteStudents";
  static const String discontinueStudentTransport = "$baseUrl/schooladmin/discontinueStudentTransport";

  // EXAM---------------------------------------------
  static const String examManagement = "$baseUrl/schooladmin/getExams";
  static const String deleteExam = "$baseUrl/schooladmin/deleteExam";
  static const String createExam = "$baseUrl/schooladmin/createExam";
  static const String updateExam = "$baseUrl/schooladmin/updateExam";


  // EXAM MARKS---------------------------------------------
  static const String createExamMarks = "$baseUrl/schooladmin/createExamMarks";
  static const String getExamMarks = "$baseUrl/schooladmin/getExamMarks";


  // MARKSHEET & ADMIT CARD---------------------------------------------
  static const String generateMarksheet = "$baseUrl/schooladmin/generateMarksheet";
  static const String generateAdmitCard = "$baseUrl/schooladmin/generateAdmitCard";


  // CO-Scholastic---------------------------------------------
  static const String createCoScholasticGrade = "$baseUrl/schooladmin/createCoScholasticGrade";
  static const String getCoScholasticGrades = "$baseUrl/schooladmin/getCoScholasticGrades";
  static const String updateCoScholasticGrade = "$baseUrl/schooladmin/updateCoScholasticGrade";
  static const String deleteCoScholasticGrade = "$baseUrl/schooladmin/deleteCoScholasticGrade";



  // NOTIFICATION---------------------------------------------
  static const String allNotification = "$baseUrl/schooladmin/getMyNotifications";
  static const String getSendNotification = "$baseUrl/schooladmin/getSentNotifications";
  static const String createNotification = "$baseUrl/schooladmin/createNotification";
  static const String updateNotification = "$baseUrl/schooladmin/updateNotificationType";
  static const String deleteNotification = "$baseUrl/schooladmin/deleteNotification";
  static const String markAsAllReadNotification = "$baseUrl/schooladmin/markAllAsRead";



  // PERMISSION---------------------------------------------
  static const String allPermissions = "$baseUrl/schooladmin/getAllPermissions";
  static String selectRole(String role) => "$baseUrl/schooladmin/getRolePermissions/$role";
  static const String assignRole = "$baseUrl/schooladmin/assignRolePermissions";
  static const String getUserPermission = "$baseUrl/schooladmin/getUserPermissions";
  static const String getUserRole = "$baseUrl/schooladmin/getUsersByRole";
  static const String saveUserPermission = "$baseUrl/schooladmin/saveUserPermissions";
  static const String removeRolePermission = "$baseUrl/schooladmin/removeRolePermission";


  // CMS SETTING---------------------------------------------
  static const String createSupportTicket = "$baseUrl/schoolAdmin/createSupportTicket";
  static const String getAllCmsPages = "$baseUrl/cms/getAllCmsPages";


  //student section
  static const String studentProfile = "$baseUrl/student/getStudentDetailsByIdStudentSide";
  static const String studentHomeWork = "$baseUrl/student/getStudentHomeworkSubjectWise";
  static const submitHomework = "$baseUrl/student/submitHomework";
  static const String studentNotification = "$baseUrl/student/getMyNotifications";
  static const String studentFees = "$baseUrl/student/getStudentFeesStudentSide";

  //accountant section
  static const String accountantProfile = "$baseUrl/accountant/getAccountantByIdAccountantSide";

  //teacher section
  static const String teacherProfile = "$baseUrl/teacher/getTeacherByIdTeacherSide";
}
