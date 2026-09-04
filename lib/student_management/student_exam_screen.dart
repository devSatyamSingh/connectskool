import 'package:flutter/material.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:easy_localization/easy_localization.dart';  // ← ADD THIS

class StudentExamScreen extends StatefulWidget {
  const StudentExamScreen({super.key});

  @override
  State<StudentExamScreen> createState() => _StudentExamScreenState();
}

class _StudentExamScreenState extends State<StudentExamScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late TabController _tabController;

  final List<Map<String, dynamic>> upcomingExams = [
    {
      "subject": "Mathematics",
      "date": "15 Feb 2024",
      "time": "10:00 AM - 1:00 PM",
      "duration": "3 Hours",
      "totalMarks": 100,
      "type": "Final Exam",
      "syllabus": "Chapters 1-10",
      "color": const Color(0xFF6C5CE7),
      "icon": Icons.calculate_rounded,
      "daysLeft": 11,
    },
    {
      "subject": "Physics",
      "date": "18 Feb 2024",
      "time": "10:00 AM - 1:00 PM",
      "duration": "3 Hours",
      "totalMarks": 100,
      "type": "Final Exam",
      "syllabus": "All Units",
      "color": const Color(0xFF00B894),
      "icon": Icons.science_rounded,
      "daysLeft": 14,
    },
    {
      "subject": "Chemistry",
      "date": "20 Feb 2024",
      "time": "10:00 AM - 1:00 PM",
      "duration": "3 Hours",
      "totalMarks": 100,
      "type": "Final Exam",
      "syllabus": "Chapters 1-8",
      "color": const Color(0xFFFF6B6B),
      "icon": Icons.biotech_rounded,
      "daysLeft": 16,
    },
    {
      "subject": "English",
      "date": "22 Feb 2024",
      "time": "10:00 AM - 12:30 PM",
      "duration": "2.5 Hours",
      "totalMarks": 80,
      "type": "Final Exam",
      "syllabus": "Full Syllabus",
      "color": const Color(0xFFFFA502),
      "icon": Icons.menu_book_rounded,
      "daysLeft": 18,
    },
  ];

  final List<Map<String, dynamic>> pastResults = [
    {
      "subject": "Mathematics",
      "examType": "Mid-Term",
      "date": "15 Jan 2024",
      "marksObtained": 92,
      "totalMarks": 100,
      "grade": "A+",
      "color": const Color(0xFF6C5CE7),
      "icon": Icons.calculate_rounded,
    },
    {
      "subject": "Physics",
      "examType": "Mid-Term",
      "date": "17 Jan 2024",
      "marksObtained": 88,
      "totalMarks": 100,
      "grade": "A",
      "color": const Color(0xFF00B894),
      "icon": Icons.science_rounded,
    },
    {
      "subject": "Chemistry",
      "examType": "Mid-Term",
      "date": "19 Jan 2024",
      "marksObtained": 85,
      "totalMarks": 100,
      "grade": "A",
      "color": const Color(0xFFFF6B6B),
      "icon": Icons.biotech_rounded,
    },
    {
      "subject": "English",
      "examType": "Mid-Term",
      "date": "21 Jan 2024",
      "marksObtained": 90,
      "totalMarks": 100,
      "grade": "A+",
      "color": const Color(0xFFFFA502),
      "icon": Icons.menu_book_rounded,
    },
    {
      "subject": "Computer Science",
      "examType": "Mid-Term",
      "date": "23 Jan 2024",
      "marksObtained": 95,
      "totalMarks": 100,
      "grade": "A+",
      "color": const Color(0xFF0984E3),
      "icon": Icons.computer_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  double get averagePercentage {
    if (pastResults.isEmpty) return 0;
    double total = pastResults.fold<double>(
      0,
          (sum, result) =>
      sum + (result['marksObtained'] / result['totalMarks'] * 100),
    );
    return total / pastResults.length;
  }

  int get totalExams => pastResults.length;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.customText(
                              'student_exam.title'.tr(),
                              size: 26,
                              weight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            const SizedBox(height: 4),
                            AppText.customText(
                              'student_exam.subtitle'.tr(),
                              size: 13,
                              color: Colors.grey[600]!,
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColor.lightBlueColor,
                                AppColor.lightBlueColor.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.lightBlueColor.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.notifications_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Performance Summary Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.lightBlueColor,
                        AppColor.lightBlueColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.lightBlueColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText.customText(
                            'student_exam.overall_performance'.tr(),
                            size: 16,
                            color: Colors.white.withOpacity(0.9),
                            weight: FontWeight.w600,
                          ),
                          Icon(
                            Icons.trending_up_rounded,
                            color: Colors.white.withOpacity(0.9),
                            size: 28,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText.customText(
                                  "${averagePercentage.toStringAsFixed(1)}%",
                                  size: 36,
                                  weight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 4),
                                AppText.customText(
                                  'student_exam.average_score'.tr(),
                                  size: 13,
                                  color: Colors.white.withOpacity(0.85),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                AppText.customText(
                                  "$totalExams",
                                  size: 24,
                                  weight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                AppText.customText(
                                  'student_exam.exams_count'.tr(),
                                  size: 11,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Quick Stats Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildQuickStatCard(
                        title: 'student_exam.upcoming'.tr(),
                        value: "${upcomingExams.length}",
                        icon: Icons.calendar_month_rounded,
                        color: const Color(0xFFFFA502),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildQuickStatCard(
                        title: 'student_exam.completed'.tr(),
                        value: "$totalExams",
                        icon: Icons.check_circle_rounded,
                        color: const Color(0xFF00B894),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildQuickStatCard(
                        title: 'student_exam.next_exam'.tr(),
                        value: "${upcomingExams.first['daysLeft']}d",
                        icon: Icons.access_time_rounded,
                        color: const Color(0xFFFF6B6B),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tab Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: AppColor.lightBlueColor,
                    unselectedLabelColor: Colors.grey[600],
                    indicatorColor: AppColor.lightBlueColor,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    tabs: [
                      Tab(text: 'student_exam.tab_upcoming'.tr()),
                      Tab(text: 'student_exam.tab_results'.tr()),
                      Tab(text: 'student_exam.tab_schedule'.tr()),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: screenHeight * 0.7,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildUpcomingTab(),
                    _buildResultsTab(),
                    _buildScheduleTab(),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.07),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          AppText.customText(
            value,
            size: 18,
            weight: FontWeight.bold,
            color: color,
          ),
          const SizedBox(height: 4),
          AppText.customText(
            title,
            size: 11,
            color: Colors.grey[700]!,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.customText(
              'student_exam.upcoming_exams'.tr(),
              size: 18,
              weight: FontWeight.bold,
              color: Colors.black87,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: AppText.customText(
                'student_exam.exams_label'.tr(namedArgs: {'count': upcomingExams.length.toString()}),
                size: 12,
                color: Colors.grey[700]!,
                weight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(
          upcomingExams.length,
              (index) => _buildAnimatedCard(
            index,
            _buildUpcomingExamCard(upcomingExams[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingExamCard(Map<String, dynamic> exam) {
    Color color = exam['color'];
    int daysLeft = exam['daysLeft'];
    Color urgencyColor = daysLeft <= 7
        ? Colors.red
        : daysLeft <= 14
        ? Colors.orange
        : Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            _showExamDetailsDialog(exam);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, color.withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        exam['icon'],
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.customText(
                            exam['subject'],
                            size: 17,
                            weight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: AppText.customText(
                              exam['type'],
                              size: 11,
                              color: color,
                              weight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [urgencyColor, urgencyColor.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: urgencyColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          AppText.customText(
                            'student_exam.days'.tr(namedArgs: {'count': daysLeft.toString()}),
                            size: 12,
                            weight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      _buildExamInfoRow(
                        Icons.calendar_today_rounded,
                        'student_exam.date'.tr(),
                        exam['date'],
                      ),
                      const SizedBox(height: 8),
                      _buildExamInfoRow(
                        Icons.schedule_rounded,
                        'student_exam.time'.tr(),
                        exam['time'],
                      ),
                      const SizedBox(height: 8),
                      _buildExamInfoRow(
                        Icons.timer_rounded,
                        'student_exam.duration'.tr(),
                        exam['duration'],
                      ),
                      const SizedBox(height: 8),
                      _buildExamInfoRow(
                        Icons.assignment_rounded,
                        'student_exam.total_marks'.tr(),
                        "${exam['totalMarks']}",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExamInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        AppText.customText(
          "$label: ",
          size: 13,
          color: Colors.grey[600]!,
          weight: FontWeight.w600,
        ),
        Expanded(
          child: AppText.customText(
            value,
            size: 13,
            color: Colors.black87,
            weight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildResultsTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.customText(
              'student_exam.past_results'.tr(),
              size: 18,
              weight: FontWeight.bold,
              color: Colors.black87,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: AppText.customText(
                'student_exam.avg_label'.tr(
                    namedArgs: {'avg': averagePercentage.toStringAsFixed(1)}
                ),
                size: 12,
                color: Colors.grey[700]!,
                weight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(
          pastResults.length,
              (index) => _buildAnimatedCard(
            index,
            _buildResultCard(pastResults[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(Map<String, dynamic> result) {
    Color color = result['color'];
    double percentage =
        (result['marksObtained'] / result['totalMarks']) * 100;
    Color gradeColor = percentage >= 90
        ? Colors.green
        : percentage >= 75
        ? Colors.blue
        : percentage >= 60
        ? Colors.orange
        : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    result['icon'],
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.customText(
                        result['subject'],
                        size: 17,
                        weight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 4),
                      AppText.customText(
                        "${result['examType']} • ${result['date']}",
                        size: 12,
                        color: Colors.grey[600]!,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [gradeColor, gradeColor.withOpacity(0.8)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: gradeColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: AppText.customText(
                    result['grade'],
                    size: 16,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.customText(
                        'student_exam.score'.tr(),
                        size: 12,
                        color: Colors.grey[600]!,
                      ),
                      const SizedBox(height: 4),
                      AppText.customText(
                        "${result['marksObtained']}/${result['totalMarks']}",
                        size: 20,
                        weight: FontWeight.bold,
                        color: color,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.customText(
                        'student_exam.percentage'.tr(),
                        size: 12,
                        color: Colors.grey[600]!,
                      ),
                      const SizedBox(height: 4),
                      AppText.customText(
                        "${percentage.toStringAsFixed(1)}%",
                        size: 20,
                        weight: FontWeight.bold,
                        color: gradeColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 8,
                backgroundColor: color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        AppText.customText(
          'student_exam.complete_schedule'.tr(),
          size: 18,
          weight: FontWeight.bold,
          color: Colors.black87,
        ),
        const SizedBox(height: 12),
        ...List.generate(
          upcomingExams.length,
              (index) => _buildAnimatedCard(
            index,
            _buildScheduleCard(upcomingExams[index], index),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> exam, int index) {
    Color color = exam['color'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText.customText(
                    exam['date'].split(' ')[0],
                    size: 20,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  AppText.customText(
                    exam['date'].split(' ')[1],
                    size: 11,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.customText(
                    exam['subject'],
                    size: 16,
                    weight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      AppText.customText(
                        exam['time'],
                        size: 12,
                        color: Colors.grey[600]!,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.book_rounded,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      AppText.customText(
                        exam['syllabus'],
                        size: 12,
                        color: Colors.grey[600]!,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(int index, Widget child) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        final delay = index * 0.08;
        final animationValue = Curves.easeOut.transform(
          (_animationController.value - delay).clamp(0.0, 1.0) / (1.0 - delay),
        );

        return Transform.translate(
          offset: Offset(0, 20 * (1 - animationValue)),
          child: Opacity(
            opacity: animationValue,
            child: child,
          ),
        );
      },
    );
  }

  void _showExamDetailsDialog(Map<String, dynamic> exam) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [exam['color'], exam['color'].withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                exam['icon'],
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppText.customText(
                exam['subject'],
                size: 18,
                weight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('student_exam.exam_type'.tr(), exam['type']),
            _buildDetailRow('student_exam.date'.tr(), exam['date']),
            _buildDetailRow('student_exam.time'.tr(), exam['time']),
            _buildDetailRow('student_exam.duration'.tr(), exam['duration']),
            _buildDetailRow('student_exam.total_marks'.tr(), "${exam['totalMarks']}"),
            _buildDetailRow('student_exam.syllabus'.tr(), exam['syllabus']),
            _buildDetailRow('student_exam.days_left'.tr(), "${exam['daysLeft']} days"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText.customText(
              'student_exam.close'.tr(),
              size: 14,
              color: AppColor.lightBlueColor,
              weight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: AppText.customText(
              label,
              size: 13,
              color: Colors.grey[600]!,
              weight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: AppText.customText(
              value,
              size: 13,
              color: Colors.black87,
              weight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}