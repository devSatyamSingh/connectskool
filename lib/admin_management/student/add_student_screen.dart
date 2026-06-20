import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/repo/school_repo/section/all_sections_repo.dart';
import 'package:school_pro/res/app_button.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:school_pro/utils/utils.dart';
import 'package:school_pro/view_model/auth_view_model/academic_view_model.dart';
import 'package:school_pro/view_model/school_view_model/student/add_student_view_model.dart';
import 'package:school_pro/view_model/school_view_model/classes/all_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/student/all_student_list_view_model.dart';
import 'package:school_pro/view_model/school_view_model/fees/fees_head_management_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../utils/permission_error_message.dart';
import '../../utils/permission_keys.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final ImagePicker _picker = ImagePicker();

  // ── Controllers ──
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final admissionCtrl = TextEditingController();
  final rollNoCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final fatherNameCtrl = TextEditingController();
  final motherNameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final religionCtrl = TextEditingController();
  final passedOutCtrl = TextEditingController();
  final transferCtrl = TextEditingController();
  final aadharNumberCtrl = TextEditingController();
  final fatherOccupationCtrl = TextEditingController();
  final fatherMobileCtrl = TextEditingController();
  final motherOccupationCtrl = TextEditingController();
  final motherMobileCtrl = TextEditingController();
  final guardianNameCtrl = TextEditingController();
  final emergencyContactCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final pincodeCtrl = TextEditingController();

  // ── ValueNotifiers ──
  final _classes = ValueNotifier<List<Map<String, dynamic>>>([]);
  final _sections = ValueNotifier<List<Map<String, dynamic>>>([]);
  final _classId = ValueNotifier<String>("");
  final _sectionId = ValueNotifier<String>("");
  final _gender = ValueNotifier<String>("Male");
  final _bloodGroup = ValueNotifier<String>("");
  final _category = ValueNotifier<String>("");
  final _academicYear = ValueNotifier<String>("");
  final _passwordVisible = ValueNotifier<bool>(false);
  final _studentPhoto = ValueNotifier<File?>(null);
  final _aadharCard = ValueNotifier<File?>(null);
  final _fatherPhoto = ValueNotifier<File?>(null);
  final _motherPhoto = ValueNotifier<File?>(null);
  List<String> _selectedFeeHeads = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AcademicViewModel>(
        context,
        listen: false,
      ).academicApi(context);
      Provider.of<FeesHeadManagementViewModel>(
        context,
        listen: false,
      ).feesHeadManagementApi(context);

      final classesVm = Provider.of<AllClassesViewModel>(
        context,
        listen: false,
      );
      classesVm.allClassesApi(context);

      classesVm.addListener(() {
        final data = classesVm.allClassesModel?.data ?? [];
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
      });
    });
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    admissionCtrl.dispose();
    rollNoCtrl.dispose();
    dobCtrl.dispose();
    mobileCtrl.dispose();
    fatherNameCtrl.dispose();
    motherNameCtrl.dispose();
    addressCtrl.dispose();
    religionCtrl.dispose();
    passedOutCtrl.dispose();
    transferCtrl.dispose();
    aadharNumberCtrl.dispose();
    fatherOccupationCtrl.dispose();
    fatherMobileCtrl.dispose();
    motherOccupationCtrl.dispose();
    motherMobileCtrl.dispose();
    guardianNameCtrl.dispose();
    emergencyContactCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    pincodeCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ValueNotifier<File?> notifier) async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source != null) {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) notifier.value = File(image.path);
    }
  }

  Future<void> _submit() async {
    if (!PermissionGuard.check(
      context,
      PermissionKeys.addStudent,
      "Add Student",
    )) {
      return;
    }
    if (nameCtrl.text.trim().isEmpty) {
      Utils.show("Enter student name", context);
      return;
    }
    if (emailCtrl.text.trim().isEmpty) {
      Utils.show("Enter email", context);
      return;
    }
    if (passwordCtrl.text.trim().isEmpty) {
      Utils.show("Enter password", context);
      return;
    }
    if (_classId.value.isEmpty) {
      Utils.show("Select class", context);
      return;
    }
    if (dobCtrl.text.trim().isEmpty) {
      Utils.show("Select DOB", context);
      return;
    }
    if (mobileCtrl.text.trim().isEmpty) {
      Utils.show("Enter mobile number", context);
      return;
    }
    if (mobileCtrl.text.trim().length < 10) {
      Utils.show("Enter valid 10-digit mobile number", context);
      return;
    }
    if (fatherNameCtrl.text.trim().isEmpty) {
      Utils.show("Enter father name", context);
      return;
    }
    if (motherNameCtrl.text.trim().isEmpty) {
      Utils.show("Enter mother name", context);
      return;
    }
    final success =
        await Provider.of<AddStudentViewModel>(
          context,
          listen: false,
        ).addStudentApi(
          name: nameCtrl.text.trim(),
          email: emailCtrl.text.trim(),
          password: passwordCtrl.text.trim(),
          class_id: _classId.value,
          section_id: _sectionId.value,
          admission_no: admissionCtrl.text.trim(),
          gender: _gender.value,
          academic_year: _academicYear.value,
          roll_no: rollNoCtrl.text.trim(),
          dob: dobCtrl.text.trim(),
          mobile_number: mobileCtrl.text.trim(),
          father_name: fatherNameCtrl.text.trim(),
          mother_name: motherNameCtrl.text.trim(),
          address: addressCtrl.text.trim(),
          religion: religionCtrl.text.trim(),
          selected_fee_heads: _selectedFeeHeads.join(','),
          student_photo: _studentPhoto.value,
          aadharCard: _aadharCard.value,
          father_photo: _fatherPhoto.value,
          mother_photo: _motherPhoto.value,
          passed_out: passedOutCtrl.text.trim(),
          transfer: transferCtrl.text.trim(),
          blood_group: _bloodGroup.value,
          category: _category.value,
          aadhar_number: aadharNumberCtrl.text.trim(),
          father_occupation: fatherOccupationCtrl.text.trim(),
          father_mobile: fatherMobileCtrl.text.trim(),
          mother_occupation: motherOccupationCtrl.text.trim(),
          mother_mobile: motherMobileCtrl.text.trim(),
          guardian_name: guardianNameCtrl.text.trim(),
          emergency_contact_number: emergencyContactCtrl.text.trim(),
          city: cityCtrl.text.trim(),
          state: stateCtrl.text.trim(),
          pincode: pincodeCtrl.text.trim(),
          context: context,
        );

    if (success && context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBgColor,
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
                AppText.customText(
                  "Add Student",
                  size: 19,
                  weight: FontWeight.bold,
                  color: Colors.white,
                ),
              ],
            ),
          ),

          // ── Body ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Basic Info ──
                  _sectionHeader("Basic Information"),
                  const SizedBox(height: 12),
                  _buildTextField(nameCtrl, "Full Name", Icons.person),
                  const SizedBox(height: 12),
                  _buildTextField(emailCtrl, "Email", Icons.email),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<bool>(
                    valueListenable: _passwordVisible,
                    builder: (_, isVisible, __) => TextField(
                      controller: passwordCtrl,
                      obscureText: !isVisible,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: AppColor.lightBlueColor,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isVisible ? Icons.visibility : Icons.visibility_off,
                            color: AppColor.lightBlueColor,
                          ),
                          onPressed: () =>
                              _passwordVisible.value = !_passwordVisible.value,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColor.lightBlueColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder<String>(
                    valueListenable: _gender,
                    builder: (_, val, __) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Gender",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: _genderCard(
                                  title: "Male",
                                  icon: Icons.male_rounded,
                                  color: AppColor.maleColor,
                                  selected: val == "Male",
                                  onTap: () => _gender.value = "Male",
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: _genderCard(
                                  title: "Female",
                                  icon: Icons.female_rounded,
                                  color: AppColor.femaleColor,
                                  selected: val == "Female",
                                  onTap: () => _gender.value = "Female",
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: _genderCard(
                                  title: "Other",
                                  icon: Icons.transgender_rounded,
                                  color: Colors.purple,
                                  selected: val == "Other",
                                  onTap: () => _gender.value = "Other",
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _sectionHeader("Academic Information"),
                  const SizedBox(height: 12),
                  Consumer<AcademicViewModel>(
                    builder: (context, vm, _) {
                      if (vm.loading) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }
                      final years = vm.years;
                      if (_academicYear.value.isEmpty &&
                          vm.currentYear != null) {
                        Future.microtask(
                          () => _academicYear.value =
                              vm.currentYear!.yearName ?? "",
                        );
                      }
                      return ValueListenableBuilder<String>(
                        valueListenable: _academicYear,
                        builder: (_, val, __) => _dropdownContainer(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: AppColor.lightBlueColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                const Text("Academic Year"),
                              ],
                            ),
                            value: val.isEmpty ? null : val,
                            items: years
                                .map(
                                  (y) => DropdownMenuItem<String>(
                                    value: y.yearName,
                                    child: Row(
                                      children: [
                                        Text(y.yearName ?? ""),
                                        if (y.isCurrent == 1) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              "Current",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.green.shade700,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _academicYear.value = v ?? ""),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    rollNoCtrl,
                    "Roll No.",
                    Icons.format_list_numbered,
                  ),
                  const SizedBox(height: 12),

                  // Class Dropdown
                  ValueListenableBuilder<List<Map<String, dynamic>>>(
                    valueListenable: _classes,
                    builder: (_, list, __) => ValueListenableBuilder<String>(
                      valueListenable: _classId,
                      builder: (_, cVal, __) => _dropdownContainer(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Row(
                            children: [
                              Icon(
                                Icons.class_,
                                color: AppColor.lightBlueColor,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              const Text("Class"),
                            ],
                          ),
                          value: cVal.isEmpty ? null : cVal,
                          items: list
                              .map(
                                (e) => DropdownMenuItem<String>(
                                  value: e["class_id"],
                                  child: Text(e["class_name"]),
                                ),
                              )
                              .toList(),
                          onChanged: (val) async {
                            if (val == null) return;
                            setState(() {
                              _classId.value = val;
                              _sectionId.value = "";
                              _sections.value = [];
                            });
                            final repo = AllSectionsRepository();
                            final response = await repo.allSectionsApi(val);
                            if (response["success"] == true) {
                              setState(() {
                                _sections.value =
                                    List<Map<String, dynamic>>.from(
                                      response["data"],
                                    );
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Section Dropdown
                  ValueListenableBuilder<List<Map<String, dynamic>>>(
                    valueListenable: _sections,
                    builder: (_, list, __) {
                      final classSelected = _classId.value.isNotEmpty;
                      final noSections = classSelected && list.isEmpty;
                      if (noSections) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 20,
                                color: Colors.orange.shade400,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "No Section available for this class",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return ValueListenableBuilder<String>(
                        valueListenable: _sectionId,
                        builder: (_, sVal, __) => _dropdownContainer(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: Row(
                              children: [
                                Icon(
                                  Icons.grid_view_rounded,
                                  color: AppColor.lightBlueColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                const Text("Section"),
                              ],
                            ),
                            value: sVal.isEmpty ? null : sVal,
                            items: list
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e["section_id"].toString(),
                                    child: Text(e["section_name"]),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _sectionId.value = val ?? ""),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // ── Personal Info ──
                  _sectionHeader("Personal Information"),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(
                          () => dobCtrl.text =
                              "${picked.day}/${picked.month}/${picked.year}",
                        );
                      }
                    },
                    child: AbsorbPointer(
                      child: _buildTextField(
                        dobCtrl,
                        "Date of Birth (DD/MM/YYYY)",
                        Icons.cake,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    mobileCtrl,
                    "Mobile Number",
                    Icons.phone,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(religionCtrl, "Religion", Icons.temple_hindu),

                  const SizedBox(height: 24),

                  // ── Parent Info ──
                  _sectionHeader("Parent Information"),
                  const SizedBox(height: 12),
                  _buildTextField(
                    fatherNameCtrl,
                    "Father's Name",
                    Icons.person,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    motherNameCtrl,
                    "Mother's Name",
                    Icons.person,
                  ),

                  const SizedBox(height: 24),

                  // ── Additional Info ──
                  _sectionHeader("Additional Information"),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<String>(
                    valueListenable: _bloodGroup,
                    builder: (_, val, __) => _dropdownContainer(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Row(
                          children: [
                            Icon(
                              Icons.bloodtype,
                              color: AppColor.lightBlueColor,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            const Text("Blood Group"),
                          ],
                        ),
                        value: val.isEmpty ? null : val,
                        items:
                            ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
                                .map(
                                  (g) => DropdownMenuItem(
                                    value: g,
                                    child: Text(g),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) =>
                            setState(() => _bloodGroup.value = v ?? ""),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<String>(
                    valueListenable: _category,
                    builder: (_, val, __) => _dropdownContainer(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Row(
                          children: [
                            Icon(
                              Icons.category,
                              color: AppColor.lightBlueColor,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            const Text("Category"),
                          ],
                        ),
                        value: val.isEmpty ? null : val,
                        items: ["General", "OBC", "SC", "ST", "EWS", "Other"]
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _category.value = v ?? ""),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    aadharNumberCtrl,
                    "Aadhar Number",
                    Icons.credit_card,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 24),

                  // ── Parent Extra Details ──
                  _sectionHeader("Parent Extra Details"),
                  const SizedBox(height: 12),
                  _buildTextField(
                    fatherOccupationCtrl,
                    "Father's Occupation",
                    Icons.work,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    fatherMobileCtrl,
                    "Father's Mobile",
                    Icons.phone,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    motherOccupationCtrl,
                    "Mother's Occupation",
                    Icons.work,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    motherMobileCtrl,
                    "Mother's Mobile",
                    Icons.phone,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    guardianNameCtrl,
                    "Guardian Name",
                    Icons.person,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    emergencyContactCtrl,
                    "Emergency Contact",
                    Icons.emergency,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                  ),

                  const SizedBox(height: 24),

                  // ── Address ──
                  _sectionHeader("Address Details"),
                  const SizedBox(height: 12),
                  _buildTextField(
                    addressCtrl,
                    "Address",
                    Icons.home,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(cityCtrl, "City", Icons.location_city),
                  const SizedBox(height: 12),
                  _buildTextField(stateCtrl, "State", Icons.map),
                  const SizedBox(height: 12),
                  _buildTextField(
                    pincodeCtrl,
                    "Pincode",
                    Icons.pin_drop,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 24),

                  // ── Documents ──
                  _sectionHeader("Upload Documents"),
                  const SizedBox(height: 12),
                  _buildImagePicker(
                    label: "Student Photo",
                    icon: Icons.portrait,
                    notifier: _studentPhoto,
                  ),
                  const SizedBox(height: 12),
                  _buildImagePicker(
                    label: "Aadhar Card",
                    icon: Icons.credit_card,
                    notifier: _aadharCard,
                  ),
                  const SizedBox(height: 12),
                  _buildImagePicker(
                    label: "Father's Photo",
                    icon: Icons.person,
                    notifier: _fatherPhoto,
                  ),
                  const SizedBox(height: 12),
                  _buildImagePicker(
                    label: "Mother's Photo",
                    icon: Icons.person,
                    notifier: _motherPhoto,
                  ),
                  const SizedBox(height: 24),
                  _sectionHeader("Fee Heads"),
                  const SizedBox(height: 12),
                  Consumer<FeesHeadManagementViewModel>(
                    builder: (context, vm, child) {
                      if (vm.loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final feeHeads =
                          vm.feesHeadManagementModel?.data?.feeHeads ?? [];

                      return Column(
                        children: feeHeads.map((fee) {
                          final feeIdStr = fee.feeHeadId.toString();
                          final isSelected =
                          _selectedFeeHeads.contains(feeIdStr);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedFeeHeads.remove(feeIdStr);
                                } else {
                                  _selectedFeeHeads.add(feeIdStr);
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColor.lightBlueColor.withOpacity(0.08)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColor.lightBlueColor
                                      : Colors.grey.shade200,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isSelected
                                        ? AppColor.lightBlueColor.withOpacity(0.10)
                                        : Colors.black.withOpacity(0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    height: 42,
                                    width: 42,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColor.lightBlueColor
                                          : AppColor.lightBlueColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.account_balance_wallet_rounded,
                                      color: isSelected
                                          ? Colors.white
                                          : AppColor.lightBlueColor,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          fee.headName ?? "",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: isSelected
                                                ? AppColor.lightBlueColor
                                                : Colors.black87,
                                          ),
                                        ),

                                        const SizedBox(height: 2),

                                        Text(
                                          "Fee Head",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    height: 28,
                                    width: 28,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? AppColor.lightBlueColor
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColor.lightBlueColor
                                            : Colors.grey.shade400,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    title: "Add Student",
                    onTap: _submit,
                    height: 52,
                    radius: 16,
                    gradient: AppColor.primaryGradient,
                    textColor: Colors.white,
                    icon: Icons.add_rounded,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────

  Widget _sectionHeader(String title) => Text(
    title,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: AppColor.lightBlueColor,
    ),
  );

  Widget _dropdownContainer({required Widget child}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: DropdownButtonHideUnderline(child: child),
  );

  Widget _buildTextField(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    bool isPassword = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
  }) {
    return TextField(
      controller: ctrl,
      obscureText: isPassword,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: maxLength != null
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(maxLength),
            ]
          : null,
      maxLength: maxLength,
      buildCounter: maxLength != null
          ? (
              context, {
              required currentLength,
              required isFocused,
              maxLength,
            }) => Text(
              "$currentLength/$maxLength",
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            )
          : null,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColor.lightBlueColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.lightBlueColor, width: 2),
        ),
      ),
    );
  }

  Widget _genderCard({
    required String title,
    required IconData icon,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? color.withOpacity(0.12)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? color
                : Colors.grey.shade200,
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? color.withOpacity(0.15)
                  : Colors.black.withOpacity(0.03),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected
                    ? color
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker({
    required String label,
    required IconData icon,
    required ValueNotifier<File?> notifier,
  }) {
    return ValueListenableBuilder<File?>(
      valueListenable: notifier,
      builder: (context, file, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _pickImage(notifier),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: file != null
                      ? Colors.green.shade300
                      : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(icon, color: AppColor.lightBlueColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      file != null ? "$label Selected ✓" : "Upload $label",
                      style: TextStyle(
                        color: file != null ? Colors.green : Colors.grey,
                        fontWeight: file != null
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  Icon(
                    file != null ? Icons.check_circle : Icons.upload_file,
                    color: file != null ? Colors.green : Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          if (file != null) ...[
            const SizedBox(height: 8),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    file,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: () => notifier.value = null,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
