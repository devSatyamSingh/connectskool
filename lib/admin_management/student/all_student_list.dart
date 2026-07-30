import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:school_pro/view_model/school_view_model/student/all_student_list_view_model.dart';
import 'package:school_pro/view_model/school_view_model/classes/all_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/student/delete_student_view_model.dart';
import '../../repo/school_repo/section/all_sections_repo.dart';
import '../../res/app_button.dart';
import '../../utils/permission_error_message.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../utils/utils.dart';
import '../../admin_management/student/school_student_detail_screen.dart';
import 'add_student_screen.dart';

class AllStudentList extends StatefulWidget {
  const AllStudentList({super.key});

  @override
  State<AllStudentList> createState() => _AllStudentListState();
}

class _AllStudentListState extends State<AllStudentList>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;

  final _classes = ValueNotifier<List<Map<String, dynamic>>>([]);
  final _sections = ValueNotifier<List<Map<String, dynamic>>>([]);
  final _selectedClassId = ValueNotifier<String>("");
  final _selectedSectionId = ValueNotifier<String>("");
  bool _sectionsLoading = false;

  // ✅ dispose() ke crash ko fix karne ke liye reference yahan save karo
  AllClassesViewModel? _classesVm;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Provider.of<AllStudentListVieModel>(
        context,
        listen: false,
      ).allStudentListApi(context);

      // ✅ reference save kar liya, ab dispose() mein Provider.of call nahi karna padega
      _classesVm = Provider.of<AllClassesViewModel>(context, listen: false);
      _classesVm!.allClassesApi(context);
      _classesVm!.addListener(_onClassesLoaded);
    });
  }

  void _onClassesLoaded() {
    if (!mounted || _classesVm == null) return;
    final data = _classesVm!.allClassesModel?.data ?? [];
    if (data.isNotEmpty && _classes.value.isEmpty) {
      _classes.value = data
          .map(
            (e) => {
              "class_id": e.classId.toString(),
              "class_name": e.className ?? "",
            },
          )
          .toList();
    }
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    // ✅ ab yahan Provider.of(context) call nahi kar rahe — saved reference use kar rahe hain
    _classesVm?.removeListener(_onClassesLoaded);
    _classes.dispose();
    _sections.dispose();
    _selectedClassId.dispose();
    _selectedSectionId.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _animCtrl.reset();
    await Provider.of<AllStudentListVieModel>(
      context,
      listen: false,
    ).allStudentListApi(context);
    _animCtrl.forward();
  }

  void _openAddForm() {
    if (!PermissionGuard.check(
      context,
      PermissionKeys.addStudent,
      "Add Student",
    )) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const StudentFormPage.add()),
    );
  }

  void _openEditForm(Map<String, dynamic> student) {
    if (!PermissionGuard.check(
      context,
      PermissionKeys.editStudent,
      "Edit Student",
    )) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StudentFormPage.edit(student: student)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AllStudentListVieModel>(context);

    // ✅✅ SABSE IMPORTANT FIX: yahan `viewModel.students` use karo,
    // `viewModel.allStudentListModel?.data` NAHI — warna sirf page 1 ke 20 hi dikhenge
    final students = viewModel.students;

    final filtered = students.where((s) {
      final selectedClassName =
          _classes.value.firstWhere(
            (c) =>
                c["class_id"].toString() == _selectedClassId.value.toString(),
            orElse: () => <String, String>{},
          )["class_name"] ??
          "";
      final classMatch =
          _selectedClassId.value.isEmpty ||
          (s.className ?? "") == selectedClassName;

      final selectedSectionName =
          _sections.value.firstWhere(
            (sec) => sec["section_id"].toString() == _selectedSectionId.value,
            orElse: () => <String, dynamic>{},
          )["section_name"] ??
          "";
      final sectionMatch =
          _selectedSectionId.value.isEmpty ||
          (s.sectionName ?? "") == selectedSectionName;

      return classMatch && sectionMatch;
    }).toList();

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColor.pageBgColor,
        floatingActionButton: SizedBox(
          width: 170,
          child: AppButton(
            title: "Add Student",
            icon: Icons.add_rounded,
            height: 50,
            radius: 18,
            onTap: _openAddForm,
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
              decoration: BoxDecoration(
                gradient: AppColor.primaryGradient,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.blueShadow,
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColor.glassWhite,
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
                    child: AppText.customText(
                      "All Students",
                      size: 19,
                      weight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  // ✅ ab yeh count bhi loaded students (jo accumulate ho rahe hain) ka sahi count dikhayega
                  AppText.customText(
                    "${students.length}",
                    size: 16,
                    weight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Expanded(child: _buildClassFilter()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildSectionFilter()),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: viewModel.loading
                  ? _shimmer()
                  : filtered.isEmpty
                  ? _empty()
                  : RefreshIndicator(
                      color: AppColor.lightBlueColor,
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(18, 8, 18, 100),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: filtered.length + 1, // +1 footer
                        itemBuilder: (_, i) {
                          if (i >= filtered.length) {
                            return _footer(viewModel);
                          }
                          final s = filtered[i];
                          final isMale = s.gender?.toLowerCase() == "male";
                          return _animatedCard(
                            i,
                            _studentMap(s, isMale: isMale),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _footer(AllStudentListVieModel viewModel) {
    if (!viewModel.hasMore) {
      return const SizedBox(height: 20);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
      child: AppButton(
        title: "View More",
        icon: Icons.expand_more_rounded,
        height: 48,
        radius: 14,
        loading:
            viewModel.loadingMore, // ✅ AppButton khud hi spinner dikha dega
        onTap: () {
          viewModel.loadMoreStudents(
            context,
            classId: _selectedClassId.value.isEmpty
                ? null
                : _selectedClassId.value,
            sectionId: _selectedSectionId.value.isEmpty
                ? null
                : _selectedSectionId.value,
          );
        },
      ),
    );
  }

  Map<String, dynamic> _studentMap(dynamic s, {required bool isMale}) => {
    "id": s.studentId,
    "name": s.name ?? "",
    "email": s.userEmail ?? "",
    "admission": s.admissionNo ?? "",
    "class": s.className ?? "",
    "section": s.sectionName ?? "",
    "class_id": s.classId?.toString() ?? "",
    "section_id": s.sectionId?.toString() ?? "",
    "gender": s.gender != null
        ? "${s.gender![0].toUpperCase()}${s.gender!.substring(1)}"
        : "Male",
    "roll_no": s.rollNo?.toString() ?? "",
    "dob": s.dob != null
        ? s.dob!.contains("T")
              ? s.dob!.split("T")[0]
              : s.dob!
        : "",
    "mobile_number": s.mobileNumber ?? "",
    "father_name": s.fatherName ?? "",
    "mother_name": s.motherName ?? "",
    "address": s.address ?? "",
    "religion": s.religion ?? "",
    "academic_year": s.academicYear ?? "",
    "passed_out": s.passedOut?.toString() ?? "",
    "transfer": s.transfer?.toString() ?? "",
    "blood_group": s.bloodGroup ?? "",
    "category": s.category ?? "",
    "aadhar_number": s.aadharNumber ?? "",
    "father_occupation": s.fatherOccupation ?? "",
    "father_mobile": s.fatherMobile ?? "",
    "mother_occupation": s.motherOccupation ?? "",
    "mother_mobile": s.motherMobile ?? "",
    "guardian_name": s.guardianName ?? "",
    "emergency_contact_number": s.emergencyContactNumber ?? "",
    "city": s.city ?? "",
    "state": s.state ?? "",
    "pincode": s.pincode ?? "",
    "selected_fee_heads": "",
    "student_photo_url": s.studentPhotoUrl ?? "",
    "aadhar_card_url": s.aadharCardUrl ?? "",
    "father_photo_url": s.fatherPhotoUrl ?? "",
    "mother_photo_url": s.motherPhotoUrl ?? "",
    "color": isMale ? AppColor.maleColor : AppColor.femaleColor,
    "gradient": isMale
        ? [AppColor.maleColor, AppColor.maleLight]
        : [AppColor.femaleColor, AppColor.femaleLight],
  };

  Widget _animatedCard(int index, Map<String, dynamic> data) => AnimatedBuilder(
    animation: _animCtrl,
    builder: (_, child) {
      final delay = (index * 0.08).clamp(0.0, 0.9);
      final val = Curves.easeOut.transform(
        (_animCtrl.value - delay).clamp(0.0, 1.0) / (1 - delay),
      );
      return Transform.translate(
        offset: Offset(0, 25 * (1 - val)),
        child: Opacity(opacity: val, child: child),
      );
    },
    child: _studentCard(data),
  );

  Widget _studentCard(Map<String, dynamic> s) {
    final w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (!PermissionExtensions.canAccess(
          PermissionKeys.viewOneStudentProfile,
        )) {
          Utils.show("You don't have permission", context);
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SchoolStudentDetailScreen(
              studentId: s["id"],
              className: s["class"],
              sectionName: s["section"],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColor.cardWhite,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColor.cardShadow,
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(w * 0.015),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: s["gradient"]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              SizedBox(width: w * 0.035),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.customText(
                      s["name"],
                      size: 17,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 6),
                    AppText.customText(
                      s["email"],
                      size: 13,
                      color: AppColor.softGreyText,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        AppText.customText(
                          "Adm: ${s["admission"]}",
                          size: 11,
                          color: AppColor.softGreyText,
                        ),
                        SizedBox(width: w * 0.01),
                        AppText.customText(
                          s["gender"],
                          size: 11,
                          color: AppColor.softGreyText,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    AppText.customText(
                      s["class"],
                      size: 13,
                      color: AppColor.lightBlueColor,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () => _openEditForm(s),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColor.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.edit_note_rounded,
                        color: AppColor.lightBlueColor,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () async {
                      if (!PermissionGuard.check(
                        context,
                        PermissionKeys.deleteStudent,
                        "Delete Student",
                      )) {
                        return;
                      }
                      final confirmed = await _showDeleteDialog();
                      if (confirmed && context.mounted) {
                        Provider.of<DeleteStudentViewModel>(
                          context,
                          listen: false,
                        ).deleteStudentApi(s["id"], context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColor.error.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: AppColor.error,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassFilter() =>
      ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: _classes,
        builder: (_, list, __) => ValueListenableBuilder<String>(
          valueListenable: _selectedClassId,
          builder: (_, val, __) => _filterDropdown(
            label: "Class",
            value: val.isEmpty ? null : val,
            items: list
                .map(
                  (e) => DropdownMenuItem<String>(
                    value: e["class_id"],
                    child: Text(e["class_name"]),
                  ),
                )
                .toList(),
            onChanged: (v) async {
              _selectedClassId.value = v ?? "";
              _selectedSectionId.value = "";
              _sections.value = [];

              final vm = Provider.of<AllStudentListVieModel>(
                context,
                listen: false,
              );

              if (v != null) {
                setState(() => _sectionsLoading = true);
                final resp = await AllSectionsRepository().allSectionsApi(v);
                setState(() => _sectionsLoading = false);
                if (resp["success"] == true) {
                  _sections.value = List<Map<String, dynamic>>.from(
                    resp["data"],
                  );
                }

                // ✅ server se class ke hisaab se students refetch karo
                await vm.allStudentListApi(context, classId: v);
              } else {
                // ✅ class clear ki to poori list wapas load karo
                await vm.allStudentListApi(context);
              }

              setState(() {});
            },
          ),
        ),
      );

  Widget _buildSectionFilter() =>
      ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: _sections,
        builder: (_, list, __) => ValueListenableBuilder<String>(
          valueListenable: _selectedSectionId,
          builder: (_, val, __) {
            if (_sectionsLoading) {
              return _loadingDropdownPlaceholder();
            }
            final classSelected = _selectedClassId.value.isNotEmpty;
            if (classSelected && list.isEmpty) {
              return _noSectionFilterPlaceholder();
            }
            return _filterDropdown(
              label: "Section",
              value: val.isEmpty ? null : val,
              items: list
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e["section_id"].toString(),
                      child: Text(e["section_name"]),
                    ),
                  )
                  .toList(),
              onChanged: (v) async {
                setState(() => _selectedSectionId.value = v ?? "");

                final vm = Provider.of<AllStudentListVieModel>(
                  context,
                  listen: false,
                );

                // ✅ server se class + section dono ke hisaab se refetch karo
                await vm.allStudentListApi(
                  context,
                  classId: _selectedClassId.value.isEmpty
                      ? null
                      : _selectedClassId.value,
                  sectionId: v,
                );
              },
            );
          },
        ),
      );

  Widget _filterDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: AppColor.cardShadow,
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        dropdownColor: Colors.white,
        isExpanded: true,
        hint: Text(label, style: const TextStyle(fontSize: 13)),
        value: value,
        items: items,
        onChanged: onChanged,
      ),
    ),
  );

  Widget _loadingDropdownPlaceholder() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColor.lightBlueColor,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          "Loading...",
          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        ),
      ],
    ),
  );

  Widget _noSectionFilterPlaceholder() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    decoration: BoxDecoration(
      color: Colors.orange.shade50,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.orange.shade200),
    ),
    child: Row(
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 18,
          color: Colors.orange.shade400,
        ),
        const SizedBox(width: 8),
        Text(
          "No Section",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.orange.shade700,
          ),
        ),
      ],
    ),
  );

  Widget _empty() => RefreshIndicator(
    color: AppColor.lightBlueColor,
    onRefresh: _onRefresh,
    child: ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.school_outlined,
                size: 80,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                "No Students Found",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Pull down to refresh",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _shimmer() => ListView.builder(
    padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
    itemCount: 6,
    itemBuilder: (_, __) => Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 110,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColor.cardWhite,
          borderRadius: BorderRadius.circular(22),
        ),
      ),
    ),
  );

  Future<bool> _showDeleteDialog() async =>
      await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 35,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Delete Student",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Are you sure you want to delete this student?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ) ??
      false;
}
