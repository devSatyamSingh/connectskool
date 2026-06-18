import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../model/school_model/classes/all_classes_model.dart';
import '../model/school_model/section/all_sections_model.dart';
import '../../model/student_model/timetable_model.dart';
import '../view_model/school_view_model/classes/all_classes_view_model.dart';
import '../res/app_color.dart';
import '../utils/permission_extensions.dart';
import '../utils/permission_keys.dart';
import '../utils/utils.dart';
import '../view_model/school_view_model/section/all_scetions_view_model.dart';
import '../view_model/student_view_model/timetable_viewmodel.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SchoolTimetableView extends StatefulWidget {
  const SchoolTimetableView({super.key});

  @override
  State<SchoolTimetableView> createState() => _SchoolTimetableViewState();
}

class _SchoolTimetableViewState extends State<SchoolTimetableView> {
  Data? _selectedClass;
  SectionData? _selectedSection;
  String _selectedDay = "All Days";
  bool _isGeneratingPdf = false;

  static const List<String> _days = [
    "All Days",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  static const LinearGradient _primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      if (!PermissionExtensions.canAccess(
        PermissionKeys.viewTimetable,
      )) {

        Utils.show(
          "You don't have permission to view timetable",
          context,
        );

        Navigator.pop(context);
        return;
      }

      context.read<AllClassesViewModel>().allClassesApi(context);
    });
  }

  Future<void> _loadTimetable() async {
    if (_selectedClass == null) {
      _showSnack("Please select class");
      return;
    }

    if (_selectedSection == null) {
      _showSnack("Please select section");
      return;
    }

    await context.read<SchoolTimetableViewModel>().getTimetable(
      context,
      _selectedClass!.classId.toString(),
      _selectedSection!.sectionId.toString(),
    );
  }

  void _showSnack(String message) {
    Utils.show(
      message,
      context,
      type: 'error',
    );
  }
  List<TimetableData> _filteredData(List<TimetableData> data) {
    if (_selectedDay == "All Days") return data;
    return data
        .where(
          (e) =>
              (e.dayOfWeek ?? "").toLowerCase() == _selectedDay.toLowerCase(),
        )
        .toList();
  }


  Future<void> _downloadPdf(
      List<TimetableData> displayData,
      ) async {

    if (displayData.isEmpty) {
      Utils.show(
        "No timetable available",
        context,
        type: "warning",
      );
      return;
    }

    setState(() {
      _isGeneratingPdf = true;
    });

    try {

      final bytes =
      await TimetablePdfGenerator.generate(
        data: displayData,
        className:
        displayData.first.className ??
            _selectedClass?.className ??
            "",
        sectionName:
        displayData.first.sectionName ??
            _selectedSection?.sectionName ??
            "",
        dayLabel: _selectedDay,
      );

      Directory directory;

      if (Platform.isAndroid) {

        await Permission.storage.request();

        directory =
            Directory("/storage/emulated/0/Download");

      } else {

        directory =
        await getApplicationDocumentsDirectory();
      }

      final fileName =
          "School_Timetable_${DateTime.now().millisecondsSinceEpoch}.pdf";

      final file =
      File("${directory.path}/$fileName");

      await file.writeAsBytes(bytes);

      Utils.show(
        "PDF Downloaded Successfully",
        context,
        type: "success",
      );

      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      OpenFile.open(file.path);

    } catch (e) {

      debugPrint(
        "PDF DOWNLOAD ERROR => $e",
      );

      Utils.show(
        "Failed to download PDF",
        context,
        type: "error",
      );
    }

    if (mounted) {
      setState(() {
        _isGeneratingPdf = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isTablet = width > 700;

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColor.primaryGradient,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(.25),
                blurRadius: 8,
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "School Timetable",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          "View class schedule by day and period",
                          style: TextStyle(
                            color: Colors.white.withOpacity(.9),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Consumer3<
          AllClassesViewModel,
          AllSectionsViewModel,
          SchoolTimetableViewModel>(
        builder: (
            context,
            classVm,
            sectionVm,
            timetableVm,
            child,
            ) {
          final allData =
              timetableVm.timetableModel?.data ?? [];

          final displayData =
          _filteredData(allData);

          final totalPeriods =
              displayData.length;

          final totalDays =
              displayData
                  .map((e) => e.dayOfWeek)
                  .toSet()
                  .length;

          final totalSubjects =
              displayData
                  .map((e) => e.subjectName)
                  .toSet()
                  .length;

          final totalTeachers =
              displayData
                  .map((e) => e.teacherName)
                  .toSet()
                  .length;

          return RefreshIndicator(
            color: const Color(0xFF1E88E5),

            onRefresh: () async {
              if (_selectedClass != null &&
                  _selectedSection != null) {
                await _loadTimetable();
              }
            },

            child: SingleChildScrollView(
              physics:
              const AlwaysScrollableScrollPhysics(),

              padding: EdgeInsets.all(
                width * 0.025,
              ),

              child: Column(
                children: [

                  /// FILTER CARD
                  _buildFilterCard(
                    width: width,
                    height: height,
                    isTablet: isTablet,
                    classVm: classVm,
                    sectionVm: sectionVm,
                    hasData: allData.isNotEmpty,
                    displayData: displayData,
                  ),

                  SizedBox(
                    height: height * 0.015,
                  ),

                  /// SUMMARY GRID
                  if (displayData.isNotEmpty)
                    _buildSummaryGrid(
                      width: width,
                      totalPeriods: totalPeriods,
                      totalDays: totalDays,
                      totalSubjects: totalSubjects,
                      totalTeachers: totalTeachers,
                    ),

                  SizedBox(
                    height:
                    displayData.isNotEmpty
                        ? height * 0.015
                        : 0,
                  ),

                  /// TIMETABLE BODY
                  _buildTimetableBody(
                    width: width,
                    height: height,
                    isTablet: isTablet,
                    timetableVm: timetableVm,
                    displayData: displayData,
                  ),

                  SizedBox(
                    height: height * 0.05,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildFilterCard({
    required double width,
    required double height,
    required bool isTablet,
    required AllClassesViewModel classVm,
    required AllSectionsViewModel sectionVm,
    required bool hasData,
    required List<TimetableData> displayData,
  }) {
    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (isTablet)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _labeledField(
                    "CLASS",
                    _classDropdown(classVm, sectionVm),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _labeledField("SECTION", _sectionDropdown(sectionVm)),
                ),
                const SizedBox(width: 16),
                Expanded(child: _labeledField("FILTER BY DAY", _dayDropdown())),
              ],
            )
          else ...[
            _labeledField("CLASS", _classDropdown(classVm, sectionVm)),
            SizedBox(height: height * 0.018),
            Row(
              children: [
                Expanded(
                  child: _labeledField("SECTION", _sectionDropdown(sectionVm)),
                ),
                const SizedBox(width: 12),
                Expanded(child: _labeledField("FILTER BY DAY", _dayDropdown())),
              ],
            ),
          ],
          SizedBox(height: height * 0.02),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _loadTimetable,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF1E88E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh_rounded, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Load Timetable",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              if (hasData) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isGeneratingPdf
                        ? null
                        : () => _downloadPdf(displayData),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _isGeneratingPdf
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.picture_as_pdf, size: 20),
                              SizedBox(width: 8),
                              Text(
                                "Download PDF",
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _labeledField(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        field,
      ],
    );
  }

  Widget _classDropdown(
    AllClassesViewModel classVm,
    AllSectionsViewModel sectionVm,
  ) {
    return DropdownButtonFormField<Data>(
      dropdownColor: Colors.white,
      value: _selectedClass,
      isExpanded: true,
      decoration: _ddDecoration(hint: "Select Class"),
      items: classVm.allClassesModel?.data
          ?.map(
            (item) => DropdownMenuItem<Data>(
              value: item,
              child: Text(
                item.className ?? "",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ),
          )
          .toList(),
      onChanged: (value) async {
        setState(() {
          _selectedClass = value;
          _selectedSection = null;
        });

        if (value != null) {
          await sectionVm.allSectionsApi(context, value.classId.toString());
        }
      },
    );
  }

  Widget _sectionDropdown(AllSectionsViewModel sectionVm) {
    return DropdownButtonFormField<SectionData>(
      dropdownColor: Colors.white,
      value: _selectedSection,
      isExpanded: true,
      decoration: _ddDecoration(hint: "Select Section"),
      items: sectionVm.allSectionsModel?.data
          ?.map(
            (item) => DropdownMenuItem<SectionData>(
              value: item,
              child: Text(
                item.sectionName ?? "",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() => _selectedSection = value);
      },
    );
  }

  Widget _dayDropdown() {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      value: _selectedDay,
      isExpanded: true,
      decoration: _ddDecoration(hint: "All Days"),
      items: _days
          .map((day) => DropdownMenuItem(value: day, child: Text(day, style: GoogleFonts.poppins(),)))
          .toList(),
      onChanged: (value) {
        setState(() => _selectedDay = value ?? "All Days");
      },
    );
  }

  InputDecoration _ddDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      filled: true,
      fillColor: const Color(0xffF5F7FB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color(0xFF1E88E5), width: 1.5),
      ),
    );
  }

  Widget _buildSummaryGrid({
    required double width,
    required int totalPeriods,
    required int totalDays,
    required int totalSubjects,
    required int totalTeachers,
  }) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: width > 700 ? 4 : 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 11,
      mainAxisSpacing: 12,
      children: [
        _summaryCard(
          "Total Periods",
          "$totalPeriods",
          const Color(0xFF1E88E5),
          Icons.schedule_rounded,
        ),
        _summaryCard(
          "Days",
          "$totalDays",
          const Color(0xFF4CAF50),
          Icons.calendar_today_rounded,
        ),
        _summaryCard(
          "Subjects",
          "$totalSubjects",
          const Color(0xFF9C27B0),
          Icons.menu_book_rounded,
        ),
        _summaryCard(
          "Teachers",
          "$totalTeachers",
          const Color(0xFFFF6B35),
          Icons.person_rounded,
        ),
      ],
    );
  }

  Widget _summaryCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.08), color.withOpacity(0.02)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimetableBody({
    required double width,
    required double height,
    required bool isTablet,
    required SchoolTimetableViewModel timetableVm,
    required List<TimetableData> displayData,
  }) {
    if (timetableVm.loading) {
      return Container(
        height: height * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child:  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF1E88E5)),
              SizedBox(height: 16),
              Text(
                "Loading timetable...",
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    if (displayData.isEmpty) {
      return _buildNoTimetableCard(width);
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(width * 0.045),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: _primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${displayData.first.className ?? ""} * Section ${displayData.first.sectionName ?? ""}",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${displayData.length} periods · ${_selectedDay == "All Days" ? "All Days" : _selectedDay}",
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (isTablet) _buildTableHeader(width),
          if (isTablet)
            ...List.generate(
              displayData.length,
              (i) => _buildPeriodRow(width, displayData[i], i),
            )
          else
            Padding(
              padding: EdgeInsets.all(width * 0.04),
              child: ListView.separated(
                itemCount: displayData.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _buildPeriodCard(width, displayData[index]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNoTimetableCard(double width) {
    final bool dayFilterActive = _selectedDay != "All Days";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade50, Colors.blue.shade100],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_busy_rounded,
              size: 50,
              color: Colors.blue.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            dayFilterActive ? "No Periods Found" : "No Timetable Found",
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Text(
            dayFilterActive
                ? "No periods are scheduled for $_selectedDay.\nTry selecting a different day."
                : "Select a class and section, then tap\n\"Load Timetable\" to view the schedule.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.grey.shade600,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTableHeader(double width) {
    return Container(
      color: const Color(0xffF8FAFC),
      padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: 14),
      child: Row(
        children: [
          Expanded(flex: 3, child: _headerText("SUBJECT")),
          Expanded(flex: 3, child: _headerText("TEACHER")),
          Expanded(flex: 2, child: _headerText("DAY")),
          Expanded(flex: 3, child: _headerText("TIME")),
        ],
      ),
    );
  }

  Widget _headerText(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade600,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildPeriodRow(double width, TimetableData item, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: width * 0.045, vertical: 18),
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.white : const Color(0xffF8FAFC),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              item.subjectName ?? "-",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              item.teacherName ?? "-",
              style: GoogleFonts.poppins(fontSize: 13),
            ),
          ),
          Expanded(flex: 2, child: _dayBadge(item.dayOfWeek)),
          Expanded(
            flex: 3,
            child: Text(
              "${item.startTime ?? ""} – ${item.endTime ?? ""}",
              style: GoogleFonts.poppins(color: Colors.grey.shade700, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodCard(double width, TimetableData item) {
    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: _primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getSubjectIcon(item.subjectName),
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.subjectName ?? "",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _dayBadge(item.dayOfWeek),
            ],
          ),
          const SizedBox(height: 16),
          _infoTile(Icons.person_rounded, "Teacher", item.teacherName ?? "-"),
          const SizedBox(height: 12),
          _infoTile(
            Icons.access_time_rounded,
            "Time",
            "${item.startTime ?? ""} - ${item.endTime ?? ""}",
          ),
        ],
      ),
    );
  }

  IconData _getSubjectIcon(String? subject) {
    final s = subject?.toLowerCase() ?? '';
    if (s.contains('math')) return Icons.calculate_rounded;
    if (s.contains('science')) return Icons.science_rounded;
    if (s.contains('english')) return Icons.menu_book_rounded;
    if (s.contains('hindi')) return Icons.translate_rounded;
    if (s.contains('history')) return Icons.history_edu_rounded;
    if (s.contains('geo')) return Icons.public_rounded;
    if (s.contains('computer')) return Icons.computer_rounded;
    return Icons.class_rounded;
  }

  Widget _dayBadge(String? day) {
    final colors = _dayColor(day);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        day ?? "-",
        style: GoogleFonts.poppins(
          color: colors.fg,
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),
    );
  }

  ({Color bg, Color fg}) _dayColor(String? day) {
    switch ((day ?? "").toLowerCase()) {
      case "monday":
        return (bg: Colors.indigo.shade50, fg: Colors.indigo.shade700);
      case "tuesday":
        return (bg: Colors.green.shade50, fg: Colors.green.shade700);
      case "wednesday":
        return (bg: Colors.orange.shade50, fg: Colors.orange.shade800);
      case "thursday":
        return (bg: Colors.red.shade50, fg: Colors.red.shade700);
      case "friday":
        return (bg: Colors.cyan.shade50, fg: Colors.cyan.shade800);
      case "saturday":
        return (bg: Colors.purple.shade50, fg: Colors.purple.shade700);
      case "sunday":
        return (bg: Colors.pink.shade50, fg: Colors.pink.shade700);
      default:
        return (bg: Colors.blue.shade50, fg: Colors.blue.shade700);
    }
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: Colors.grey.shade700),
        ),
        const SizedBox(width: 12),
        Text(
          "$title:",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 13),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: 13))),
      ],
    );
  }
}


class TimetablePdfGenerator {
  TimetablePdfGenerator._();

  static const PdfColor _primaryBlue = PdfColor.fromInt(0xFF1A56A8);
  static const PdfColor _greySubtitle = PdfColor.fromInt(0xFF6B7280);
  static const PdfColor _greyBorder = PdfColor.fromInt(0xFFE5E7EB);
  static const PdfColor _lightBg = PdfColor.fromInt(0xFFF0F4FF);

  static Future<Uint8List> generate({
    required List<TimetableData> data,
    required String className,
    required String sectionName,
    required String dayLabel,
  }) async {
    final pdf = pw.Document();

    final now = DateTime.now();
    final printedAt = DateFormat('dd/MM/yyyy, HH:mm').format(now);
    final officialDate = DateFormat('MMMM d, yyyy').format(now);

    // Group data by day for better organization
    final grouped = _groupByDay(data);
    final dayOrder = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    final sortedDays = dayOrder.where((d) => grouped.containsKey(d)).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(32, 24, 32, 24),
        header: (context) => _buildHeader(printedAt),

        build: (context) => [
          pw.SizedBox(height: 16),
          _buildTitle(className, sectionName, dayLabel),
          pw.SizedBox(height: 20),
          // Build sections for each day
          for (final day in sortedDays) _buildDaySection(day, grouped[day]!),
          pw.SizedBox(height: 48),
          _buildSignatureRow(officialDate),
        ],
      ),
    );

    return pdf.save();
  }

  static Map<String, List<TimetableData>> _groupByDay(
    List<TimetableData> data,
  ) {
    final Map<String, List<TimetableData>> grouped = {};
    for (final item in data) {
      final day = item.dayOfWeek?.toString() ?? 'Unknown';
      grouped.putIfAbsent(day, () => []).add(item);
    }
    return grouped;
  }

  static pw.Widget _buildHeader(String printedAt) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            printedAt,
            style: const pw.TextStyle(fontSize: 8, color: _greySubtitle),
          ),
          pw.Text(
            "School Dashboard - Student Portal",
            style: const pw.TextStyle(fontSize: 8, color: _greySubtitle),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(
    String schoolName,
    String schoolPhone,
    String schoolEmail,
    String schoolShortCode,
  ) {
    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Divider(color: _greyBorder, thickness: 0.5),
        pw.SizedBox(height: 4),
        pw.Center(
          child: pw.Text(
            "$schoolName | $schoolPhone | $schoolEmail | $schoolShortCode",
            style: const pw.TextStyle(fontSize: 8, color: _greySubtitle),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildSchoolBanner({
    required String schoolName,
    required String schoolPhone,
    required String schoolEmail,
    required String schoolShortCode,
    required String officialDate,
  }) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              schoolName,
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
                color: _primaryBlue,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              "$schoolPhone | $schoolEmail | $schoolShortCode",
              style: const pw.TextStyle(fontSize: 9, color: _greySubtitle),
            ),
          ],
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: _primaryBlue, width: 0.8),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                "OFFICIAL DOCUMENT",
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  color: _primaryBlue,
                  letterSpacing: 0.6,
                ),
              ),
              pw.SizedBox(height: 3),
              pw.Text(officialDate, style: const pw.TextStyle(fontSize: 9)),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTitle(
    String className,
    String sectionName,
    String dayLabel,
  ) {
    final classLine = StringBuffer("Class: ");
    classLine.write(className.isEmpty ? "-" : className);
    if (sectionName.isNotEmpty) {
      classLine.write(" - Section $sectionName");
    }
    classLine.write(" * $dayLabel");

    return pw.Center(
      child: pw.Column(
        children: [
          pw.Text(
            "CLASS TIMETABLE",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: _primaryBlue,
              letterSpacing: 3,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            classLine.toString(),
            style: const pw.TextStyle(fontSize: 10, color: _greySubtitle),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildDaySection(String day, List<TimetableData> periods) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 16),
        // Day Header
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: pw.BoxDecoration(
            color: _lightBg,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                day,
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: _primaryBlue,
                ),
              ),
              pw.Text(
                '${periods.length} ${periods.length == 1 ? 'Period' : 'Periods'}',
                style: const pw.TextStyle(fontSize: 11, color: _primaryBlue),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 8),
        // Periods Table
        pw.Table(
          border: pw.TableBorder.all(color: _greyBorder, width: 0.5),
          columnWidths: const {
            0: pw.FlexColumnWidth(1.2), // S.No
            1: pw.FlexColumnWidth(2.5), // Subject
            2: pw.FlexColumnWidth(2.5), // Teacher
            3: pw.FlexColumnWidth(1.5), // Day
            4: pw.FlexColumnWidth(1.8), // Start Time
            5: pw.FlexColumnWidth(1.8), // End Time
          },
          children: [
            // Table Header
            pw.TableRow(
              decoration: const pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFE3EAFD),
              ),
              children:
                  const [
                        "S.No",
                        "Subject",
                        "Teacher",
                        "Day",
                        "Start Time",
                        "End Time",
                      ]
                      .map(
                        (h) => pw.Padding(
                          padding: pw.EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 6,
                          ),
                          child: pw.Text(
                            h,
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
            // Data Rows
            for (var i = 0; i < periods.length; i++)
              _buildRow(i + 1, periods[i]),
          ],
        ),
      ],
    );
  }

  static pw.TableRow _buildRow(int serial, TimetableData item) {
    return pw.TableRow(
      children: [
        _cell("$serial", align: pw.TextAlign.center),
        _cell(item.subjectName ?? "-", bold: true),
        _cell(item.teacherName ?? "-"),
        _cell(item.dayOfWeek ?? "-", color: _getDayColor(item.dayOfWeek)),
        _cell(item.startTime ?? "-"),
        _cell(item.endTime ?? "-"),
      ],
    );
  }

  static pw.Widget _cell(
    String text, {
    bool bold = false,
    PdfColor? color,
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 9, horizontal: 6),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: 9.5,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color ?? PdfColors.black,
        ),
      ),
    );
  }

  static PdfColor _getDayColor(String? day) {
    switch ((day ?? "").toLowerCase()) {
      case "monday":
        return const PdfColor.fromInt(0xFF4338CA); // Indigo
      case "tuesday":
        return const PdfColor.fromInt(0xFF15803D); // Green
      case "wednesday":
        return const PdfColor.fromInt(0xFFB45309); // Orange
      case "thursday":
        return const PdfColor.fromInt(0xFFB91C1C); // Red
      case "friday":
        return const PdfColor.fromInt(0xFF0E7490); // Cyan
      case "saturday":
        return const PdfColor.fromInt(0xFF7E22CE); // Purple
      case "sunday":
        return const PdfColor.fromInt(0xFF9D174D); // Pink
      default:
        return PdfColors.black;
    }
  }

  static pw.Widget _buildSignatureRow(String officialDate) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildStampWidget(),
            pw.SizedBox(height: 12),
            pw.Text(
              "Date: $officialDate",
              style: const pw.TextStyle(fontSize: 9),
            ),
          ],
        ),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            _buildSignatureBlock("Class Teacher"),
            pw.SizedBox(width: 32),
            _buildSignatureBlock("Principal"),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildStampWidget() {
    return pw.Container(
      width: 70,
      height: 70,
      alignment: pw.Alignment.center,
      decoration: const pw.BoxDecoration(
        shape: pw.BoxShape.circle,
        border: pw.Border.fromBorderSide(
          pw.BorderSide(
            color: PdfColors.grey400,
            width: 0.8,
            style: pw.BorderStyle.dashed,
          ),
        ),
      ),
      child: pw.Text(
        "SCHOOL\nSTAMP",
        textAlign: pw.TextAlign.center,
        style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey500),
      ),
    );
  }

  static pw.Widget _buildSignatureBlock(String label) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Container(width: 110, height: 0.8, color: PdfColors.black),
        pw.SizedBox(height: 4),
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            color: _primaryBlue,
          ),
        ),
        pw.Text(
          "SIGNATURE",
          style: const pw.TextStyle(
            fontSize: 7,
            color: PdfColors.grey500,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
