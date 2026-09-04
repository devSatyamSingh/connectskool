import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';  // ← ADD THIS
import '../../view_model/school_view_model/marksheet/generate_marksheet_view_model.dart';

class ChartMarksheetPreviewWidget extends StatelessWidget {
  const ChartMarksheetPreviewWidget({super.key});

  static const Color brandRed = Color(0xFFBA1A1A);
  static const Color darkSlateBlue = Color(0xFF2F3B52);
  static const Color lightGreyBg = Color(0xFFF9F9F9);
  static const Color borderGrey = Color(0xFFCCCCCC);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GenerateMarksheetViewModel>();
    final data = vm.marksheetModel?.data;

    if (data == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'marksheet_preview.no_data'.tr(),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
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
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(data.academicYear ?? "2026-27"),
              const SizedBox(height: 20),
              _buildStudentProfile(student),
              const SizedBox(height: 16),
              _buildScholasticBox(data.scholastic),
              const SizedBox(height: 16),
              _buildCoScholasticSection(data),
              const SizedBox(height: 24),
              _buildInstructionTable(),
              const SizedBox(height: 36),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String academicYear) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: brandRed,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.school,
                color: Colors.white,
                size: 28,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'marksheet_preview.school_name'.tr(),
                    style: const TextStyle(
                      color: brandRed,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'marksheet_preview.trust_line'.tr(),
                    style: const TextStyle(
                      color: brandRed,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'marksheet_preview.address'.tr(),
                    style: const TextStyle(fontSize: 9, color: Colors.black54),
                  ),
                  Text(
                    'marksheet_preview.contact'.tr(),
                    style: const TextStyle(fontSize: 9, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.menu_book_outlined,
              color: brandRed,
              size: 42,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: brandRed, width: 1.5),
              bottom: BorderSide(color: brandRed, width: 1.5),
            ),
          ),
          child: Text(
            '${'marksheet_preview.progress_report'.tr()} • $academicYear',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentProfile(student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'marksheet_preview.student_profile'.tr(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            decoration: TextDecoration.underline,
          ),
        ),
        const SizedBox(height: 8),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1.2),
            1: FlexColumnWidth(2.0),
            2: FlexColumnWidth(1.2),
            3: FlexColumnWidth(1.5),
          },
          children: [
            _buildProfileRow(
              'marksheet_preview.name_of_student'.tr(),
              student?.name,
              'marksheet_preview.class_section'.tr(),
              "${student?.className ?? ""} - ${student?.sectionName ?? ""}",
            ),
            _buildProfileRow(
              'marksheet_preview.mother_name'.tr(),
              student?.motherName,
              'marksheet_preview.roll_no'.tr(),
              student?.rollNo,
            ),
            _buildProfileRow(
              'marksheet_preview.father_name'.tr(),
              student?.fatherName,
              'marksheet_preview.dob'.tr(),
              student?.dob,
            ),
            _buildProfileRow(
              'marksheet_preview.admission_no'.tr(),
              student?.admissionNo,
              "",
              "",
            ),
          ],
        ),
      ],
    );
  }

  TableRow _buildProfileRow(String label1, String? v1, String label2, String? v2) {
    const lblStyle = TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87);
    const valStyle = TextStyle(fontSize: 11, color: Colors.black);

    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Text(label1, style: lblStyle)),
        Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Text(v1 != null && v1.isNotEmpty ? ": $v1" : "", style: valStyle)),
        Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Text(label2, style: lblStyle)),
        Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Text(v2 != null && v2.isNotEmpty ? ": $v2" : "", style: valStyle)),
      ],
    );
  }

  Widget _buildScholasticBox(Map<String, dynamic>? scholastic) {
    final bool hasData = scholastic != null && scholastic.isNotEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: borderGrey),
      ),
      child: Center(
        child: Text(
          hasData ? 'marksheet_preview.scholastic_records'.tr() : 'marksheet_preview.no_scholastic_records'.tr(),
          style: TextStyle(
            color: hasData ? Colors.black : Colors.black38,
            fontSize: 11,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _buildCoScholasticSection(data) {
    final term1 = data.coScholastic?["term1"] ?? {};
    final term2 = data.coScholastic?["term2"] ?? {};

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: _buildCoScholasticTable(term1, term2),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: _buildRightGradeScale(),
        ),
      ],
    );
  }

  Widget _buildCoScholasticTable(Map term1, Map term2) {
    final allSubjects = <String>{}
      ..addAll(term1.keys.cast<String>())
      ..addAll(term2.keys.cast<String>());

    final List<Map<String, String>> displayedRows = [];
    if (allSubjects.isEmpty) {
      displayedRows.addAll([
        {"name": "Music", "t1": "A1", "t2": "—"},
        {"name": "Hindi", "t1": "B2", "t2": "—"},
      ]);
    } else {
      for (var key in allSubjects) {
        final t1 = term1[key];
        final t2 = term2[key];
        displayedRows.add({
          "name": t1?["subject_name"] ?? t2?["subject_name"] ?? "Activity",
          "t1": t1?["grade"] ?? "—",
          "t2": t2?["grade"] ?? "—",
        });
      }
    }

    return Table(
      border: TableBorder.all(color: borderGrey),
      columnWidths: const {
        0: FlexColumnWidth(2.5),
        1: FlexColumnWidth(1.0),
        2: FlexColumnWidth(1.0),
        3: FlexColumnWidth(2.5),
        4: FlexColumnWidth(1.0),
        5: FlexColumnWidth(1.0),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: darkSlateBlue),
          children: [
            _TableHeaderCell('marksheet_preview.co_scholastic_area'.tr()),
            _TableHeaderCell('marksheet_preview.term1'.tr()),
            _TableHeaderCell('marksheet_preview.term2'.tr()),
            _TableHeaderCell('marksheet_preview.co_scholastic_area'.tr()),
            _TableHeaderCell('marksheet_preview.term1'.tr()),
            _TableHeaderCell('marksheet_preview.term2'.tr()),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell(displayedRows.isNotEmpty ? displayedRows[0]["name"]! : "Music", alignLeft: true),
            _buildTableCell(displayedRows.isNotEmpty ? displayedRows[0]["t1"]! : "A1"),
            _buildTableCell(displayedRows.isNotEmpty ? displayedRows[0]["t2"]! : "—"),
            _buildTableCell("History", alignLeft: true),
            _buildTableCell("A1"),
            _buildTableCell("—"),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell(displayedRows.length > 1 ? displayedRows[1]["name"]! : "Hindi", alignLeft: true),
            _buildTableCell(displayedRows.length > 1 ? displayedRows[1]["t1"]! : "B2"),
            _buildTableCell(displayedRows.length > 1 ? displayedRows[1]["t2"]! : "—"),
            _buildTableCell("Music", alignLeft: true),
            _buildTableCell("—"),
            _buildTableCell("A1"),
          ],
        ),
      ],
    );
  }

  Widget _buildRightGradeScale() {
    final scales = [
      ['marksheet_preview.grade_a1'.tr(), 'marksheet_preview.outstanding'.tr()],
      ['marksheet_preview.grade_a2'.tr(), 'marksheet_preview.excellent'.tr()],
      ['marksheet_preview.grade_b1'.tr(), 'marksheet_preview.very_good'.tr()],
      ['marksheet_preview.grade_b2'.tr(), 'marksheet_preview.good'.tr()],
      ['marksheet_preview.grade_c1'.tr(), 'marksheet_preview.above_average'.tr()],
      ['marksheet_preview.grade_c2'.tr(), 'marksheet_preview.average'.tr()],
      ['marksheet_preview.grade_d'.tr(), 'marksheet_preview.below_average'.tr()],
    ];

    return Table(
      border: TableBorder.all(color: borderGrey),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2.2),
      },
      children: scales.map((item) {
        return TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: Text(
                  item[0],
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              child: Text(
                item[1],
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildInstructionTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'marksheet_preview.grade_scale_title'.tr(),
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        Table(
          border: TableBorder.all(color: borderGrey),
          children: [
            TableRow(
              decoration: const BoxDecoration(color: brandRed),
              children: [
                _ScaleHeaderCell('marksheet_preview.range_91_100'.tr()),
                _ScaleHeaderCell('marksheet_preview.range_81_90'.tr()),
                _ScaleHeaderCell('marksheet_preview.range_71_80'.tr()),
                _ScaleHeaderCell('marksheet_preview.range_61_70'.tr()),
                _ScaleHeaderCell('marksheet_preview.range_51_60'.tr()),
                _ScaleHeaderCell('marksheet_preview.range_41_50'.tr()),
                _ScaleHeaderCell('marksheet_preview.range_33_40'.tr()),
                _ScaleHeaderCell('marksheet_preview.range_below_32'.tr()),
              ],
            ),
            TableRow(
              children: [
                _ScaleValueCell('marksheet_preview.grade_a1'.tr(), Colors.green),
                _ScaleValueCell('marksheet_preview.grade_a2'.tr(), Colors.blue),
                _ScaleValueCell('marksheet_preview.grade_b1'.tr(), Colors.purple),
                _ScaleValueCell('marksheet_preview.grade_b2'.tr(), Colors.cyan),
                _ScaleValueCell('marksheet_preview.grade_c1'.tr(), Colors.orange),
                _ScaleValueCell('marksheet_preview.grade_c2'.tr(), Colors.orangeAccent),
                _ScaleValueCell('marksheet_preview.grade_d'.tr(), Colors.redAccent),
                _ScaleValueCell('marksheet_preview.grade_e'.tr(), Colors.red, isSmall: true),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${'marksheet_preview.date_label'.tr()} : 16-06-2026',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            _buildSignatureLine('marksheet_preview.class_teacher'.tr()),
            const SizedBox(width: 48),
            _buildSignatureLine('marksheet_preview.principal'.tr()),
          ],
        ),
      ],
    );
  }

  Widget _buildSignatureLine(String designation) {
    return Column(
      children: [
        Container(width: 140, height: 1, color: Colors.black38),
        const SizedBox(height: 6),
        Text(
          designation,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool alignLeft = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Container(
        alignment: alignLeft ? Alignment.centerLeft : Alignment.center,
        child: Text(
          text,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          textAlign: alignLeft ? TextAlign.left : TextAlign.center,
        ),
      ),
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final String text;
  const _TableHeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ScaleHeaderCell extends StatelessWidget {
  final String text;
  const _ScaleHeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _ScaleValueCell extends StatelessWidget {
  final String text;
  final Color color;
  final bool isSmall;
  const _ScaleValueCell(this.text, this.color, {this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: color,
              fontSize: isSmall ? 8 : 10,
              fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}