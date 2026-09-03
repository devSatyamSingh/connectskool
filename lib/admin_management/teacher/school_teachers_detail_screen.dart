// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:school_pro/res/app_color.dart';
// import 'package:school_pro/res/const_text.dart';
//
// import '../view_model/school_view_model/school_teachers_view_model.dart';
//
// class SchoolTeachersDetailScreen extends StatefulWidget {
//   final int teacherId;
//
//   const SchoolTeachersDetailScreen({
//     super.key,
//     required this.teacherId,
//   });
//
//   @override
//   State<SchoolTeachersDetailScreen> createState() =>
//       _SchoolTeachersDetailScreenState();
// }
//
// class _SchoolTeachersDetailScreenState
//     extends State<SchoolTeachersDetailScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<TeacherDetailViewModel>(context, listen: false)
//           .schoolTeachersDetailApi(widget.teacherId, context);
//     });
//   }
//
//   String _formatDate(String? dateString) {
//     if (dateString == null) return 'N/A';
//     try {
//       final date = DateTime.parse(dateString);
//       return '${date.day}/${date.month}/${date.year}';
//     } catch (e) {
//       return 'N/A';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text('Teacher Details'),
//         backgroundColor: AppColor.lightBlueColor,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Consumer<TeacherDetailViewModel>(
//         builder: (context, viewModel, child) {
//           if (viewModel.loading) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           final teacherData = viewModel.schoolTeachersDetailModel?.data;
//
//           if (teacherData == null) {
//             return const Center(
//               child: Text('No data found'),
//             );
//           }
//
//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Profile Header
//                 Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: AppColor.lightBlueColor,
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(30),
//                       bottomRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 60,
//                           backgroundColor: Colors.white,
//                           child: teacherData.teacherPhotoUrl != null
//                               ? ClipOval(
//                             child: Image.network(
//                               teacherData.teacherPhotoUrl!,
//                               fit: BoxFit.cover,
//                               width: 120,
//                               height: 120,
//                             ),
//                           )
//                               : Icon(
//                             Icons.person,
//                             size: 80,
//                             color: AppColor.lightBlueColor,
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         Text(
//                           teacherData.name ?? 'N/A',
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         Text(
//                           teacherData.qualification ?? 'N/A',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.white70,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 6,
//                           ),
//                           decoration: BoxDecoration(
//                             color: teacherData.status == 1
//                                 ? Colors.green
//                                 : Colors.red,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             teacherData.status == 1 ? 'Active' : 'Inactive',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//
//                 // Personal Information Section
//                 _buildSection(
//                   'Personal Information',
//                   [
//                     _buildInfoRow(
//                       Icons.person_outline,
//                       'Full Name',
//                       teacherData.name ?? 'N/A',
//                     ),
//                     _buildInfoRow(
//                       Icons.email_outlined,
//                       'Email',
//                       teacherData.userEmail ?? 'N/A',
//                     ),
//                     _buildInfoRow(
//                       Icons.phone_outlined,
//                       'Mobile Number',
//                       teacherData.mobileNumber ?? 'N/A',
//                     ),
//                     _buildInfoRow(
//                       Icons.location_on_outlined,
//                       'Address',
//                       teacherData.address ?? 'N/A',
//                     ),
//                   ],
//                 ),
//
//                 // Family Information Section
//                 _buildSection(
//                   'Family Information',
//                   [
//                     _buildInfoRow(
//                       Icons.person,
//                       'Father\'s Name',
//                       teacherData.fatherName ?? 'N/A',
//                     ),
//                     _buildInfoRow(
//                       Icons.person,
//                       'Mother\'s Name',
//                       teacherData.motherName ?? 'N/A',
//                     ),
//                   ],
//                 ),
//
//                 // Professional Information Section
//                 _buildSection(
//                   'Professional Information',
//                   [
//                     _buildInfoRow(
//                       Icons.school_outlined,
//                       'Qualification',
//                       teacherData.qualification ?? 'N/A',
//                     ),
//                     _buildInfoRow(
//                       Icons.work_outline,
//                       'Experience',
//                       '${teacherData.experienceYears ?? 0} Years',
//                     ),
//                     _buildInfoRow(
//                       Icons.calendar_today_outlined,
//                       'Joining Date',
//                       _formatDate(teacherData.joiningDate),
//                     ),
//                   ],
//                 ),
//
//                 // System Information Section
//                 _buildSection(
//                   'System Information',
//                   [
//                     _buildInfoRow(
//                       Icons.badge_outlined,
//                       'Teacher ID',
//                       '${teacherData.teacherId ?? 'N/A'}',
//                     ),
//                     _buildInfoRow(
//                       Icons.badge_outlined,
//                       'User ID',
//                       '${teacherData.userId ?? 'N/A'}',
//                     ),
//                     _buildInfoRow(
//                       Icons.school,
//                       'School ID',
//                       '${teacherData.schoolId ?? 'N/A'}',
//                     ),
//                     _buildInfoRow(
//                       Icons.access_time,
//                       'Created At',
//                       _formatDate(teacherData.createdAt),
//                     ),
//                     _buildInfoRow(
//                       Icons.update,
//                       'Updated At',
//                       _formatDate(teacherData.updatedAt),
//                     ),
//                   ],
//                 ),
//
//                 // Documents Section
//                 _buildSection(
//                   'Documents',
//                   [
//                     _buildDocumentCard(
//                       'Aadhar Card',
//                       teacherData.aadharCardUrl,
//                       Icons.credit_card,
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 20),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildSection(String title, List<Widget> children) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: AppColor.lightBlueColor,
//                 ),
//               ),
//               const SizedBox(height: 15),
//               ...children,
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: AppColor.lightBlueColor, size: 22),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     fontSize: 15,
//                     color: Colors.black87,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDocumentCard(String title, String? url, IconData icon) {
//     return InkWell(
//       onTap: url != null ? () {} : null,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.grey[50],
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: Colors.grey[300]!),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: url != null ? AppColor.lightBlueColor : Colors.grey,
//               size: 30,
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     url != null ? 'View Document' : 'Not Uploaded',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: url != null ? AppColor.lightBlueColor : Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(
//               url != null ? Icons.arrow_forward_ios : Icons.info_outline,
//               color: url != null ? AppColor.lightBlueColor : Colors.grey,
//               size: 18,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../view_model/school_view_model/teacher/school_teachers_view_model.dart';

class SchoolTeachersDetailScreen extends StatefulWidget {
  final int teacherId;

  const SchoolTeachersDetailScreen({
    super.key,
    required this.teacherId,
  });

  @override
  State<SchoolTeachersDetailScreen> createState() =>
      _SchoolTeachersDetailScreenState();
}

class _SchoolTeachersDetailScreenState
    extends State<SchoolTeachersDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TeacherDetailViewModel>(context, listen: false)
          .schoolTeachersDetailApi(widget.teacherId, context);
    });
  }

  // ─── Helpers ────────────────────────────────────────────
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.trim().isEmpty) {
      return 'teacher_detail.not_available'.tr();
    }
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    } catch (_) {
      return 'teacher_detail.not_available'.tr();
    }
  }

  String _capitalize(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'teacher_detail.not_available'.tr();
    }
    final v = value.trim();
    return v[0].toUpperCase() + v.substring(1);
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
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) _showErrorSnack('teacher_detail.could_not_open'.tr());
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

  // ════════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('teacher_detail.title'.tr()),
        backgroundColor: AppColor.lightBlueColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<TeacherDetailViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final t = viewModel.schoolTeachersDetailModel?.data;

          if (t == null) {
            return Center(child: Text('teacher_detail.no_data'.tr()));
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
                            child: t.teacherPhotoUrl != null
                                ? Image.network(
                              t.teacherPhotoUrl!,
                              width: 124,
                              height: 124,
                              fit: BoxFit.cover,
                              loadingBuilder: (_, child, progress) =>
                              progress == null
                                  ? child
                                  : const CircularProgressIndicator(
                                  strokeWidth: 2),
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.person,
                                size: 70,
                                color: AppColor.lightBlueColor,
                              ),
                            )
                                : Icon(Icons.person,
                                size: 70, color: AppColor.lightBlueColor),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Name
                        Text(
                          t.name ?? 'teacher_detail.not_available'.tr(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Designation
                        if ((t.designation ?? '').toString().trim().isNotEmpty)
                          Text(
                            _capitalize(t.designation?.toString()),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        const SizedBox(height: 2),

                        // Qualification
                        Text(
                          t.qualification ?? 'teacher_detail.not_available'.tr(),
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white70),
                        ),
                        const SizedBox(height: 12),

                        // Employee ID chip
                        if ((t.employeeId ?? '').toString().trim().isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.badge_outlined,
                                    size: 14, color: Colors.white),
                                const SizedBox(width: 5),
                                Text(
                                  '${'teacher_detail.emp_id_label'.tr()}: ${t.employeeId}',
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
                _buildSection('teacher_detail.personal_information'.tr(), [
                  _buildInfoRow(Icons.person_outline, 'teacher_detail.full_name'.tr(),
                      t.name ?? 'teacher_detail.not_available'.tr()),
                  _buildInfoRow(Icons.email_outlined, 'teacher_detail.email'.tr(),
                      t.userEmail ?? 'teacher_detail.not_available'.tr()),
                  _buildInfoRow(Icons.phone_outlined, 'teacher_detail.mobile'.tr(),
                      t.mobileNumber ?? 'teacher_detail.not_available'.tr()),
                  _buildInfoRow(Icons.wc_rounded, 'teacher_detail.gender'.tr(),
                      _capitalize(t.gender?.toString())),
                  _buildInfoRow(Icons.cake_outlined, 'teacher_detail.date_of_birth'.tr(),
                      _formatDate(t.dob?.toString())),
                  _buildInfoRow(Icons.location_on_outlined, 'teacher_detail.address'.tr(),
                      t.address ?? 'teacher_detail.not_available'.tr()),
                ]),

                // ── Family Information ──────────────────────
                _buildSection('teacher_detail.family_information'.tr(), [
                  _buildInfoRow(
                      Icons.person, 'teacher_detail.father_name'.tr(), t.fatherName ?? 'teacher_detail.not_available'.tr()),
                  _buildInfoRow(
                      Icons.person, 'teacher_detail.mother_name'.tr(), t.motherName ?? 'teacher_detail.not_available'.tr()),
                ]),

                // ── Professional Information ────────────────
                _buildSection('teacher_detail.professional_information'.tr(), [
                  _buildInfoRow(Icons.badge_outlined, 'teacher_detail.employee_id'.tr(),
                      (t.employeeId ?? '').toString().trim().isEmpty
                          ? 'teacher_detail.not_available'.tr()
                          : t.employeeId.toString()),
                  _buildInfoRow(Icons.work_outline, 'teacher_detail.designation'.tr(),
                      _capitalize(t.designation?.toString())),
                  _buildInfoRow(Icons.school_outlined, 'teacher_detail.qualification'.tr(),
                      t.qualification ?? 'teacher_detail.not_available'.tr()),
                  _buildInfoRow(
                      Icons.business_center_outlined, 'teacher_detail.employment_type'.tr(),
                      (t.employmentType ?? '').toString().trim().isEmpty
                          ? 'teacher_detail.not_available'.tr()
                          : _capitalize(t.employmentType?.toString())),
                  _buildInfoRow(Icons.star_outline, 'teacher_detail.experience'.tr(),
                      '${t.experienceYears ?? 0} ${'teacher_detail.years'.tr()}'),
                  _buildInfoRow(Icons.calendar_today_outlined, 'teacher_detail.joining_date'.tr(),
                      _formatDate(t.joiningDate?.toString())),
                ]),

                // ── Documents ──────────────────────────────
                _buildSection('teacher_detail.documents'.tr(), [
                  _buildDocumentCard(
                    title: 'teacher_detail.aadhar_card'.tr(),
                    url: t.aadharCardUrl?.toString(),
                    icon: Icons.credit_card_rounded,
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
                Text(label,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    )),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    )),
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
    final bool hasDoc = url != null && url.trim().isNotEmpty;

    final bool isImage = hasDoc &&
        (url!.toLowerCase().endsWith('.png') ||
            url.toLowerCase().endsWith('.jpg') ||
            url.toLowerCase().endsWith('.jpeg') ||
            url.toLowerCase().endsWith('.webp'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Card row ─────────────────────────────────────
        InkWell(
          onTap: hasDoc
              ? () {
            if (isImage) {
              _openImageViewer(context, url!, title);
            } else {
              _openUrl(url!);
            }
          }
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
                // Icon box
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

                // Text
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
                                ? (isImage
                                ? 'teacher_detail.uploaded_view'.tr()
                                : 'teacher_detail.uploaded_open'.tr())
                                : 'teacher_detail.not_uploaded'.tr(),
                            style: TextStyle(
                              fontSize: 12,
                              color:
                              hasDoc ? Colors.green[700] : Colors.grey,
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
                      isImage
                          ? Icons.image_rounded
                          : Icons.open_in_new_rounded,
                      color: AppColor.lightBlueColor,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),

        // ── Inline image thumbnail (if image) ────────────
        if (isImage) ...[
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
                          const Icon(Icons.broken_image_rounded,
                              size: 40, color: Colors.grey),
                          const SizedBox(height: 8),
                          Text('teacher_detail.image_error'.tr(),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  // Tap overlay hint
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.zoom_out_map_rounded,
                              color: Colors.white, size: 13),
                          const SizedBox(width: 4),
                          Text('teacher_detail.tap_to_expand'.tr(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 11)),
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

  const _ImageViewerScreen({
    required this.imageUrl,
    required this.title,
  });

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

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title,
            style: const TextStyle(fontSize: 16, color: Colors.white)),
        actions: [
          IconButton(
            onPressed: _resetZoom,
            icon: const Icon(Icons.fit_screen_rounded, color: Colors.white),
            tooltip: 'teacher_detail.reset_zoom'.tr(),
          ),
          IconButton(
            onPressed: () async {
              final uri = Uri.parse(widget.imageUrl);
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
            icon: const Icon(Icons.open_in_new_rounded, color: Colors.white),
            tooltip: 'teacher_detail.open_browser'.tr(),
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
                  Text('teacher_detail.loading_image'.tr(),
                      style: const TextStyle(color: Colors.white60, fontSize: 13)),
                ],
              );
            },
            errorBuilder: (_, __, ___) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.broken_image_rounded,
                    size: 60, color: Colors.white54),
                const SizedBox(height: 12),
                Text('teacher_detail.image_error'.tr(),
                    style: const TextStyle(color: Colors.white54)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}