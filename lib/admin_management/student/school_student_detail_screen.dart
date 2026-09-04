import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:school_pro/view_model/school_view_model/student/school_student_detail_view_model.dart';

class SchoolStudentDetailScreen extends StatefulWidget {
  final int studentId;
  final String? className;
  final String? sectionName;
  const SchoolStudentDetailScreen({
    super.key,
    required this.studentId,
    this.className,
    this.sectionName,
  });

  @override
  State<SchoolStudentDetailScreen> createState() =>
      _SchoolStudentDetailScreenState();
}

class _SchoolStudentDetailScreenState extends State<SchoolStudentDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SchoolStudentDetailViewModel>(
        context,
        listen: false,
      ).schoolStudentDetailApi(widget.studentId, context);
    });
  }

  // ─── Helpers ────────────────────────────────────────────
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.trim().isEmpty) {
      return 'student_detail.not_available'.tr();
    }
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    } catch (_) {
      return 'student_detail.not_available'.tr();
    }
  }

  String _capitalize(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'student_detail.not_available'.tr();
    }
    final v = value.trim();
    return v[0].toUpperCase() + v.substring(1);
  }

  String _safe(dynamic value) {
    if (value == null) return 'student_detail.not_available'.tr();
    final s = value.toString().trim();
    return s.isEmpty || s == 'null' ? 'student_detail.not_available'.tr() : s;
  }

  void _showErrorSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) _showErrorSnack('student_detail.could_not_open'.tr());
    } catch (e) {
      _showErrorSnack("Error: $e");
    }
  }

  void _openImageViewer(BuildContext context, String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ImageViewerScreen(imageUrl: url, title: title),
      ),
    );
  }

  bool _isImage(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    final u = url.toLowerCase();
    return u.endsWith('.png') ||
        u.endsWith('.jpg') ||
        u.endsWith('.jpeg') ||
        u.endsWith('.webp');
  }

  // ════════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('student_detail.title'.tr()),
        backgroundColor: AppColor.lightBlueColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<SchoolStudentDetailViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final s = viewModel.schoolTeachersDetailModel?.data;

          if (s == null) {
            return Center(child: Text('student_detail.no_data'.tr()));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // ── Profile Header ──────────────────────────
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.lightBlueColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                    child: Column(
                      children: [
                        // Photo
                        CircleAvatar(
                          radius: 62,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: s.studentPhotoUrl != null
                                ? Image.network(
                              s.studentPhotoUrl!,
                              width: 124,
                              height: 124,
                              fit: BoxFit.cover,
                              loadingBuilder: (_, child, progress) =>
                              progress == null
                                  ? child
                                  : const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.person,
                                size: 70,
                                color: AppColor.lightBlueColor,
                              ),
                            )
                                : Icon(
                              Icons.person,
                              size: 70,
                              color: AppColor.lightBlueColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Name
                        Text(
                          s.name ?? 'student_detail.not_available'.tr(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Admission No chip
                        if (_safe(s.admissionNo) != 'student_detail.not_available'.tr())
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.confirmation_number_outlined,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${'student_detail.adm_no'.tr()}: ${s.admissionNo}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Personal Information ────────────────────
                _buildSection('student_detail.personal_information'.tr(), [
                  _buildInfoRow(
                    Icons.person_outline,
                    'student_detail.full_name'.tr(),
                    _safe(s.name),
                  ),
                  _buildInfoRow(
                    Icons.email_outlined,
                    'student_detail.email'.tr(),
                    _safe(s.userEmail),
                  ),
                  _buildInfoRow(
                    Icons.phone_outlined,
                    'student_detail.mobile'.tr(),
                    _safe(s.mobileNumber),
                  ),
                  _buildInfoRow(
                    Icons.wc_rounded,
                    'student_detail.gender'.tr(),
                    _capitalize(s.gender?.toString()),
                  ),
                  _buildInfoRow(
                    Icons.cake_outlined,
                    'student_detail.date_of_birth'.tr(),
                    _formatDate(s.dob?.toString()),
                  ),
                  _buildInfoRow(
                    Icons.bloodtype_outlined,
                    'student_detail.blood_group'.tr(),
                    _safe(s.bloodGroup),
                  ),
                  _buildInfoRow(
                    Icons.category_outlined,
                    'student_detail.category'.tr(),
                    _capitalize(s.category?.toString()),
                  ),
                  _buildInfoRow(
                    Icons.church_outlined,
                    'student_detail.religion'.tr(),
                    _capitalize(s.religion?.toString()),
                  ),
                  _buildInfoRow(
                    Icons.location_city_outlined,
                    'student_detail.city'.tr(),
                    _safe(s.city),
                  ),
                  _buildInfoRow(Icons.map_outlined, 'student_detail.state'.tr(), _safe(s.state)),
                  _buildInfoRow(
                    Icons.pin_outlined,
                    'student_detail.pincode'.tr(),
                    _safe(s.pincode),
                  ),
                  _buildInfoRow(
                    Icons.location_on_outlined,
                    'student_detail.address'.tr(),
                    _safe(s.address),
                  ),
                ]),

                // ── Academic Information ────────────────────
                _buildSection('student_detail.academic_information'.tr(), [
                  _buildInfoRow(
                    Icons.confirmation_number_outlined,
                    'student_detail.admission_no'.tr(),
                    _safe(s.admissionNo),
                  ),
                  _buildInfoRow(
                    Icons.format_list_numbered_rounded,
                    'student_detail.roll_no'.tr(),
                    _safe(s.rollNo),
                  ),
                  _buildInfoRow(
                    Icons.school_outlined,
                    'student_detail.academic_year'.tr(),
                    _safe(s.academicYear),
                  ),
                  _buildInfoRow(
                    Icons.class_outlined,
                    'student_detail.class_name'.tr(),
                    _safe(
                      s.className?.isNotEmpty == true
                          ? s.className
                          : widget.className,
                    ),
                  ),
                  _buildInfoRow(
                    Icons.grid_view_outlined,
                    'student_detail.section_name'.tr(),
                    _safe(
                      widget.sectionName?.isNotEmpty == true
                          ? widget.sectionName
                          : s.sectionName,
                    ),
                  ),
                  _buildInfoRow(
                    Icons.calendar_today_outlined,
                    'student_detail.admission_date'.tr(),
                    _formatDate(s.createdAt?.toString()),
                  ),
                ]),

                // ── Family Information ──────────────────────
                _buildSection('student_detail.family_information'.tr(), [
                  _buildInfoRow(
                    Icons.person,
                    "student_detail.father_name".tr(),
                    _safe(s.fatherName),
                  ),
                  _buildInfoRow(
                    Icons.work_outline,
                    "student_detail.father_occupation".tr(),
                    _safe(s.fatherOccupation),
                  ),
                  _buildInfoRow(
                    Icons.phone_outlined,
                    "student_detail.father_mobile".tr(),
                    _safe(s.fatherMobile),
                  ),
                  const Divider(height: 20),
                  _buildInfoRow(
                    Icons.person,
                    "student_detail.mother_name".tr(),
                    _safe(s.motherName),
                  ),
                  _buildInfoRow(
                    Icons.work_outline,
                    "student_detail.mother_occupation".tr(),
                    _safe(s.motherOccupation),
                  ),
                  _buildInfoRow(
                    Icons.phone_outlined,
                    "student_detail.mother_mobile".tr(),
                    _safe(s.motherMobile),
                  ),
                  const Divider(height: 20),
                  _buildInfoRow(
                    Icons.supervised_user_circle_outlined,
                    "student_detail.guardian_name".tr(),
                    _safe(s.guardianName),
                  ),
                  _buildInfoRow(
                    Icons.emergency_outlined,
                    'student_detail.emergency_contact'.tr(),
                    _safe(s.emergencyContactNumber),
                  ),
                ]),

                // ── Fee Heads ──────────────────────────────
                if ((s.feeHeads ?? []).isNotEmpty)
                  _buildSection(
                    'student_detail.assigned_fee_heads'.tr(),
                    [
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: (s.feeHeads ?? []).map((fee) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColor.lightBlueColor.withOpacity(0.15),
                                  AppColor.lightBlueColor.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: AppColor.lightBlueColor.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.payments_rounded,
                                  color: AppColor.lightBlueColor,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  fee,
                                  style: TextStyle(
                                    color: AppColor.lightBlueColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                // ── Documents ──────────────────────────────
                _buildSection('student_detail.documents'.tr(), [
                  _buildDocumentCard(
                    title: 'student_detail.aadhar_card'.tr(),
                    url: s.aadharCardUrl?.toString(),
                    icon: Icons.credit_card_rounded,
                  ),
                  if (_safe(s.aadharNumber) != 'student_detail.not_available'.tr()) ...[
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      Icons.numbers_rounded,
                      'student_detail.aadhar_number'.tr(),
                      _safe(s.aadharNumber),
                    ),
                  ],
                  const SizedBox(height: 4),

                  _buildDocumentCard(
                    title: "student_detail.father_photo".tr(),
                    url: s.fatherPhotoUrl?.toString(),
                    icon: Icons.person_rounded,
                  ),
                  const SizedBox(height: 10),

                  _buildDocumentCard(
                    title: "student_detail.mother_photo".tr(),
                    url: s.motherPhotoUrl?.toString(),
                    icon: Icons.person_rounded,
                  ),
                ]),

                const SizedBox(height: 28),
              ],
            ),
          );
        },
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  WIDGETS
  // ════════════════════════════════════════════════════════
  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColor.lightBlueColor,
                ),
              ),
              const Divider(height: 20),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColor.lightBlueColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14.5,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Document Card with inline image preview ─────────────
  Widget _buildDocumentCard({
    required String title,
    required String? url,
    required IconData icon,
  }) {
    final bool hasDoc = url != null && url.trim().isNotEmpty && url != 'null';
    final bool isImg = _isImage(url);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Card row ───────────────────────────────────────
        InkWell(
          onTap: hasDoc
              ? () => isImg
              ? _openImageViewer(context, url!, title)
              : _openUrl(url!)
              : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: hasDoc
                  ? AppColor.lightBlueColor.withOpacity(0.05)
                  : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasDoc
                    ? AppColor.lightBlueColor.withOpacity(0.3)
                    : Colors.grey[300]!,
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: hasDoc
                        ? AppColor.lightBlueColor.withOpacity(0.1)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: hasDoc ? AppColor.lightBlueColor : Colors.grey,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            hasDoc
                                ? Icons.check_circle_rounded
                                : Icons.cancel_rounded,
                            size: 13,
                            color: hasDoc ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            hasDoc
                                ? (isImg
                                ? 'student_detail.uploaded_view'.tr()
                                : 'student_detail.uploaded_open'.tr())
                                : 'student_detail.not_uploaded'.tr(),
                            style: TextStyle(
                              fontSize: 12,
                              color: hasDoc ? Colors.green[700] : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (hasDoc)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColor.lightBlueColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isImg ? Icons.image_rounded : Icons.open_in_new_rounded,
                      color: AppColor.lightBlueColor,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),

        // ── Inline image thumbnail ─────────────────────────
        if (isImg) ...[
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _openImageViewer(context, url!, title),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.network(
                    url!,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                                : null,
                            color: AppColor.lightBlueColor,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image_rounded,
                            size: 40,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'student_detail.image_error'.tr(),
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.zoom_out_map_rounded,
                            color: Colors.white,
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'student_detail.tap_to_expand'.tr(),
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ════════════════════════════════════════════════════════
//  FULL-SCREEN IMAGE VIEWER
// ════════════════════════════════════════════════════════
class _ImageViewerScreen extends StatefulWidget {
  final String imageUrl;
  final String title;

  const _ImageViewerScreen({required this.imageUrl, required this.title});

  @override
  State<_ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<_ImageViewerScreen> {
  final TransformationController _transformController =
  TransformationController();

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _resetZoom() => _transformController.value = Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: _resetZoom,
            icon: const Icon(Icons.fit_screen_rounded, color: Colors.white),
            tooltip: 'student_detail.reset_zoom'.tr(),
          ),
          IconButton(
            onPressed: () async {
              final uri = Uri.parse(widget.imageUrl);
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
            icon: const Icon(Icons.open_in_new_rounded, color: Colors.white),
            tooltip: 'student_detail.open_browser'.tr(),
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          transformationController: _transformController,
          panEnabled: true,
          scaleEnabled: true,
          minScale: 0.5,
          maxScale: 5.0,
          child: Image.network(
            widget.imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                        : null,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'student_detail.loading_image'.tr(),
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ],
              );
            },
            errorBuilder: (_, __, ___) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image_rounded,
                  size: 60,
                  color: Colors.white54,
                ),
                const SizedBox(height: 12),
                Text(
                  'student_detail.image_error'.tr(),
                  style: const TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}