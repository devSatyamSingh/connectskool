import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/school_view_model/marksheet/generate_marksheet_view_model.dart';
import '../../view_model/auth_view_model/school_admin_profile_view_model.dart';

class MarksheetPreviewWidget extends StatelessWidget {
  const MarksheetPreviewWidget({super.key});

  // Common Color Schemes from Design
  static const Color primaryBlue = Color(0xFF153D91);
  static const Color darkBlueText = Color(0xFF0F2C67);
  static const Color borderGrey = Color(0xFFD6D6D6);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GenerateMarksheetViewModel>();
    final data = vm.marksheetModel?.data;
    final profileVm = context.watch<SchoolAdminProfileViewModel>();

    final school = profileVm.schoolAdminProfileModel?.data;

    if (data == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "No Marksheet Found",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    final student = data.studentInfo;

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width:
              850, // Standard width for maintaining crisp desktop/tablet/web preview aspect ratio
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// SCHOOL HEADER WITH LOGO ICON BADGE
              _buildSchoolHeader(school),
              const SizedBox(height: 12),

              /// REPORT TITLE & CLASS SESSION
              _buildReportTitle(
                year: data.academicYear?.toString() ?? "-",
                className: student?.className?.toString() ?? "-",
                sectionName: student?.sectionName?.toString() ?? "-",
              ),
              const SizedBox(height: 16),

              /// STUDENT PROFILE SECTION
              _buildStudentProfile(student),
              const SizedBox(height: 16),

              /// ATTENDANCE BAR
              _buildAttendance(data),
              const SizedBox(height: 16),

              /// SCHOLASTIC AREA (8 POINT SCALE)
              _buildScholasticSection(data.scholastic),
              const SizedBox(height: 16),

              /// PERFORMANCE SUMMARY CARDS (CGPA, OVERALL %, RESULT)
              _buildSummaryCards(data),
              const SizedBox(height: 16),

              /// CO-SCHOLASTIC GRADES AND GRADING SCALE SIDE-BY-SIDE
              _buildCoScholasticAndScaleSection(data.coScholastic),
              const SizedBox(height: 40),

              /// SIGNATURE AUTHORITIES
              _buildSignatureSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSchoolHeader(dynamic school) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// School Logo
        Container(
          width: 54,
          height: 54,
          decoration: const BoxDecoration(
            color: primaryBlue,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.school_outlined,
            color: Colors.white,
            size: 28,
          ),
        ),

        const SizedBox(width: 16),

        /// School Details
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                school?.schoolName?.toString() ?? "School Name",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: primaryBlue,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                school?.schoolAdrees?.toString() ?? "School Address",
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),

              Text(
                "Email : ${school?.schoolEmail ?? "-"}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 9, color: Colors.black54),
              ),

              Text(
                "Phone : ${school?.schoolPhoneNumber ?? "-"}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.black54,
                  letterSpacing: .3,
                ),
              ),
            ],
          ),
        ),

        /// Right Spacer
        const SizedBox(width: 54),
      ],
    );
  }

  Widget _buildReportTitle({
    required String year,
    required String className,
    required String sectionName,
  }) {
    return Column(
      children: [
        const Divider(color: primaryBlue, thickness: 2, height: 1),

        const SizedBox(height: 8),

        Text(
          "REPORT CARD  SESSION $year",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: darkBlueText,
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: 6),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: primaryBlue.withOpacity(.06),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: primaryBlue.withOpacity(.20)),
          ),
          child: Text(
            "$className ($sectionName)",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: primaryBlue,
            ),
          ),
        ),

        const SizedBox(height: 8),

        const Divider(color: primaryBlue, thickness: 2, height: 1),
      ],
    );
  }

  Widget _buildStudentProfile(student) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: primaryBlue.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.04),
              border: const Border(bottom: BorderSide(color: borderGrey)),
            ),
            child: const Text(
              "STUDENT PROFILE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryBlue,
                fontSize: 13,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(2.5),
                2: FlexColumnWidth(1.0),
                3: FlexColumnWidth(1.5),
              },
              children: [
                _buildProfileTableRow(
                  "Name of Student",
                  student?.name,
                  "Roll No",
                  student?.rollNo,
                ),
                _buildProfileTableRow(
                  "Admission No.",
                  student?.admissionNo,
                  "Section",
                  student?.sectionName,
                ),
                _buildProfileTableRow(
                  "Date of Birth",
                  student?.dob,
                  "Class",
                  student?.className,
                ),
                _buildProfileTableRow(
                  "Mother's Name",
                  student?.motherName,
                  "Father's Name",
                  student?.fatherName,
                ),
                _buildProfileTableRow("Address", student?.address, "", ""),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildProfileTableRow(
    String label1,
    String? val1,
    String label2,
    String? val2,
  ) {
    const labelStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 11,
      color: Colors.black87,
    );
    const valueStyle = TextStyle(fontSize: 11, color: Colors.black);

    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(label1, style: labelStyle),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            val1 != null && val1.isNotEmpty ? ": $val1" : "",
            style: valueStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(label2, style: labelStyle),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            val2 != null && val2.isNotEmpty ? ": $val2" : "",
            style: valueStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendance(data) {
    final rollNo = data.studentInfo?.rollNo ?? "_";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade200),
        color: Colors.blue.withOpacity(0.02),
      ),
      child: Row(
        children: [
          const Text(
            "Attendance",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: primaryBlue,
            ),
          ),
          const SizedBox(width: 24),
          Text("Total Working Days : ", style: const TextStyle(fontSize: 11)),
          Text(
            "${data.attendance?.totalWorkingDays ?? 0}",
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const SizedBox(width: 24),
          Text("Total Attendance : ", style: const TextStyle(fontSize: 11)),
          Text(
            "${data.attendance?.presentDays ?? 0}",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          const Spacer(),
          Text(
            "Roll No : $rollNo",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScholasticSection(Map<String, dynamic>? scholasticData) {
    final hasRecords = scholasticData != null && scholasticData.isNotEmpty;

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: primaryBlue,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: const Text(
            "SCHOLASTIC AREA  (8 POINT SCALE)",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(border: Border.all(color: borderGrey)),
          child: hasRecords
              ? Table(
                  border: TableBorder.all(color: borderGrey),
                  children: [
                    const TableRow(
                      decoration: BoxDecoration(color: Color(0xFFEFEFEF)),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "Subject",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "Max",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "Obtained",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "Grade",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    ...scholasticData!.entries.map((entry) {
                      final item = entry.value;

                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(entry.key),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text("${item['max_marks'] ?? '-'}"),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text("${item['obtained_marks'] ?? '-'}"),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text("${item['grade'] ?? '-'}"),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                )
              : const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      "No scholastic records for this session.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(data) {
    final double percentage =
        double.tryParse(data.overallPercentage.toString()) ?? 0.0;
    final isPass = percentage >= 33.0; // Standard evaluation pass mark

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            "CGPA",
            data.cgpa ?? "—",
            const Color(0xFF153D91),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            "OVERALL %",
            "$percentage%",
            const Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            "RESULT",
            isPass ? "PASS ✓" : "FAIL ✗",
            isPass ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, Color themeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.04),
        border: Border.all(color: themeColor.withOpacity(0.4), width: 1.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: themeColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoScholasticAndScaleSection(
    Map<String, dynamic>? coScholasticData,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Table 1 (Co-Scholastic Metrics left block split layout)
        Expanded(flex: 3, child: _buildCoScholasticTable(coScholasticData)),
        const SizedBox(width: 16),
        // Grading Scale Reference Card (Right block layout matching image scale metrics)
        Expanded(flex: 2, child: _buildGradingScaleTable()),
      ],
    );
  }

  Widget _buildCoScholasticTable(Map<String, dynamic>? data) {
    final term1 = Map<String, dynamic>.from(data?['term1'] ?? {});

    final term2 = Map<String, dynamic>.from(data?['term2'] ?? {});

    final Set<String> subjectIds = {};

    subjectIds.addAll(term1.keys);

    subjectIds.addAll(term2.keys);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: const BoxDecoration(
            color: primaryBlue,
          ),
          child: const Text(
            "CO-SCHOLASTIC AREA",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: .5,
            ),
          ),
        ),

        Table(
          border: TableBorder.all(
            color: borderGrey,
            width: 1,
          ),
          columnWidths: const {
            0: FlexColumnWidth(2.5),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
          },
          children: [

            /// Header
            const TableRow(
              decoration: BoxDecoration(
                color: Color(0xFFF3F4F6),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Activity",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      "Term-1",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      "Term-2",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// Dynamic Rows
            if (subjectIds.isEmpty)
              const TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      "No Co-Scholastic Records",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(),
                  SizedBox(),
                ],
              )
            else
              ...subjectIds.map((subjectId) {

                final t1 = term1[subjectId];

                final t2 = term2[subjectId];

                final activity =
                    t1?['subject_name'] ??
                        t2?['subject_name'] ??
                        '-';

                final term1Grade =
                    t1?['grade'] ??
                        '-';

                final term2Grade =
                    t2?['grade'] ??
                        '-';

                return _buildCoScholasticRow(
                  activity.toString(),
                  term1Grade.toString(),
                  term2Grade.toString(),
                );
              }),
          ],
        ),
      ],
    );
  }
  TableRow _buildCoScholasticRow(String activity, String t1, String t2) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(6),
          child: Text(activity, style: const TextStyle(fontSize: 10)),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Center(
            child: Text(
              t1,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Center(
            child: Text(
              t2,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradingScaleTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: primaryBlue,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          child: const Text(
            "SCALE INDICATORS",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
        Table(
          border: TableBorder.all(color: borderGrey),
          columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2.5)},
          children: [
            _buildScaleRow("A1", "Outstanding", const Color(0xFF2E7D32)),
            _buildScaleRow("A2", "Excellent", Colors.blue),
            _buildScaleRow("B1", "Very Good", Colors.purple.shade400),
            _buildScaleRow("B2", "Good", Colors.cyan.shade700),
            _buildScaleRow("C1", "Above Average", Colors.orange),
            _buildScaleRow("C2", "Average", Colors.orange.shade300),
            _buildScaleRow("D", "Below Average", Colors.redAccent),
            _buildScaleRow("E", "Needs Effort", Colors.red.shade900),
          ],
        ),
      ],
    );
  }

  TableRow _buildScaleRow(
    String grade,
    String description,
    Color indicatorColor,
  ) {
    return TableRow(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          color: indicatorColor.withOpacity(0.12),
          child: Center(
            child: Text(
              grade,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: indicatorColor,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            description,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildSignatureSection() {
    return Column(
      children: [
        const Divider(
          color: Colors.grey,
          thickness: 0.8,
        ), // Styled dotted baseline structure setup
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _SignatureLabel(title: "DIRECTOR"),
            _SignatureLabel(title: "CLASS TEACHER"),
            _SignatureLabel(title: "PRINCIPAL"),
          ],
        ),
      ],
    );
  }
}

class _SignatureLabel extends StatelessWidget {
  final String title;
  const _SignatureLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 1,
          color: Colors.black26,
        ), // Solid accent signature line
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
