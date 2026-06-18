import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:school_pro/view_model/school_view_model/student/school_student_detail_view_model.dart';

class SchoolStudentDetailScreen extends StatefulWidget {
  final int studentId;
  final String? className; // ADD
  final String? sectionName;
  const SchoolStudentDetailScreen({
    super.key,
    required this.studentId,
    this.className, // ADD
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
    if (dateString == null || dateString.trim().isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    } catch (_) {
      return 'N/A';
    }
  }

  String _capitalize(String? value) {
    if (value == null || value.trim().isEmpty) return 'N/A';
    final v = value.trim();
    return v[0].toUpperCase() + v.substring(1);
  }

  String _safe(dynamic value) {
    if (value == null) return 'N/A';
    final s = value.toString().trim();
    return s.isEmpty || s == 'null' ? 'N/A' : s;
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
      if (!launched) _showErrorSnack("Could not open document");
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
        title: const Text('Student Details'),
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
            return const Center(child: Text('No data found'));
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
                          s.name ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Admission No chip
                        if (_safe(s.admissionNo) != 'N/A')
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
                                  'Adm No: ${s.admissionNo}',
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

                        // Status chip
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 14, vertical: 6),
                        //   decoration: BoxDecoration(
                        //     color: s.status == 1 ? Colors.green : Colors.red,
                        //     borderRadius: BorderRadius.circular(20),
                        //   ),
                        //   child: Text(
                        //     s.status == 1 ? 'Active' : 'Inactive',
                        //     style: const TextStyle(
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 13,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Personal Information ────────────────────
                _buildSection('Personal Information', [
                  _buildInfoRow(
                    Icons.person_outline,
                    'Full Name',
                    _safe(s.name),
                  ),
                  _buildInfoRow(
                    Icons.email_outlined,
                    'Email',
                    _safe(s.userEmail),
                  ),
                  _buildInfoRow(
                    Icons.phone_outlined,
                    'Mobile',
                    _safe(s.mobileNumber),
                  ),
                  _buildInfoRow(
                    Icons.wc_rounded,
                    'Gender',
                    _capitalize(s.gender?.toString()),
                  ),
                  _buildInfoRow(
                    Icons.cake_outlined,
                    'Date of Birth',
                    _formatDate(s.dob?.toString()),
                  ),
                  _buildInfoRow(
                    Icons.bloodtype_outlined,
                    'Blood Group',
                    _safe(s.bloodGroup),
                  ),
                  _buildInfoRow(
                    Icons.category_outlined,
                    'Category',
                    _capitalize(s.category?.toString()),
                  ),
                  _buildInfoRow(
                    Icons.church_outlined,
                    'Religion',
                    _capitalize(s.religion?.toString()),
                  ),
                  _buildInfoRow(
                    Icons.location_city_outlined,
                    'City',
                    _safe(s.city),
                  ),
                  _buildInfoRow(Icons.map_outlined, 'State', _safe(s.state)),
                  _buildInfoRow(
                    Icons.pin_outlined,
                    'Pincode',
                    _safe(s.pincode),
                  ),
                  _buildInfoRow(
                    Icons.location_on_outlined,
                    'Address',
                    _safe(s.address),
                  ),
                ]),

                // ── Academic Information ────────────────────
                _buildSection('Academic Information', [
                  _buildInfoRow(
                    Icons.confirmation_number_outlined,
                    'Admission No',
                    _safe(s.admissionNo),
                  ),
                  _buildInfoRow(
                    Icons.format_list_numbered_rounded,
                    'Roll No',
                    _safe(s.rollNo),
                  ),
                  _buildInfoRow(
                    Icons.school_outlined,
                    'Academic Year',
                    _safe(s.academicYear),
                  ),
                  _buildInfoRow(
                    Icons.class_outlined,
                    'Class Name',
                    _safe(
                      s.className?.isNotEmpty == true
                          ? s.className
                          : widget.className,
                    ),
                  ),

                  // ✅ BAAD MEIN — widget value ko priority do
                  _buildInfoRow(
                    Icons.grid_view_outlined,
                    'Section Name',
                    _safe(
                      widget.sectionName?.isNotEmpty == true
                          ? widget.sectionName   // pehle list se aaya value use karo
                          : s.sectionName,       // fallback API se
                    ),
                  ),
                  // _buildInfoRow(Icons.class_outlined, 'Class Name',
                  //     _safe(s.className)),
                  // _buildInfoRow(Icons.grid_view_outlined, 'Section Name',
                  //     _safe(s.sectionName)),
                  _buildInfoRow(
                    Icons.calendar_today_outlined,
                    'Admission Date',
                    _formatDate(s.createdAt?.toString()),
                  ),
                ]),

                // ── Family Information ──────────────────────
                _buildSection('Family Information', [
                  _buildInfoRow(
                    Icons.person,
                    "Father's Name",
                    _safe(s.fatherName),
                  ),
                  _buildInfoRow(
                    Icons.work_outline,
                    "Father's Occupation",
                    _safe(s.fatherOccupation),
                  ),
                  _buildInfoRow(
                    Icons.phone_outlined,
                    "Father's Mobile",
                    _safe(s.fatherMobile),
                  ),
                  const Divider(height: 20),
                  _buildInfoRow(
                    Icons.person,
                    "Mother's Name",
                    _safe(s.motherName),
                  ),
                  _buildInfoRow(
                    Icons.work_outline,
                    "Mother's Occupation",
                    _safe(s.motherOccupation),
                  ),
                  _buildInfoRow(
                    Icons.phone_outlined,
                    "Mother's Mobile",
                    _safe(s.motherMobile),
                  ),
                  const Divider(height: 20),
                  _buildInfoRow(
                    Icons.supervised_user_circle_outlined,
                    "Guardian's Name",
                    _safe(s.guardianName),
                  ),
                  _buildInfoRow(
                    Icons.emergency_outlined,
                    'Emergency Contact',
                    _safe(s.emergencyContactNumber),
                  ),
                ]),

                // ── Documents ──────────────────────────────
                _buildSection('Documents', [
                  _buildDocumentCard(
                    title: 'Aadhar Card',
                    url: s.aadharCardUrl?.toString(),
                    icon: Icons.credit_card_rounded,
                  ),
                  if (_safe(s.aadharNumber) != 'N/A') ...[
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      Icons.numbers_rounded,
                      'Aadhar Number',
                      _safe(s.aadharNumber),
                    ),
                  ],
                  const SizedBox(height: 4),

                  // Father photo
                  _buildDocumentCard(
                    title: "Father's Photo",
                    url: s.fatherPhotoUrl?.toString(),
                    icon: Icons.person_rounded,
                  ),
                  const SizedBox(height: 10),

                  // Mother photo
                  _buildDocumentCard(
                    title: "Mother's Photo",
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
                                      ? 'Uploaded • Tap to view'
                                      : 'Uploaded • Tap to open')
                                : 'Not Uploaded',
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
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image_rounded,
                            size: 40,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Image could not be loaded',
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
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.zoom_out_map_rounded,
                            color: Colors.white,
                            size: 13,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Tap to expand',
                            style: TextStyle(color: Colors.white, fontSize: 11),
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
            tooltip: 'Reset Zoom',
          ),
          IconButton(
            onPressed: () async {
              final uri = Uri.parse(widget.imageUrl);
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
            icon: const Icon(Icons.open_in_new_rounded, color: Colors.white),
            tooltip: 'Open in browser',
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
                  const Text(
                    'Loading image...',
                    style: TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ],
              );
            },
            errorBuilder: (_, __, ___) => const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image_rounded,
                  size: 60,
                  color: Colors.white54,
                ),
                SizedBox(height: 12),
                Text(
                  'Could not load image',
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
