import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/app_button.dart';
import 'package:school_pro/utils/utils.dart';
import 'package:school_pro/view_model/school_view_model/accountant/add_accountant_view_model.dart';
import 'package:school_pro/view_model/school_view_model/accountant/all_accountant_list_view_model.dart';

class AddAccountantScreen extends StatefulWidget {
  const AddAccountantScreen({super.key});

  @override
  State<AddAccountantScreen> createState() => _AddAccountantScreenState();
}

class _AddAccountantScreenState extends State<AddAccountantScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _qualCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  final _joiningDateCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _fatherCtrl = TextEditingController();
  final _motherCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  String? _employmentType;
  File? _accountantPhoto;
  File? _aadharCard;
  bool _obscurePassword = true;
  bool _isLoading = false;

  // ── Image Picker ─────────────────────────────────────────
  Future<void> _pickImage(ImageSource source, bool isPhoto) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        if (isPhoto) {
          _accountantPhoto = File(picked.path);
        } else {
          _aadharCard = File(picked.path);
        }
      });
    }
  }

  void _showImageSourceSheet(bool isPhoto) {
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
                title: Text('common.take_photo'.tr()),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, isPhoto);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text('common.choose_from_gallery'.tr()),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, isPhoto);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // ── Validation & Submit ───────────────────────────────────
  Future<void> _handleSubmit() async {
    if (_nameCtrl.text.trim().isEmpty) {
      Utils.show('add_accountant.errors.enter_full_name'.tr(), context);
      return;
    }

    final email = _emailCtrl.text.trim();

    if (email.isEmpty) {
      Utils.show('add_accountant.errors.enter_email'.tr(), context);
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      Utils.show('add_accountant.errors.valid_email'.tr(), context);
      return;
    }

    if (_passwordCtrl.text.trim().isEmpty) {
      Utils.show('add_accountant.errors.enter_password'.tr(), context);
      return;
    }

    if (_qualCtrl.text.trim().isEmpty) {
      Utils.show('add_accountant.errors.enter_qualification'.tr(), context);
      return;
    }

    if (_expCtrl.text.trim().isEmpty) {
      Utils.show('add_accountant.errors.enter_experience'.tr(), context);
      return;
    }

    if (_joiningDateCtrl.text.trim().isEmpty) {
      Utils.show('add_accountant.errors.select_joining_date'.tr(), context);
      return;
    }

    if (_mobileCtrl.text.trim().isEmpty) {
      Utils.show('add_accountant.errors.enter_mobile'.tr(), context);
      return;
    }

    if (_addressCtrl.text.trim().isEmpty) {
      Utils.show('add_accountant.errors.enter_address'.tr(), context);
      return;
    }

    if (_fatherCtrl.text.trim().isEmpty) {
      Utils.show('add_accountant.errors.enter_father_name'.tr(), context);
      return;
    }

    if (_motherCtrl.text.trim().isEmpty) {
      Utils.show('add_accountant.errors.enter_mother_name'.tr(), context);
      return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    final success =
        await Provider.of<AddAccountantViewModel>(
          context,
          listen: false,
        ).addAccountantApi(
          context: context,
          name: _nameCtrl.text.trim(),
          user_email: email,
          password: _passwordCtrl.text.trim(),
          qualification: _qualCtrl.text.trim(),
          experience_years: _expCtrl.text.trim(),
          mobile_number: _mobileCtrl.text.trim(),
          address: _addressCtrl.text.trim(),
          father_name: _fatherCtrl.text.trim(),
          mother_name: _motherCtrl.text.trim(),
          accountant_photo: _accountantPhoto,
          aadharCard: _aadharCard,
          dob: _dobCtrl.text.trim(),
          joining_date: _joiningDateCtrl.text.trim(),
          employment_type: _employmentType!,
        );

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.screenBg,
      body: Column(
        children: [
          // Header
          _buildHeader(),
          // Scrollable form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 100),
              child: Column(
                children: [
                  _sectionCard(
                    index: 1,
                    icon: Icons.manage_accounts_rounded,
                    title: 'add_accountant.account_info'.tr(),
                    color: AppColor.lightBlueColor,
                    children: [
                      _field(
                        _nameCtrl,
                        'add_accountant.full_name'.tr(),
                        'add_accountant.full_name_hint'.tr(),
                        Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 14),
                      _field(
                        _emailCtrl,
                        'add_accountant.email_address'.tr(),
                        'add_accountant.email_hint'.tr(),
                        Icons.email_outlined,
                        keyboard: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 14),
                      _passwordField(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _sectionCard(
                    index: 2,
                    icon: Icons.work_outline_rounded,
                    title: 'add_accountant.professional_details'.tr(),
                    color: AppColor.success,
                    children: [
                      _field(
                        _qualCtrl,
                        'add_accountant.qualification'.tr(),
                        'add_accountant.qualification_hint'.tr(),
                        Icons.school_outlined,
                      ),
                      const SizedBox(height: 14),
                      _field(
                        _expCtrl,
                        'add_accountant.experience'.tr(),
                        'add_accountant.experience_hint'.tr(),
                        Icons.timeline_outlined,
                        keyboard: TextInputType.number,
                        formatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      const SizedBox(height: 14),
                      _dateField(),
                      const SizedBox(height: 14),
                      _dobField(),
                      const SizedBox(height: 14),
                      _employmentDropdown(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _sectionCard(
                    index: 3,
                    icon: Icons.badge_outlined,
                    title: 'add_accountant.personal_info'.tr(),
                    color: const Color(0xFFF77F00),
                    children: [
                      _field(
                        _mobileCtrl,
                        'add_accountant.mobile_number'.tr(),
                        'add_accountant.mobile_hint'.tr(),
                        Icons.phone_outlined,
                        keyboard: TextInputType.phone,
                        formatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _field(
                        _addressCtrl,
                        'add_accountant.address'.tr(),
                        'add_accountant.address_hint'.tr(),
                        Icons.location_on_outlined,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 14),
                      _field(
                        _fatherCtrl,
                        'add_accountant.father_name'.tr(),
                        'add_accountant.father_hint'.tr(),
                        Icons.family_restroom_outlined,
                      ),
                      const SizedBox(height: 14),
                      _field(
                        _motherCtrl,
                        'add_accountant.mother_name'.tr(),
                        'add_accountant.mother_hint'.tr(),
                        Icons.woman_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _sectionCard(
                    index: 4,
                    icon: Icons.photo_library_outlined,
                    title: 'add_accountant.documents_photo'.tr(),
                    color: const Color(0xFF7B2FBE),
                    children: [
                      _imagePickerField(
                        label: 'add_accountant.accountant_photo'.tr(),
                        icon: Icons.person_pin_outlined,
                        file: _accountantPhoto,
                        isPhoto: true,
                      ),
                      const SizedBox(height: 14),
                      _imagePickerField(
                        label: 'add_accountant.aadhar_card'.tr(),
                        icon: Icons.credit_card_outlined,
                        file: _aadharCard,
                        isPhoto: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  AppButton(
                    title: _isLoading
                        ? 'add_accountant.adding_accountant'.tr()
                        : 'add_accountant.add_accountant_btn'.tr(),
                    onTap: _handleSubmit,
                    height: 54,
                    radius: 16,
                    gradient: AppColor.primaryGradient,
                    textColor: Colors.white,
                    icon: _isLoading ? null : Icons.person_add_alt_1_rounded,
                    loading: _isLoading,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.lightBlueColor,
            AppColor.lightBlueColor.withOpacity(0.85),
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
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
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'add_accountant.title'.tr(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'add_accountant.subtitle'.tr(),
                style: const TextStyle(fontSize: 13, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _employmentDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'add_accountant.employment_type'.tr(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.sub,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _employmentType,
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.text,
            fontWeight: FontWeight.w500,
          ),
          items: [
            DropdownMenuItem(
              value: "full_time",
              child: Text('add_accountant.full_time'.tr()),
            ),
            DropdownMenuItem(
              value: "part_time",
              child: Text('add_accountant.part_time'.tr()),
            ),
            DropdownMenuItem(
              value: "contract",
              child: Text('add_accountant.contract'.tr()),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _employmentType = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'add_accountant.select_employment'.tr(),
            hintStyle: TextStyle(
              fontSize: 13.5,
              color: AppColor.sub.withOpacity(0.6),
            ),
            prefixIcon: Icon(
              Icons.work_outline,
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

  Widget _dobField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'add_accountant.date_of_birth'.tr(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.sub,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _dobCtrl,
          readOnly: true,
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.text,
            fontWeight: FontWeight.w500,
          ),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime(2000),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              _dobCtrl.text =
                  "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
            }
          },
          decoration: InputDecoration(
            hintText: 'add_accountant.dob_hint'.tr(),
            hintStyle: TextStyle(
              fontSize: 13.5,
              color: AppColor.sub.withOpacity(0.6),
            ),
            prefixIcon: Icon(
              Icons.cake_outlined,
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

  // ── Reusable Widgets ──────────────────────────────────────
  Widget _field(
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
          'add_accountant.password'.tr(),
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
            hintText: 'add_accountant.password_hint'.tr(),
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

  Widget _dateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'add_accountant.joining_date'.tr(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.sub,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _joiningDateCtrl,
          readOnly: true,
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.text,
            fontWeight: FontWeight.w500,
          ),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
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
              _joiningDateCtrl.text =
                  "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
            }
          },
          decoration: InputDecoration(
            hintText: 'add_accountant.joining_date_hint'.tr(),
            hintStyle: TextStyle(
              fontSize: 13.5,
              color: AppColor.sub.withOpacity(0.6),
            ),
            prefixIcon: Icon(
              Icons.calendar_today_outlined,
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
    required bool isPhoto,
  }) {
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
          onTap: () => _showImageSourceSheet(isPhoto),
          child: Container(
            height: 100,
            width: screenWidth,
            decoration: BoxDecoration(
              color: AppColor.border.withOpacity(0.3),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: file != null
                    ? AppColor.success.withOpacity(0.5)
                    : AppColor.border,
                width: 1.5,
              ),
            ),
            child: file != null
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
                        'add_accountant.tap_to_upload'.tr(),
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

  Widget _sectionCard({
    required int index,
    required IconData icon,
    required String title,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
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
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _qualCtrl.dispose();
    _expCtrl.dispose();
    _joiningDateCtrl.dispose();
    _mobileCtrl.dispose();
    _addressCtrl.dispose();
    _fatherCtrl.dispose();
    _motherCtrl.dispose();
    super.dispose();
  }
}
