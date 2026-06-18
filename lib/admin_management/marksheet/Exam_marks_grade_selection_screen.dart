import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_pro/admin_management/exam/school_exam_marks_screen.dart';
import 'package:school_pro/main.dart';
import '../../../res/app_color.dart';
import '../../../res/const_text.dart';
import 'co_scholastic_grade_screen.dart';

class ExamMarksGradeSelectionScreen extends StatelessWidget {
  const ExamMarksGradeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> modules = [
      {
        "title": "Scholastic Marks",
        "subtitle": "Select exam and details to manage student performance",
        "type": "Scholastic",
        "icon": Icons.analytics_rounded,
        "gradientColors": [Colors.indigo.shade500, Colors.blue.shade700],
      },
      {
        "title": "Co-Scholastic Grade",
        "subtitle": "Manage skill & activity gradings",
        "type": "co-Scholastic",
        "icon": Icons.workspace_premium_rounded,
        "gradientColors": [Colors.deepPurple.shade500, Colors.purple.shade700],
      },
    ];

    return Scaffold(
      backgroundColor: AppColor.screenBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 48, 20, 24),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.blueShadow.withOpacity(0.15),
                  blurRadius: 10,

                ),
              ],
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColor.glassWhite,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppText.customText(
                    "Exam Marks Assign",
                    size: 20,
                    weight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: AppText.customText(
              "Select Category",
              size: 17,
              weight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: modules.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio:
                0.9, // Refined vertical room for subtitle elements
              ),
              itemBuilder: (context, index) {
                final module = modules[index];
                final title = module["title"]!;
                final subtitle = module["subtitle"]!;
                final type = module["type"]!;
                final IconData iconData = module["icon"];
                final List<Color> gradientColors = module["gradientColors"];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade100, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200.withOpacity(0.6),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        if (type == "Scholastic") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SchoolExamMarksScreen(),
                            ),
                          );
                        } else if (type == "co-Scholastic") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CoScholasticScreen(),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 18,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: gradientColors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: gradientColors[0].withOpacity(0.3),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Icon(
                                iconData,
                                size: 28,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            AppText.customText(
                              title,
                              size: 17,
                              weight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            const SizedBox(height: 6),

                            /// Subtitle Segment Text Block
                            Text(
                              subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
