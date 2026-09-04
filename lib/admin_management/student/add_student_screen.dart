import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../res/app_button.dart';
import '../../../res/app_color.dart';
import '../../../res/const_text.dart';
import '../../../utils/utils.dart';
import '../../../view_model/auth_view_model/academic_view_model.dart';
import '../../../view_model/school_view_model/classes/all_classes_view_model.dart';
import '../../../view_model/school_view_model/fees/fees_head_management_view_model.dart';
import '../../../repo/school_repo/section/all_sections_repo.dart';
import '../../model/school_model/student/student_form_model.dart';
import '../../view_model/school_view_model/student/add_student_view_model.dart';
import '../../view_model/school_view_model/student/edit_student_view_model.dart';

class StudentFormPage extends StatefulWidget {
  final Map<String, dynamic>? existingStudent;

  const StudentFormPage({super.key, this.existingStudent});

  const StudentFormPage.add({super.key}) : existingStudent = null;

  const StudentFormPage.edit({super.key, required Map<String, dynamic> student})
      : existingStudent = student;

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  // ── Helpers ──────────────────────────────────────────────
  bool get _isEdit => widget.existingStudent != null;
  Map<String, dynamic>? get _s => widget.existingStudent;

  String _prefill(String key, {String fallback = ''}) =>
      _s?[key]?.toString() ?? fallback;

  final ImagePicker _picker = ImagePicker();

  // ── Text Controllers ──────────────────────────────────────
  late final TextEditingController nameCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController passwordCtrl;
  late final TextEditingController admissionCtrl;
  late final TextEditingController rollNoCtrl;
  late final TextEditingController dobCtrl;
  late final TextEditingController mobileCtrl;
  late final TextEditingController fatherNameCtrl;
  late final TextEditingController motherNameCtrl;
  late final TextEditingController addressCtrl;
  late final TextEditingController religionCtrl;
  late final TextEditingController passedOutCtrl;
  late final TextEditingController transferCtrl;
  late final TextEditingController aadharNumberCtrl;
  late final TextEditingController fatherOccupationCtrl;
  late final TextEditingController fatherMobileCtrl;
  late final TextEditingController motherOccupationCtrl;
  late final TextEditingController motherMobileCtrl;
  late final TextEditingController guardianNameCtrl;
  late final TextEditingController emergencyContactCtrl;
  late final TextEditingController cityCtrl;
  late final TextEditingController stateCtrl;
  late final TextEditingController pincodeCtrl;

  // ── ValueNotifiers ────────────────────────────────────────
  final _classes = ValueNotifier<List<Map<String, dynamic>>>([]);
  final _sections = ValueNotifier<List<Map<String, dynamic>>>([]);
  late final ValueNotifier<String> _classId;
  late final ValueNotifier<String> _sectionId;
  late final ValueNotifier<String> _gender;
  late final ValueNotifier<String> _bloodGroup;
  late final ValueNotifier<String> _category;
  late final ValueNotifier<String> _academicYear;
  final _passwordVisible = ValueNotifier<bool>(false);
  final _showChangePassword = ValueNotifier<bool>(false);

  // ── Image files ───────────────────────────────────────────
  final _studentPhoto = ValueNotifier<File?>(null);
  final _aadharCard = ValueNotifier<File?>(null);
  final _fatherPhoto = ValueNotifier<File?>(null);
  final _motherPhoto = ValueNotifier<File?>(null);

  // ── Fee heads (Add only) ──────────────────────────────────
  List<String> _selectedFeeHeads = [];

  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController(text: _prefill("name"));
    emailCtrl = TextEditingController(text: _prefill("email"));
    passwordCtrl = TextEditingController();
    admissionCtrl = TextEditingController(text: _prefill("admission"));
    rollNoCtrl = TextEditingController(text: _prefill("roll_no"));
    dobCtrl = TextEditingController(text: _prefill("dob"));
    mobileCtrl = TextEditingController(text: _prefill("mobile_number"));
    fatherNameCtrl = TextEditingController(text: _prefill("father_name"));
    motherNameCtrl = TextEditingController(text: _prefill("mother_name"));
    addressCtrl = TextEditingController(text: _prefill("address"));
    religionCtrl = TextEditingController(text: _prefill("religion"));
    passedOutCtrl = TextEditingController(text: _prefill("passed_out"));
    transferCtrl = TextEditingController(text: _prefill("transfer"));
    aadharNumberCtrl = TextEditingController(text: _prefill("aadhar_number"));
    fatherOccupationCtrl = TextEditingController(text: _prefill("father_occupation"));
    fatherMobileCtrl = TextEditingController(text: _prefill("father_mobile"));
    motherOccupationCtrl = TextEditingController(text: _prefill("mother_occupation"));
    motherMobileCtrl = TextEditingController(text: _prefill("mother_mobile"));
    guardianNameCtrl = TextEditingController(text: _prefill("guardian_name"));
    emergencyContactCtrl = TextEditingController(text: _prefill("emergency_contact_number"));
    cityCtrl = TextEditingController(text: _prefill("city"));
    stateCtrl = TextEditingController(text: _prefill("state"));
    pincodeCtrl = TextEditingController(text: _prefill("pincode"));

    _classId = ValueNotifier<String>(_prefill("class_id"));
    _sectionId = ValueNotifier<String>(_prefill("section_id"));
    _gender = ValueNotifier<String>(_prefill("gender", fallback: "Male"));
    _bloodGroup = ValueNotifier<String>(_prefill("blood_group"));
    _category = ValueNotifier<String>(_prefill("category"));
    _academicYear = ValueNotifier<String>(_prefill("academic_year"));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initDropdowns();
    });
  }

  Future<void> _initDropdowns() async {
    Provider.of<AcademicViewModel>(context, listen: false)
        .academicApi(context);
    Provider.of<FeesHeadManagementViewModel>(context, listen: false)
        .feesHeadManagementApi(context);

    final classesVm =
    Provider.of<AllClassesViewModel>(context, listen: false);
    classesVm.allClassesApi(context);
    classesVm.addListener(_onClassesLoaded);

    if (_isEdit && _classId.value.isNotEmpty) {
      final repo = AllSectionsRepository();
      final resp = await repo.allSectionsApi(_classId.value);
      if (resp["success"] == true && mounted) {
        _sections.value =
        List<Map<String, dynamic>>.from(resp["data"]);
      }
    }
  }

  void _onClassesLoaded() {
    final vm = Provider.of<AllClassesViewModel>(context, listen: false);
    final data = vm.allClassesModel?.data ?? [];
    if (data.isNotEmpty && _classes.value.isEmpty) {
      _classes.value = data
          .map((e) => {
        "class_id": e.classId.toString(),
        "class_name": e.className ?? "",
      })
          .toList();
    }
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
    _classes.dispose();
    _sections.dispose();
    _classId.dispose();
    _sectionId.dispose();
    _gender.dispose();
    _bloodGroup.dispose();
    _category.dispose();
    _academicYear.dispose();
    _passwordVisible.dispose();
    _showChangePassword.dispose();
    _studentPhoto.dispose();
    _aadharCard.dispose();
    _fatherPhoto.dispose();
    _motherPhoto.dispose();
    Provider.of<AllClassesViewModel>(context, listen: false)
        .removeListener(_onClassesLoaded);
    super.dispose();
  }

  // ── Image picker ──────────────────────────────────────────
  Future<void> _pickImage(ValueNotifier<File?> notifier) async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('student_form.select_image_source'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: Text('student_form.camera'.tr()),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading:
              const Icon(Icons.photo_library, color: Colors.green),
              title: Text('student_form.gallery'.tr()),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final img = await _picker.pickImage(
      source: source,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 85,
    );
    if (img != null) notifier.value = File(img.path);
  }

  // ── Validation ────────────────────────────────────────────
  bool _validate() {
    if (nameCtrl.text.trim().isEmpty) {
      Utils.show('student_form.errors.enter_name'.tr(), context);
      return false;
    }
    if (emailCtrl.text.trim().isEmpty) {
      Utils.show('student_form.errors.enter_email'.tr(), context);
      return false;
    }
    if (!_isEdit && passwordCtrl.text.trim().isEmpty) {
      Utils.show('student_form.errors.enter_password'.tr(), context);
      return false;
    }
    if (_classId.value.isEmpty) {
      Utils.show('student_form.errors.select_class'.tr(), context);
      return false;
    }
    if (dobCtrl.text.trim().isEmpty) {
      Utils.show('student_form.errors.select_dob'.tr(), context);
      return false;
    }
    if (mobileCtrl.text.trim().isEmpty) {
      Utils.show('student_form.errors.enter_mobile'.tr(), context);
      return false;
    }
    if (mobileCtrl.text.trim().length < 10) {
      Utils.show('student_form.errors.valid_mobile'.tr(), context);
      return false;
    }
    if (fatherNameCtrl.text.trim().isEmpty) {
      Utils.show('student_form.errors.enter_father_name'.tr(), context);
      return false;
    }
    if (motherNameCtrl.text.trim().isEmpty) {
      Utils.show('student_form.errors.enter_mother_name'.tr(), context);
      return false;
    }
    return true;
  }

  // ── Build StudentFormModel from current state ─────────────
  StudentFormModel _buildFormModel() => StudentFormModel(
    name: nameCtrl.text.trim(),
    email: emailCtrl.text.trim(),
    password: passwordCtrl.text.trim(),
    classId: _classId.value,
    sectionId: _sectionId.value,
    admissionNo: admissionCtrl.text.trim(),
    gender: _gender.value,
    academicYear: _academicYear.value,
    rollNo: rollNoCtrl.text.trim(),
    dob: dobCtrl.text.trim(),
    mobileNumber: mobileCtrl.text.trim(),
    fatherName: fatherNameCtrl.text.trim(),
    motherName: motherNameCtrl.text.trim(),
    address: addressCtrl.text.trim(),
    religion: religionCtrl.text.trim(),
    passedOut: passedOutCtrl.text.trim(),
    transfer: transferCtrl.text.trim(),
    bloodGroup: _bloodGroup.value,
    category: _category.value,
    aadharNumber: aadharNumberCtrl.text.trim(),
    fatherOccupation: fatherOccupationCtrl.text.trim(),
    fatherMobile: fatherMobileCtrl.text.trim(),
    motherOccupation: motherOccupationCtrl.text.trim(),
    motherMobile: motherMobileCtrl.text.trim(),
    guardianName: guardianNameCtrl.text.trim(),
    emergencyContactNumber: emergencyContactCtrl.text.trim(),
    city: cityCtrl.text.trim(),
    state: stateCtrl.text.trim(),
    pincode: pincodeCtrl.text.trim(),
    selectedFeeHeadIds: _selectedFeeHeads,
    studentPhoto: _studentPhoto.value,
    aadharCard: _aadharCard.value,
    fatherPhoto: _fatherPhoto.value,
    motherPhoto: _motherPhoto.value,
  );

  // ── Submit ────────────────────────────────────────────────
  Future<void> _submit() async {
    if (!_validate()) return;

    final form = _buildFormModel();
    bool success;

    if (_isEdit) {
      success = await Provider.of<EditStudentViewModel>(
        context,
        listen: false,
      ).editStudent(
        context: context,
        studentId: _s!["id"].toString(),
        form: form,
      );
    } else {
      success = await Provider.of<AddStudentViewModel>(
        context,
        listen: false,
      ).addStudent(
        context: context,
        form: form,
      );
    }

    if (success && mounted) Navigator.pop(context);
  }

  // ─────────────────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBgColor,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader('student_form.basic_information'.tr()),
                  const SizedBox(height: 12),
                  _field(nameCtrl, 'student_form.full_name'.tr(), Icons.person),
                  const SizedBox(height: 12),
                  _field(emailCtrl, 'student_form.email'.tr(), Icons.email,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 12),
                  _buildPasswordSection(),
                  const SizedBox(height: 16),
                  _buildGenderPicker(),
                  const SizedBox(height: 24),

                  _sectionHeader('student_form.academic_information'.tr()),
                  const SizedBox(height: 12),
                  _buildAcademicYearDropdown(),
                  const SizedBox(height: 12),
                  _field(admissionCtrl, 'student_form.admission_no'.tr(),
                      Icons.confirmation_number),
                  const SizedBox(height: 12),
                  _field(rollNoCtrl, 'student_form.roll_no'.tr(),
                      Icons.format_list_numbered),
                  const SizedBox(height: 12),
                  _buildClassDropdown(),
                  const SizedBox(height: 12),
                  _buildSectionDropdown(),
                  const SizedBox(height: 24),

                  _sectionHeader('student_form.personal_information'.tr()),
                  const SizedBox(height: 12),
                  _buildDobPicker(),
                  const SizedBox(height: 12),
                  _field(mobileCtrl, 'student_form.mobile_number'.tr(), Icons.phone,
                      keyboardType: TextInputType.phone, maxLength: 10),
                  const SizedBox(height: 12),
                  _field(religionCtrl, 'student_form.religion'.tr(), Icons.temple_hindu),
                  const SizedBox(height: 24),

                  _sectionHeader('student_form.parent_information'.tr()),
                  const SizedBox(height: 12),
                  _field(fatherNameCtrl, 'student_form.father_name'.tr(), Icons.person),
                  const SizedBox(height: 12),
                  _field(motherNameCtrl, 'student_form.mother_name'.tr(), Icons.person),
                  const SizedBox(height: 24),

                  _sectionHeader('student_form.additional_information'.tr()),
                  const SizedBox(height: 12),
                  _buildBloodGroupDropdown(),
                  const SizedBox(height: 12),
                  _buildCategoryDropdown(),
                  const SizedBox(height: 12),
                  _field(aadharNumberCtrl, 'student_form.aadhar_number'.tr(),
                      Icons.credit_card,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 24),

                  _sectionHeader('student_form.parent_extra_details'.tr()),
                  const SizedBox(height: 12),
                  _field(fatherOccupationCtrl, 'student_form.father_occupation'.tr(),
                      Icons.work),
                  const SizedBox(height: 12),
                  _field(fatherMobileCtrl, 'student_form.father_mobile'.tr(), Icons.phone,
                      keyboardType: TextInputType.phone, maxLength: 10),
                  const SizedBox(height: 12),
                  _field(motherOccupationCtrl, 'student_form.mother_occupation'.tr(),
                      Icons.work),
                  const SizedBox(height: 12),
                  _field(motherMobileCtrl, 'student_form.mother_mobile'.tr(), Icons.phone,
                      keyboardType: TextInputType.phone, maxLength: 10),
                  const SizedBox(height: 12),
                  _field(guardianNameCtrl, 'student_form.guardian_name'.tr(), Icons.person),
                  const SizedBox(height: 12),
                  _field(emergencyContactCtrl, 'student_form.emergency_contact'.tr(),
                      Icons.emergency,
                      keyboardType: TextInputType.phone, maxLength: 10),
                  const SizedBox(height: 24),

                  _sectionHeader('student_form.address_details'.tr()),
                  const SizedBox(height: 12),
                  _field(addressCtrl, 'student_form.address'.tr(), Icons.home, maxLines: 3),
                  const SizedBox(height: 12),
                  _field(cityCtrl, 'student_form.city'.tr(), Icons.location_city),
                  const SizedBox(height: 12),
                  _field(stateCtrl, 'student_form.state'.tr(), Icons.map),
                  const SizedBox(height: 12),
                  _field(pincodeCtrl, 'student_form.pincode'.tr(), Icons.pin_drop,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 24),

                  _sectionHeader('student_form.upload_documents'.tr()),
                  const SizedBox(height: 12),
                  _buildImageTile(
                    label: 'student_form.student_photo'.tr(),
                    icon: Icons.portrait,
                    notifier: _studentPhoto,
                    existingUrl: _prefill("student_photo_url"),
                  ),
                  const SizedBox(height: 12),
                  _buildImageTile(
                    label: 'student_form.aadhar_card'.tr(),
                    icon: Icons.credit_card,
                    notifier: _aadharCard,
                    existingUrl: _prefill("aadhar_card_url"),
                  ),
                  const SizedBox(height: 12),
                  _buildImageTile(
                    label: 'student_form.father_photo'.tr(),
                    icon: Icons.person,
                    notifier: _fatherPhoto,
                    existingUrl: _prefill("father_photo_url"),
                  ),
                  const SizedBox(height: 12),
                  _buildImageTile(
                    label: 'student_form.mother_photo'.tr(),
                    icon: Icons.person,
                    notifier: _motherPhoto,
                    existingUrl: _prefill("mother_photo_url"),
                  ),
                  const SizedBox(height: 24),

                  _buildFeeHeadsSection(),
                  const SizedBox(height: 20),

                  Selector<AddStudentViewModel, bool>(
                    selector: (_, vm) => vm.loading,
                    builder: (_, addLoading, __) =>
                        Selector<EditStudentViewModel, bool>(
                          selector: (_, vm) => vm.loading,
                          builder: (_, editLoading, __) {
                            final isLoading = addLoading || editLoading;
                            return AppButton(
                              title: isLoading
                                  ? 'student_form.please_wait'.tr()
                                  : (_isEdit ? 'student_form.update_student'.tr() : 'student_form.add_student'.tr()),
                              onTap: () async {
                                if (!isLoading) {
                                  await _submit();
                                }
                              },
                              loading: isLoading,
                              height: 52,
                              radius: 16,
                              gradient: AppColor.primaryGradient,
                              textColor: Colors.white,
                              icon: _isEdit
                                  ? Icons.edit_rounded
                                  : Icons.add_rounded,
                            );
                          },
                        ),
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

  // ─────────────────────────────────────────────────────────
  //  SECTION BUILDERS
  // ─────────────────────────────────────────────────────────

  Widget _buildHeader() => Container(
    padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
    decoration: BoxDecoration(
      gradient: AppColor.primaryGradient,
      borderRadius:
      const BorderRadius.vertical(bottom: Radius.circular(28)),
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
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 12),
        AppText.customText(
          _isEdit ? 'student_form.title_edit'.tr() : 'student_form.title_add'.tr(),
          size: 19,
          weight: FontWeight.bold,
          color: Colors.white,
        ),
      ],
    ),
  );

  // ── Password section ──────────────────────────────────────
  Widget _buildPasswordSection() {
    if (!_isEdit) {
      return ValueListenableBuilder<bool>(
        valueListenable: _passwordVisible,
        builder: (_, visible, __) => _passwordField(
          controller: passwordCtrl,
          hint: 'student_form.password'.tr(),
          visible: visible,
          onToggle: () => _passwordVisible.value = !visible,
        ),
      );
    }

    return ValueListenableBuilder<bool>(
      valueListenable: _showChangePassword,
      builder: (_, show, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              _showChangePassword.value = !show;
              if (!show) passwordCtrl.clear();
            },
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: show
                    ? AppColor.lightBlueColor.withOpacity(0.08)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: show
                      ? AppColor.lightBlueColor
                      : Colors.grey.shade200,
                  width: show ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock_reset_rounded,
                      color: show
                          ? AppColor.lightBlueColor
                          : Colors.grey.shade500,
                      size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      show ? 'student_form.cancel_password_change'.tr() : 'student_form.change_password'.tr(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: show
                            ? AppColor.lightBlueColor
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  Icon(
                    show
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: show
                        ? AppColor.lightBlueColor
                        : Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
          if (show) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 16, color: Colors.amber.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'student_form.password_leave_blank'.tr(),
                      style: TextStyle(
                          fontSize: 12, color: Colors.amber.shade800),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder<bool>(
              valueListenable: _passwordVisible,
              builder: (_, visible, __) => _passwordField(
                controller: passwordCtrl,
                hint: 'student_form.new_password'.tr(),
                visible: visible,
                onToggle: () => _passwordVisible.value = !visible,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
    required bool visible,
    required VoidCallback onToggle,
  }) =>
      TextField(
        controller: controller,
        obscureText: !visible,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon:
          Icon(Icons.lock, color: AppColor.lightBlueColor),
          suffixIcon: IconButton(
            icon: Icon(
              visible ? Icons.visibility : Icons.visibility_off,
              color: AppColor.lightBlueColor,
            ),
            onPressed: onToggle,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              BorderSide(color: AppColor.lightBlueColor, width: 2)),
        ),
      );

  // ── Gender picker ─────────────────────────────────────────
  Widget _buildGenderPicker() => ValueListenableBuilder<String>(
    valueListenable: _gender,
    builder: (_, val, __) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('student_form.gender'.tr(),
            style:
            TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _genderCard(
                    title: 'student_form.male'.tr(),
                    icon: Icons.male_rounded,
                    color: AppColor.maleColor,
                    selected: val == "Male",
                    onTap: () => setState(() => _gender.value = "Male"))),
            const SizedBox(width: 12),
            Expanded(
                child: _genderCard(
                    title: 'student_form.female'.tr(),
                    icon: Icons.female_rounded,
                    color: AppColor.femaleColor,
                    selected: val == "Female",
                    onTap: () =>
                        setState(() => _gender.value = "Female"))),
            const SizedBox(width: 12),
            Expanded(
                child: _genderCard(
                    title: 'student_form.other'.tr(),
                    icon: Icons.transgender_rounded,
                    color: Colors.purple,
                    selected: val == "Other",
                    onTap: () =>
                        setState(() => _gender.value = "Other"))),
          ],
        ),
      ],
    ),
  );

  // ── Academic year dropdown ─────────────────────────────────
  Widget _buildAcademicYearDropdown() =>
      Consumer<AcademicViewModel>(builder: (_, vm, __) {
        if (vm.loading) {
          return const Center(
              child: CircularProgressIndicator(strokeWidth: 2));
        }
        if (_academicYear.value.isEmpty && vm.currentYear != null) {
          Future.microtask(
                  () => _academicYear.value = vm.currentYear!.yearName ?? "");
        }
        return ValueListenableBuilder<String>(
          valueListenable: _academicYear,
          builder: (_, val, __) => _dropdownBox(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: _dropdownHint(Icons.calendar_today, 'student_form.academic_year'.tr()),
              value: val.isEmpty ? null : val,
              items: vm.years
                  .map((y) => DropdownMenuItem<String>(
                value: y.yearName,
                child: Row(children: [
                  Text(y.yearName ?? ""),
                  if (y.isCurrent == 1) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text('student_form.current'.tr(),
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ]),
              ))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _academicYear.value = v ?? ""),
            ),
          ),
        );
      });

  // ── Class dropdown ────────────────────────────────────────
  Widget _buildClassDropdown() =>
      ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: _classes,
        builder: (_, list, __) => ValueListenableBuilder<String>(
          valueListenable: _classId,
          builder: (_, cVal, __) => _dropdownBox(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: _dropdownHint(Icons.class_, 'student_form.class'.tr()),
              value: cVal.isEmpty ? null : cVal,
              items: list
                  .map((e) => DropdownMenuItem<String>(
                value: e["class_id"],
                child: Text(e["class_name"]),
              ))
                  .toList(),
              onChanged: (val) async {
                if (val == null) return;
                setState(() {
                  _classId.value = val;
                  _sectionId.value = "";
                  _sections.value = [];
                });
                final repo = AllSectionsRepository();
                final resp = await repo.allSectionsApi(val);
                if (resp["success"] == true && mounted) {
                  setState(() {
                    _sections.value =
                    List<Map<String, dynamic>>.from(resp["data"]);
                  });
                }
              },
            ),
          ),
        ),
      );

  // ── Section dropdown ──────────────────────────────────────
  Widget _buildSectionDropdown() =>
      ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: _sections,
        builder: (_, list, __) {
          final classSelected = _classId.value.isNotEmpty;
          final noSections = classSelected && list.isEmpty;

          if (noSections) {
            return _noSectionBanner();
          }

          return ValueListenableBuilder<String>(
            valueListenable: _sectionId,
            builder: (_, sVal, __) => _dropdownBox(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: _dropdownHint(Icons.grid_view_rounded, 'student_form.section'.tr()),
                value: sVal.isEmpty ? null : sVal,
                items: list
                    .map((e) => DropdownMenuItem<String>(
                  value: e["section_id"].toString(),
                  child: Text(e["section_name"]),
                ))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _sectionId.value = val ?? ""),
              ),
            ),
          );
        },
      );

  Widget _noSectionBanner() => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      color: Colors.orange.shade50,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.orange.shade200),
    ),
    child: Row(children: [
      Icon(Icons.info_outline_rounded,
          size: 20, color: Colors.orange.shade400),
      const SizedBox(width: 10),
      Text('student_form.no_section_available'.tr(),
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.orange.shade700)),
    ]),
  );

  // ── DOB picker ────────────────────────────────────────────
  Widget _buildDobPicker() => InkWell(
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        setState(() => dobCtrl.text =
        "${picked.day}/${picked.month}/${picked.year}");
      }
    },
    child: AbsorbPointer(
      child: _field(
          dobCtrl, 'student_form.date_of_birth'.tr(), Icons.cake),
    ),
  );

  // ── Blood group dropdown ──────────────────────────────────
  Widget _buildBloodGroupDropdown() => ValueListenableBuilder<String>(
    valueListenable: _bloodGroup,
    builder: (_, val, __) => _dropdownBox(
      child: DropdownButton<String>(
        isExpanded: true,
        hint: _dropdownHint(Icons.bloodtype, 'student_form.blood_group'.tr()),
        value: val.isEmpty ? null : val,
        items: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
            .map((g) => DropdownMenuItem(value: g, child: Text(g)))
            .toList(),
        onChanged: (v) => setState(() => _bloodGroup.value = v ?? ""),
      ),
    ),
  );

  // ── Category dropdown ─────────────────────────────────────
  Widget _buildCategoryDropdown() => ValueListenableBuilder<String>(
    valueListenable: _category,
    builder: (_, val, __) => _dropdownBox(
      child: DropdownButton<String>(
        isExpanded: true,
        hint: _dropdownHint(Icons.category, 'student_form.category'.tr()),
        value: val.isEmpty ? null : val,
        items: ["General", "OBC", "SC", "ST", "EWS", "Other"]
            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
            .toList(),
        onChanged: (v) => setState(() => _category.value = v ?? ""),
      ),
    ),
  );

  // ── Fee heads section ─────────────────────────────────────
  Widget _buildFeeHeadsSection() => Consumer<FeesHeadManagementViewModel>(
    builder: (_, vm, __) {
      final allFeeHeads = vm.feesHeadManagementModel?.data?.feeHeads ?? [];

      if (vm.loading) {
        return Column(children: [
          _sectionHeader('student_form.fee_heads'.tr()),
          const SizedBox(height: 12),
          const Center(child: CircularProgressIndicator()),
        ]);
      }

      if (allFeeHeads.isEmpty) return const SizedBox.shrink();

      final visibleFeeHeads = _isEdit
          ? allFeeHeads.where((fee) {
        final assignedIds = _prefill("selected_fee_heads")
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toSet();
        return assignedIds.contains(fee.feeHeadId.toString());
      }).toList()
          : allFeeHeads;

      if (_isEdit && visibleFeeHeads.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('student_form.fee_heads'.tr()),
          if (_isEdit)
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 12),
              child: Text(
                'student_form.fee_heads_assigned'.tr(),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            )
          else
            const SizedBox(height: 12),
          ...visibleFeeHeads.map((fee) {
            final id = fee.feeHeadId.toString();
            final selected = _isEdit ? true : _selectedFeeHeads.contains(id);

            return GestureDetector(
              onTap: _isEdit
                  ? null
                  : () {
                setState(() {
                  selected
                      ? _selectedFeeHeads.remove(id)
                      : _selectedFeeHeads.add(id);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColor.lightBlueColor.withOpacity(0.08)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected
                        ? AppColor.lightBlueColor
                        : Colors.grey.shade200,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColor.lightBlueColor
                            : AppColor.lightBlueColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_rounded,
                        color: selected ? Colors.white : AppColor.lightBlueColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fee.headName ?? "",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: selected
                                  ? AppColor.lightBlueColor
                                  : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isEdit ? 'student_form.assigned_fee_head'.tr() : 'student_form.fee_head'.tr(),
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    if (!_isEdit)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selected
                              ? AppColor.lightBlueColor
                              : Colors.transparent,
                          border: Border.all(
                            color: selected
                                ? AppColor.lightBlueColor
                                : Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                        child: selected
                            ? const Icon(Icons.check,
                            size: 16, color: Colors.white)
                            : null,
                      ),
                    if (_isEdit)
                      Icon(Icons.lock_outline_rounded,
                          size: 18, color: Colors.grey.shade400),
                  ],
                ),
              ),
            );
          }),
        ],
      );
    },
  );

  Widget _buildImageTile({
    required String label,
    required IconData icon,
    required ValueNotifier<File?> notifier,
    required String existingUrl,
  }) {
    final hasExisting = existingUrl.isNotEmpty && existingUrl != "null";
    return ValueListenableBuilder<File?>(
      valueListenable: notifier,
      builder: (_, file, __) {
        final showExisting = hasExisting && file == null;
        return Column(
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
                    color: (file != null || showExisting)
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
                        file != null
                            ? "$label ${'student_form.student_photo_selected'.tr()} ✓"
                            : showExisting
                            ? "$label ${'student_form.student_photo_uploaded'.tr()} • ${'student_form.tap_to_change'.tr()}"
                            : 'student_form.upload_student_photo'.tr().replaceAll('Student Photo', label),
                        style: TextStyle(
                          color: (file != null || showExisting)
                              ? Colors.green
                              : Colors.grey,
                          fontWeight: (file != null || showExisting)
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    Icon(
                      (file != null || showExisting)
                          ? Icons.check_circle
                          : Icons.upload_file,
                      color: (file != null || showExisting)
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            if (file != null) ...[
              const SizedBox(height: 8),
              Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(file,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: () => notifier.value = null,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ]),
            ] else if (showExisting) ...[
              const SizedBox(height: 8),
              Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    existingUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) => progress == null
                        ? child
                        : Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: const Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 2))),
                    errorBuilder: (_, __, ___) => Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: const Center(
                          child: Icon(Icons.broken_image_rounded,
                              color: Colors.grey)),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text('student_form.current_image'.tr(),
                        style:
                        TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                ),
              ]),
            ],
          ],
        );
      },
    );
  }

  Widget _sectionHeader(String title) => Text(
    title,
    style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColor.lightBlueColor),
  );

  Widget _dropdownBox({required Widget child}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: DropdownButtonHideUnderline(child: child),
  );

  Widget _dropdownHint(IconData icon, String label) => Row(
    children: [
      Icon(icon, color: AppColor.lightBlueColor, size: 20),
      const SizedBox(width: 12),
      Text(label),
    ],
  );

  Widget _genderCard({
    required String title,
    required IconData icon,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) =>
      InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.12) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: selected ? color : Colors.grey.shade200,
                width: selected ? 2 : 1),
            boxShadow: [
              BoxShadow(
                  color: selected
                      ? color.withOpacity(0.15)
                      : Colors.black.withOpacity(0.03),
                  blurRadius: 10)
            ],
          ),
          child: Column(children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: color.withOpacity(0.12), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? color : Colors.black87),
            ),
          ]),
        ),
      );

  Widget _field(
      TextEditingController ctrl,
      String hint,
      IconData icon, {
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
        int? maxLength,
      }) =>
      TextField(
        controller: ctrl,
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
            ? (ctx,
            {required currentLength,
              required isFocused,
              maxLength}) =>
            Text("$currentLength/$maxLength",
                style: TextStyle(
                    fontSize: 11, color: Colors.grey.shade500))
            : null,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColor.lightBlueColor),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              BorderSide(color: AppColor.lightBlueColor, width: 2)),
        ),
      );
}