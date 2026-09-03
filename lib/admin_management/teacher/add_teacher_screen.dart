import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/app_button.dart';
import 'package:school_pro/view_model/school_view_model/teacher/add_teacher_view_model.dart';
import 'package:school_pro/view_model/school_view_model/teacher/all_teachers_view_model.dart';

import '../../utils/utils.dart';

class AddTeacherScreen extends StatefulWidget {
  const AddTeacherScreen({super.key});

  @override
  State<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen>
    with SingleTickerProviderStateMixin {
  // ── Controllers ──
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _qualificationCtrl = TextEditingController();
  final _experienceCtrl = TextEditingController();
  final _joiningDateCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _fatherNameCtrl = TextEditingController();
  final _motherNameCtrl = TextEditingController();
  final _employeeIdCtrl = TextEditingController();
  final _designationCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();

  // ── State ──
  File? _teacherPhoto;
  File? _aadharCard;
  bool _obscurePassword = true;
  bool _isLoading = false;
  int _currentStep = 0;

  String? _selectedGender;
  String? _selectedEmploymentType;

  static const List<String> _genderOptions = ["Male", "Female", "Other"];
  static const List<String> _employmentOptions = [
    "Full Time",
    "Part Time",
    "Contract",
  ];

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _qualificationCtrl.dispose();
    _experienceCtrl.dispose();
    _joiningDateCtrl.dispose();
    _mobileCtrl.dispose();
    _addressCtrl.dispose();
    _fatherNameCtrl.dispose();
    _motherNameCtrl.dispose();
    _employeeIdCtrl.dispose();
    _designationCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  // ── Snackbar ──
  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: AppColor.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ── Image Picker ──
  Future<void> _pickImage(ImageSource source, bool isTeacherPhoto) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      setState(() {
        if (isTeacherPhoto) {
          _teacherPhoto = File(picked.path);
        } else {
          _aadharCard = File(picked.path);
        }
      });
    }
  }

  void _showImageSourceSheet(bool isTeacherPhoto) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColor.bg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColor.border,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text('add_teacher.take_photo'.tr()),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, isTeacherPhoto);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text('add_teacher.choose_gallery'.tr()),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, isTeacherPhoto);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // ── Validation ──
  bool _validateStep(int step) {
    switch (step) {
      case 0:
        if (_nameCtrl.text.trim().isEmpty) {
          Utils.show('add_teacher.errors.enter_full_name'.tr(), context);
          return false;
        }
        final email = _emailCtrl.text.trim();
        if (email.isEmpty) {
          Utils.show('add_teacher.errors.enter_email'.tr(), context);
          return false;
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
          Utils.show('add_teacher.errors.valid_email'.tr(), context);
          return false;
        }
        if (_passwordCtrl.text.trim().isEmpty) {
          Utils.show('add_teacher.errors.enter_password'.tr(), context);
          return false;
        }
        return true;

      case 1:
        if (_employeeIdCtrl.text.trim().isEmpty) {
          Utils.show('add_teacher.errors.enter_employee_id'.tr(), context);
          return false;
        }
        if (_selectedGender == null) {
          Utils.show('add_teacher.errors.select_gender'.tr(), context);
          return false;
        }
        if (_selectedEmploymentType == null) {
          Utils.show('add_teacher.errors.select_employment'.tr(), context);
          return false;
        }
        if (_designationCtrl.text.trim().isEmpty) {
          Utils.show('add_teacher.errors.enter_designation'.tr(), context);
          return false;
        }
        if (_qualificationCtrl.text.trim().isEmpty) {
          Utils.show('add_teacher.errors.enter_qualification'.tr(), context);
          return false;
        }
        if (_experienceCtrl.text.trim().isEmpty) {
          Utils.show('add_teacher.errors.enter_experience'.tr(), context);
          return false;
        }
        if (_joiningDateCtrl.text.trim().isEmpty) {
          Utils.show('add_teacher.errors.enter_joining_date'.tr(), context);
          return false;
        }
        return true;

      case 2:
        if (_dobCtrl.text.trim().isEmpty) {
          Utils.show('add_teacher.errors.enter_dob'.tr(), context);
          return false;
        }
        if (_mobileCtrl.text.trim().isEmpty) {
          Utils.show('add_teacher.errors.enter_mobile'.tr(), context);
          return false;
        }
        if (_addressCtrl.text.trim().isEmpty) {
          Utils.show('add_teacher.errors.enter_address'.tr(), context);
          return false;
        }
        if (_fatherNameCtrl.text.trim().isEmpty) {
          Utils.show('add_teacher.errors.enter_father_name'.tr(), context);
          return false;
        }
        if (_motherNameCtrl.text.trim().isEmpty) {
          Utils.show('add_teacher.errors.enter_mother_name'.tr(), context);
          return false;
        }
        return true;

      default:
        return true;
    }
  }

  // ── Submit ──
  Future<void> _handleSubmit() async {
    if (!_validateStep(0) || !_validateStep(1) || !_validateStep(2)) return;

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    final success =
        await Provider.of<AddTeachersViewModel>(
          context,
          listen: false,
        ).addTeachersApi(
          context: context,
          name: _nameCtrl.text.trim(),
          userEmail: _emailCtrl.text.trim(),
          password: _passwordCtrl.text.trim(),
          qualification: _qualificationCtrl.text.trim(),
          experienceYears: _experienceCtrl.text.trim(),
          joiningDate: _joiningDateCtrl.text.trim(),
          mobileNumber: _mobileCtrl.text.trim(),
          address: _addressCtrl.text.trim(),
          fatherName: _fatherNameCtrl.text.trim(),
          motherName: _motherNameCtrl.text.trim(),
          employeeId: _employeeIdCtrl.text.trim(),
          gender: _selectedGender ?? '',
          employmentType: _selectedEmploymentType ?? '',
          designation: _designationCtrl.text.trim(),
          dob: _dobCtrl.text.trim(),
          teacher_photo: _teacherPhoto,
          aadharCard: _aadharCard,
        );

    setState(() => _isLoading = false);

    if (success && context.mounted) {
      Provider.of<AllTeachersListVieModel>(
        context,
        listen: false,
      ).allTeachersListApi(context);

      Navigator.pop(context);
    }
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBg,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildHeader(),
            _buildStepIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 100),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildSection1(),
                    const SizedBox(height: 16),
                    _buildSection2(),
                    const SizedBox(height: 16),
                    _buildSection3(),
                    const SizedBox(height: 16),
                    _buildSection4(),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ── Header ──
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 52, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.lightBlueColor,
            AppColor.lightBlueColor.withOpacity(0.82),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: AppColor.lightBlueColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(50),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.22),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'add_teacher.title'.tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'add_teacher.subtitle'.tr(),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.78),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.person_add_alt_1_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 5),
                Text(
                  'add_teacher.new'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Step Indicator ──
  Widget _buildStepIndicator() {
    final steps = [
      ('add_teacher.step_account'.tr(), Icons.manage_accounts_rounded),
      ('add_teacher.step_professional'.tr(), Icons.work_outline_rounded),
      ('add_teacher.step_personal'.tr(), Icons.badge_outlined),
      ('add_teacher.step_documents'.tr(), Icons.photo_library_outlined),
    ];

    return Container(
      color: AppColor.screenBg,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
      child: Row(
        children: List.generate(steps.length, (i) {
          final isActive = i <= _currentStep;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 4,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColor.lightBlueColor
                              : AppColor.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        steps[i].$1,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isActive
                              ? AppColor.lightBlueColor
                              : AppColor.sub,
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < steps.length - 1) const SizedBox(width: 6),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ── Section 1 — Account Info ──
  Widget _buildSection1() {
    return _sectionCard(
      index: 1,
      icon: Icons.manage_accounts_rounded,
      title: 'add_teacher.account_info'.tr(),
      color: AppColor.lightBlueColor,
      onTap: () => setState(() => _currentStep = 0),
      children: [
        _sheetField(
          _nameCtrl,
          'add_teacher.full_name'.tr(),
          'add_teacher.full_name_hint'.tr(),
          Icons.person_outline_rounded,
        ),
        const SizedBox(height: 14),
        _sheetField(
          _emailCtrl,
          'add_teacher.email_address'.tr(),
          'add_teacher.email_hint'.tr(),
          Icons.email_outlined,
          keyboard: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _passwordField(),
      ],
    );
  }

  // ── Section 2 — Professional ──
  Widget _buildSection2() {
    return _sectionCard(
      index: 2,
      icon: Icons.work_outline_rounded,
      title: 'add_teacher.professional_details'.tr(),
      color: AppColor.success,
      onTap: () => setState(() => _currentStep = 1),
      children: [
        _sheetField(
          _employeeIdCtrl,
          'add_teacher.employee_id'.tr(),
          'add_teacher.employee_id_hint'.tr(),
          Icons.badge_outlined,
        ),
        const SizedBox(height: 14),
        _dropdownField(
          label: 'add_teacher.gender'.tr(),
          icon: Icons.wc_outlined,
          value: _genderOptions.contains(_selectedGender)
              ? _selectedGender
              : null,
          hint: 'add_teacher.select_gender'.tr(),
          items: _genderOptions,
          onChanged: (val) => setState(() => _selectedGender = val),
        ),
        const SizedBox(height: 14),
        _dropdownField(
          label: 'add_teacher.employment_type'.tr(),
          icon: Icons.work_history_outlined,
          value: _employmentOptions.contains(_selectedEmploymentType)
              ? _selectedEmploymentType
              : null,
          hint: 'add_teacher.select_employment'.tr(),
          items: _employmentOptions,
          onChanged: (val) => setState(() => _selectedEmploymentType = val),
        ),
        const SizedBox(height: 14),
        _sheetField(
          _designationCtrl,
          'add_teacher.designation'.tr(),
          'add_teacher.designation_hint'.tr(),
          Icons.military_tech_outlined,
        ),
        const SizedBox(height: 14),
        _sheetField(
          _qualificationCtrl,
          'add_teacher.qualification'.tr(),
          'add_teacher.qualification_hint'.tr(),
          Icons.school_outlined,
        ),
        const SizedBox(height: 14),
        _sheetField(
          _experienceCtrl,
          'add_teacher.experience'.tr(),
          'add_teacher.experience_hint'.tr(),
          Icons.timeline_outlined,
          keyboard: TextInputType.number,
          formatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 14),
        _dateField(
          _joiningDateCtrl,
          'add_teacher.joining_date'.tr(),
          Icons.calendar_today_outlined,
        ),
      ],
    );
  }

  // ── Section 3 — Personal Info ──
  Widget _buildSection3() {
    return _sectionCard(
      index: 3,
      icon: Icons.badge_outlined,
      title: 'add_teacher.personal_info'.tr(),
      color: const Color(0xFFF77F00),
      onTap: () => setState(() => _currentStep = 2),
      children: [
        _dateField(
          _dobCtrl,
          'add_teacher.date_of_birth'.tr(),
          Icons.cake_outlined,
          isDoB: true,
        ),
        const SizedBox(height: 14),
        _sheetField(
          _mobileCtrl,
          'add_teacher.mobile_number'.tr(),
          'add_teacher.mobile_hint'.tr(),
          Icons.phone_outlined,
          keyboard: TextInputType.phone,
          formatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        ),
        const SizedBox(height: 14),
        _sheetField(
          _addressCtrl,
          'add_teacher.address'.tr(),
          'add_teacher.address_hint'.tr(),
          Icons.location_on_outlined,
          maxLines: 2,
        ),
        const SizedBox(height: 14),
        _sheetField(
          _fatherNameCtrl,
          'add_teacher.father_name'.tr(),
          'add_teacher.father_hint'.tr(),
          Icons.family_restroom_outlined,
        ),
        const SizedBox(height: 14),
        _sheetField(
          _motherNameCtrl,
          'add_teacher.mother_name'.tr(),
          'add_teacher.mother_hint'.tr(),
          Icons.woman_outlined,
        ),
      ],
    );
  }

  // ── Section 4 — Documents ──
  Widget _buildSection4() {
    return _sectionCard(
      index: 4,
      icon: Icons.photo_library_outlined,
      title: 'add_teacher.documents_photo'.tr(),
      color: const Color(0xFF7B2FBE),
      onTap: () => setState(() => _currentStep = 3),
      children: [
        _imagePickerField(
          label: 'add_teacher.teacher_photo'.tr(),
          icon: Icons.person_pin_outlined,
          file: _teacherPhoto,
          isTeacherPhoto: true,
        ),
        const SizedBox(height: 14),
        _imagePickerField(
          label: 'add_teacher.aadhar_card'.tr(),
          icon: Icons.credit_card_outlined,
          file: _aadharCard,
          isTeacherPhoto: false,
        ),
      ],
    );
  }

  // ── Bottom Submit Bar ──
  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        18,
        12,
        18,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: AppColor.bg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Cancel
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                color: AppColor.border.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColor.border, width: 1.5),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: AppColor.sub,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'add_teacher.cancel'.tr(),
                    style: const TextStyle(
                      color: AppColor.sub,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Submit
          Expanded(
            child: AppButton(
              title: _isLoading
                  ? 'add_teacher.adding_teacher'.tr()
                  : 'add_teacher.add_teacher_btn'.tr(),
              onTap: _handleSubmit,
              height: 54,
              radius: 16,
              gradient: AppColor.primaryGradient,
              textColor: Colors.white,
              icon: _isLoading ? null : Icons.person_add_alt_1_rounded,
              loading: _isLoading,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────

  Widget _sectionCard({
    required int index,
    required IconData icon,
    required String title,
    required Color color,
    required List<Widget> children,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.06),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                border: Border(
                  bottom: BorderSide(color: color.withOpacity(0.12)),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "$index",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(icon, size: 18, color: color),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: color,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetField(
    TextEditingController ctrl,
    String label,
    String hint,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
    List<TextInputFormatter>? formatters,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.sub,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: keyboard,
          inputFormatters: formatters,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.text,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 13.5,
              color: AppColor.sub.withOpacity(0.6),
            ),
            prefixIcon: Icon(
              icon,
              size: 18,
              color: AppColor.primary.withOpacity(0.7),
            ),
            filled: true,
            fillColor: AppColor.primaryLight.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.primary, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'add_teacher.password'.tr(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.sub,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _passwordCtrl,
          obscureText: _obscurePassword,
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.text,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'add_teacher.password_hint'.tr(),
            hintStyle: TextStyle(
              fontSize: 13,
              color: AppColor.sub.withOpacity(0.6),
            ),
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              size: 18,
              color: AppColor.primary.withOpacity(0.7),
            ),
            suffixIcon: IconButton(
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 18,
                color: AppColor.sub,
              ),
            ),
            filled: true,
            fillColor: AppColor.primaryLight.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.primary, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.sub,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          hint: Text(
            hint,
            style: TextStyle(
              fontSize: 13.5,
              color: AppColor.sub.withOpacity(0.6),
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColor.sub,
            size: 20,
          ),
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.text,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: Colors.white,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              size: 18,
              color: AppColor.primary.withOpacity(0.7),
            ),
            filled: true,
            fillColor: AppColor.primaryLight.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.primary, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool isDoB = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.sub,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          readOnly: true,
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.text,
            fontWeight: FontWeight.w500,
          ),
          onTap: () async {
            DateTime initial = isDoB ? DateTime(2000) : DateTime.now();
            try {
              if (ctrl.text.isNotEmpty) initial = DateTime.parse(ctrl.text);
            } catch (_) {}
            final picked = await showDatePicker(
              context: context,
              initialDate: initial,
              firstDate: isDoB ? DateTime(1950) : DateTime(2000),
              lastDate: isDoB ? DateTime.now() : DateTime(2100),
              builder: (c, child) => Theme(
                data: Theme.of(c).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColor.primary,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: AppColor.text,
                  ),
                ),
                child: child!,
              ),
            );
            if (picked != null) {
              ctrl.text =
                  "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
            }
          },
          decoration: InputDecoration(
            hintText: 'add_teacher.select_date'.tr().replaceAll(
              '{label}',
              label.toLowerCase(),
            ),
            hintStyle: TextStyle(
              fontSize: 13.5,
              color: AppColor.sub.withOpacity(0.6),
            ),
            prefixIcon: Icon(
              icon,
              size: 18,
              color: AppColor.primary.withOpacity(0.7),
            ),
            suffixIcon: const Icon(
              Icons.arrow_drop_down_rounded,
              color: AppColor.sub,
            ),
            filled: true,
            fillColor: AppColor.primaryLight.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.primary, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _imagePickerField({
    required String label,
    required IconData icon,
    required File? file,
    required bool isTeacherPhoto,
  }) {
    final bool hasFile = file != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: AppColor.sub),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColor.sub,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showImageSourceSheet(isTeacherPhoto),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 100,
            width: screenWidth,
            decoration: BoxDecoration(
              color: AppColor.border.withOpacity(0.3),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasFile
                    ? AppColor.success.withOpacity(0.5)
                    : AppColor.border,
                width: 1.5,
              ),
            ),
            child: hasFile
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(file, fit: BoxFit.cover),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            width: screenWidth,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColor.success,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            width: screenWidth,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(13),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'add_teacher.tap_to_change'.tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 28,
                        color: AppColor.sub.withOpacity(0.6),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'add_teacher.tap_to_upload'.tr(),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.sub.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
