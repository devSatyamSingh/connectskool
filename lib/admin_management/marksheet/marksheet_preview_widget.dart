import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';  // ← ADD THIS

import '../../view_model/school_view_model/marksheet/generate_marksheet_view_model.dart';
import '../../view_model/auth_view_model/school_admin_profile_view_model.dart';

class MarksheetPreviewWidget extends StatelessWidget {
  const MarksheetPreviewWidget({super.key});

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
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'marksheets_preview.no_marksheet_found'.tr(),
            style: const TextStyle(
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
          width: 850,
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
              _buildSchoolHeader(school),
              const SizedBox(height: 12),
              _buildReportTitle(
                year: data.academicYear?.toString() ?? "-",
                className: student?.className?.toString() ?? "-",
                sectionName: student?.sectionName?.toString() ?? "-",
              ),
              const SizedBox(height: 16),
              _buildStudentProfile(student),
              const SizedBox(height: 16),
              _buildAttendance(data),
              const SizedBox(height: 16),
              _buildScholasticSection(data.scholastic),
              const SizedBox(height: 16),
              _buildSummaryCards(data),
              const SizedBox(height: 16),
              _buildCoScholasticAndScaleSection(data.coScholastic),
              const SizedBox(height: 40),
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
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                school?.schoolName?.toString() ?? 'marksheets_preview.school_name_default'.tr(),
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
                school?.schoolAdrees?.toString() ?? 'marksheets_preview.school_address_default'.tr(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
              Text(
                'marksheets_preview.email_label'.tr(
                  namedArgs: {'email': school?.schoolEmail ?? "-"},
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 9, color: Colors.black54),
              ),
              Text(
                'marksheets_preview.phone_label'.tr(
                  namedArgs: {'phone': school?.schoolPhoneNumber ?? "-"},
                ),
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
          'marksheets_preview.report_card'.tr(namedArgs: {'year': year}),
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
            child: Text(
              'marksheets_preview.student_profile'.tr(),
              style: const TextStyle(
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
                  'marksheets_preview.name_of_student'.tr(),
                  student?.name,
                  'marksheets_preview.roll_no'.tr(),
                  student?.rollNo,
                ),
                _buildProfileTableRow(
                  'marksheets_preview.admission_no'.tr(),
                  student?.admissionNo,
                  'marksheets_preview.section'.tr(),
                  student?.sectionName,
                ),
                _buildProfileTableRow(
                  'marksheets_preview.date_of_birth'.tr(),
                  student?.dob,
                  'marksheets_preview.class'.tr(),
                  student?.className,
                ),
                _buildProfileTableRow(
                  'marksheets_preview.mother_name'.tr(),
                  student?.motherName,
                  'marksheets_preview.father_name'.tr(),
                  student?.fatherName,
                ),
                _buildProfileTableRow(
                  'marksheets_preview.address'.tr(),
                  student?.address,
                  "",
                  "",
                ),
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
          Text(
            'marksheets_preview.attendance'.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: primaryBlue,
            ),
          ),
          const SizedBox(width: 24),
          Text(
            'marksheets_preview.total_working_days'.tr(),
            style: const TextStyle(fontSize: 11),
          ),
          Text(
            "${data.attendance?.totalWorkingDays ?? 0}",
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const SizedBox(width: 24),
          Text(
            'marksheets_preview.total_attendance'.tr(),
            style: const TextStyle(fontSize: 11),
          ),
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
            'marksheets_preview.roll_no_label'.tr(
              namedArgs: {'rollNo': rollNo},
            ),
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
          child: Text(
            'marksheets_preview.scholastic_area'.tr(),
            style: const TextStyle(
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
              TableRow(
                decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'marksheets_preview.subject'.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'marksheets_preview.max'.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'marksheets_preview.obtained'.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'marksheets_preview.grade'.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
              : Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'marksheets_preview.no_scholastic_records'.tr(),
                style: const TextStyle(
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
    final isPass = percentage >= 33.0;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'marksheets_preview.cgpa'.tr(),
            data.cgpa ?? "—",
            const Color(0xFF153D91),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            'marksheets_preview.overall_percent'.tr(),
            "$percentage%",
            const Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            'marksheets_preview.result'.tr(),
            isPass ? 'marksheets_preview.pass'.tr() : 'marksheets_preview.fail'.tr(),
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
        Expanded(flex: 3, child: _buildCoScholasticTable(coScholasticData)),
        const SizedBox(width: 16),
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
          child: Text(
            'marksheets_preview.co_scholastic_area'.tr(),
            style: const TextStyle(
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
            TableRow(
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'marksheets_preview.activity'.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      'marksheets_preview.term1'.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      'marksheets_preview.term2'.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (subjectIds.isEmpty)
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'marksheets_preview.no_co_scholastic_records'.tr(),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(),
                  const SizedBox(),
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
          child: Text(
            'marksheets_preview.scale_indicators'.tr(),
            style: const TextStyle(
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
            _buildScaleRow("A1", 'marksheets_preview.outstanding'.tr(), const Color(0xFF2E7D32)),
            _buildScaleRow("A2", 'marksheets_preview.excellent'.tr(), Colors.blue),
            _buildScaleRow("B1", 'marksheets_preview.very_good'.tr(), Colors.purple.shade400),
            _buildScaleRow("B2", 'marksheets_preview.good'.tr(), Colors.cyan.shade700),
            _buildScaleRow("C1", 'marksheets_preview.above_average'.tr(), Colors.orange),
            _buildScaleRow("C2", 'marksheets_preview.average'.tr(), Colors.orange.shade300),
            _buildScaleRow("D", 'marksheets_preview.below_average'.tr(), Colors.redAccent),
            _buildScaleRow("E", 'marksheets_preview.needs_effort'.tr(), Colors.red.shade900),
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
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SignatureLabel(title: 'marksheets_preview.director'.tr()),
            _SignatureLabel(title: 'marksheets_preview.class_teacher'.tr()),
            _SignatureLabel(title: 'marksheets_preview.principal'.tr()),
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
        ),
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