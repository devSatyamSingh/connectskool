import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/utils/routes/routes_name.dart';
import 'package:school_pro/view_model/school_view_model/attendance/all_attendance_view_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:easy_localization/easy_localization.dart';  // ← ADD THIS

import '../../res/app_color.dart';
import '../../res/const_text.dart';
import '../../view_model/school_view_model/classes/all_classes_view_model.dart';
import '../../view_model/school_view_model/section/all_scetions_view_model.dart';

class SchoolAttendanceScreen extends StatefulWidget {
  const SchoolAttendanceScreen({super.key});

  @override
  State<SchoolAttendanceScreen> createState() => _SchoolAttendanceScreenState();
}

class _SchoolAttendanceScreenState extends State<SchoolAttendanceScreen> {
  String? selectedClass;
  String? selectedSection;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AllClassesViewModel>(context, listen: false)
          .allClassesApi(context);
    });
  }

  String get _apiDate => DateFormat('yyyy/MM/dd').format(_selectedDate);
  String get _displayDate => DateFormat('dd MMM yyyy').format(_selectedDate);

  void _fetchAttendance() {
    if (selectedClass != null && selectedSection != null) {
      print("📌 Fetching attendance → class=$selectedClass section=$selectedSection date=$_apiDate");
      Provider.of<AllAttendanceViewModel>(context, listen: false)
          .getAttendance(
        classId:   int.parse(selectedClass!),
        sectionId: int.parse(selectedSection!),
        date:      _apiDate,
        context:   context,
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (c, child) => Theme(
        data: Theme.of(c).copyWith(
          colorScheme: ColorScheme.light(primary: AppColor.lightBlueColor),
        ),
        child: child!,
      ),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
      _fetchAttendance();
    }
  }

  @override
  Widget build(BuildContext context) {
    final classVm   = Provider.of<AllClassesViewModel>(context);
    final sectionVm = Provider.of<AllSectionsViewModel>(context);

    return Scaffold(
      backgroundColor: AppColor.screenBg,
      body: Column(
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RoutesName.staffAttendanceScreen);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.lightBlueColor,
                      AppColor.lightBlueColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.cardShadow,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.grid_view_rounded,
                        color: Colors.white, size: 26),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppText.customText(
                        'school_attendance.staff_attendance'.tr(),
                        size: 15,
                        weight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.white, size: 16),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildFilterCard(classVm, sectionVm),
                  const SizedBox(height: 16),
                  Consumer<AllAttendanceViewModel>(
                    builder: (context, vm, _) {
                      if (selectedClass == null || selectedSection == null) {
                        return _emptyPrompt(
                          icon: Icons.filter_list_rounded,
                          title: 'school_attendance.select_class_section'.tr(),
                          subtitle: 'school_attendance.choose_filters'.tr(),
                        );
                      }
                      if (vm.loading) return _shimmerList();
                      if (vm.error != null) return _errorView(vm.error!);
                      if (vm.students.isEmpty) {
                        return _emptyPrompt(
                          icon: Icons.people_outline_rounded,
                          title: 'school_attendance.no_students_found'.tr(),
                          subtitle: 'school_attendance.no_attendance_data'.tr(),
                        );
                      }

                      return Column(
                        children: [
                          _buildStatsRow(vm),
                          const SizedBox(height: 16),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: vm.students.length,
                            itemBuilder: (_, i) =>
                                _studentCard(vm.students[i], i),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 50, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.lightBlueColor,
            AppColor.lightBlueColor.withOpacity(0.85),
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
              color: AppColor.cardShadow,
              blurRadius: 18,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: AppText.customText('school_attendance.title'.tr(),
                size: 20, weight: FontWeight.bold, color: Colors.white),
          ),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded,
                      color: Colors.white, size: 14),
                  const SizedBox(width: 6),
                  AppText.customText(_displayDate,
                      size: 12, weight: FontWeight.w600, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCard(AllClassesViewModel classVm, AllSectionsViewModel sectionVm) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: AppColor.cardShadow,
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColor.lightBlueColor.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(
                bottom: BorderSide(
                    color: AppColor.lightBlueColor.withOpacity(0.15)),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.filter_alt_rounded,
                    color: AppColor.lightBlueColor, size: 18),
                const SizedBox(width: 8),
                AppText.customText('school_attendance.select_filters'.tr(),
                    size: 13,
                    weight: FontWeight.w600,
                    color: AppColor.lightBlueColor),
                const Spacer(),
                if (selectedClass != null)
                  _badge(Icons.check_circle_rounded, 'school_attendance.class'.tr(), true),
                const SizedBox(width: 6),
                if (selectedSection != null)
                  _badge(Icons.check_circle_rounded, 'school_attendance.section'.tr(), true),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _styledDropdown(
                  hint: 'school_attendance.select_class'.tr(),
                  value: selectedClass,
                  icon: Icons.class_rounded,
                  items: classVm.allClassesModel?.data
                      ?.map((item) => DropdownMenuItem<String>(
                    value: item.classId.toString(),
                    child: Text(item.className ?? '',
                        style: const TextStyle(fontSize: 13)),
                  ))
                      .toList() ?? [],
                  onChanged: (value) {
                    setState(() {
                      selectedClass   = value;
                      selectedSection = null;
                    });
                    if (value != null) {
                      Provider.of<AllSectionsViewModel>(context, listen: false)
                          .allSectionsApi(context, value);
                      Provider.of<AllAttendanceViewModel>(context, listen: false)
                          .clear();
                    }
                  },
                ),
                const SizedBox(height: 12),
                _styledDropdown(
                  hint: selectedClass == null
                      ? 'school_attendance.select_class_first'.tr()
                      : 'school_attendance.select_section'.tr(),
                  value: selectedSection,
                  icon: Icons.group_rounded,
                  enabled: selectedClass != null,
                  items: sectionVm.allSectionsModel?.data
                      ?.map((item) => DropdownMenuItem<String>(
                    value: item.sectionId.toString(),
                    child: Text(item.sectionName ?? '',
                        style: const TextStyle(fontSize: 13)),
                  ))
                      .toList() ?? [],
                  onChanged: (value) {
                    setState(() => selectedSection = value);
                    _fetchAttendance();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _styledDropdown({
    required String hint,
    required String? value,
    required IconData icon,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?>? onChanged,
    bool enabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: enabled ? AppColor.pageBgColor : AppColor.pageBgColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: value != null
              ? AppColor.lightBlueColor.withOpacity(0.5)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: enabled ? AppColor.lightBlueColor : AppColor.softGreyText),
          hint: Row(
            children: [
              Icon(icon,
                  size: 16,
                  color: enabled ? AppColor.lightBlueColor : AppColor.softGreyText),
              const SizedBox(width: 8),
              Text(hint,
                  style: TextStyle(
                      color: AppColor.softGreyText, fontSize: 13)),
            ],
          ),
          items: items,
          onChanged: enabled ? onChanged : null,
          selectedItemBuilder: (ctx) => items
              .map((item) => Row(
            children: [
              Icon(icon, size: 16, color: AppColor.lightBlueColor),
              const SizedBox(width: 8),
              Flexible(child: item.child),
            ],
          ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildStatsRow(AllAttendanceViewModel vm) {
    return Row(
      children: [
        _statCard('school_attendance.total'.tr(), vm.totalStudents.toString(),
            Icons.people_rounded, AppColor.lightBlueColor),
        const SizedBox(width: 10),
        _statCard('school_attendance.present'.tr(), vm.presentStudents.length.toString(),
            Icons.check_circle_rounded, Colors.green),
        const SizedBox(width: 10),
        _statCard('school_attendance.absent'.tr(), vm.absentStudents.length.toString(),
            Icons.cancel_rounded, Colors.red),
        const SizedBox(width: 10),
        _statCard('school_attendance.late'.tr(), vm.lateStudents.length.toString(),
            Icons.watch_later_rounded, Colors.orange),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            Text(label,
                style: TextStyle(fontSize: 10, color: color.withOpacity(0.7))),
          ],
        ),
      ),
    );
  }

  Widget _studentCard(student, int index) {
    final status = student.status?.toLowerCase() ?? '';
    final Color statusColor = status == 'present'
        ? Colors.green
        : status == 'absent'
        ? Colors.red
        : status == 'late'
        ? Colors.orange
        : Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColor.cardShadow,
              blurRadius: 8,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AppText.customText(
                student.rollNo ?? '${index + 1}',
                size: 14,
                weight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.customText(
                  student.studentName ?? 'Student ${index + 1}',
                  size: 14,
                  weight: FontWeight.w600,
                ),
                if (student.remarks != null && student.remarks!.isNotEmpty)
                  AppText.customText(
                    student.remarks!,
                    size: 11,
                    color: AppColor.softGreyText,
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: AppText.customText(
              (student.status?.toUpperCase() ?? 'school_attendance.unknown_status'.tr()),
              size: 10,
              weight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(IconData icon, String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: active
            ? AppColor.lightBlueColor.withOpacity(0.12)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 11,
              color: active ? AppColor.lightBlueColor : AppColor.softGreyText),
          const SizedBox(width: 3),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: active
                      ? AppColor.lightBlueColor
                      : AppColor.softGreyText)),
        ],
      ),
    );
  }

  Widget _emptyPrompt({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Icon(icon, size: 72, color: AppColor.lightBlueColor.withOpacity(0.3)),
          const SizedBox(height: 16),
          AppText.customText(title, size: 16, weight: FontWeight.bold),
          const SizedBox(height: 6),
          AppText.customText(subtitle,
              size: 13, color: AppColor.softGreyText),
        ],
      ),
    );
  }

  Widget _errorView(String msg) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 72, color: Colors.red),
          const SizedBox(height: 12),
          AppText.customText('school_attendance.something_went_wrong'.tr(),
              size: 16, weight: FontWeight.bold),
          const SizedBox(height: 6),
          AppText.customText(msg, size: 12, color: AppColor.softGreyText),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _fetchAttendance,
            icon: const Icon(Icons.refresh_rounded),
            label: Text('school_attendance.retry'.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.lightBlueColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 72,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}