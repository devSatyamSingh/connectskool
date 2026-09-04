import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/view_model/student_view_model/student_profile_view_model.dart';
import 'package:easy_localization/easy_localization.dart';  // ← ADD THIS

import '../../res/app_color.dart';
import '../../res/const_text.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentProfileViewModel>(context, listen: false)
          .studentProfileApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileVM = Provider.of<StudentProfileViewModel>(context);
    final profile = profileVM.studentProfileModel;

    if (profileVM.loading || profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final data = profile.data;

    final studentName = data?.name?.toString() ?? "student_profile.not_available".tr();
    final studentId = data?.studentId?.toString() ?? "";
    final admissionNo = data?.admissionNo?.toString() ?? "";
    final classId = data?.classId?.toString() ?? "";
    final sectionId = data?.sectionId?.toString() ?? "";
    final email = data?.userEmail?.toString() ?? "";
    final mobile = data?.mobileNumber?.toString() ?? "";
    final gender = data?.gender?.toString() ?? "";
    final religion = data?.religion?.toString() ?? "";
    final fatherName = data?.fatherName?.toString() ?? "";
    final motherName = data?.motherName?.toString() ?? "";
    final address = data?.address?.toString() ?? "";
    final photoUrl = data?.studentPhotoUrl?.toString() ?? "";
    final className = data?.className?.toString() ?? "";
    final sectionName = data?.sectionName?.toString() ?? "";
    final bloodGroup = data?.bloodGroup?.toString() ?? "";
    final category = data?.category?.toString() ?? "";
    final aadharNumber = data?.aadharNumber?.toString() ?? "";
    final academicYear = data?.academicYear?.toString() ?? "";
    final fatherOccupation = data?.fatherOccupation?.toString() ?? "";
    final fatherMobile = data?.fatherMobile?.toString() ?? "";
    final motherOccupation = data?.motherOccupation?.toString() ?? "";
    final motherMobile = data?.motherMobile?.toString() ?? "";
    final guardianName = data?.guardianName?.toString() ?? "";
    final emergencyContact = data?.emergencyContactNumber?.toString() ?? "";
    final city = data?.city?.toString() ?? "";
    final state = data?.state?.toString() ?? "";
    final pincode = data?.pincode?.toString() ?? "";

    String dob = "";
    try {
      if (data?.dob != null) {
        final date = DateTime.parse(data!.dob.toString());
        dob = "${date.day}-${date.month}-${date.year}";
      }
    } catch (_) {}

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColor.bg,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Header
            Container(
              padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
              decoration: BoxDecoration(
                gradient: AppColor.primaryGradient,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                boxShadow: [BoxShadow(color: AppColor.blueShadow, blurRadius: 18, offset: const Offset(0, 10))],
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColor.glassWhite, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppText.customText(
                      'student_profile.title'.tr(),
                      size: 19,
                      weight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            /// Body
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// Profile Card
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColor.card,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: AppColor.cardShadow, blurRadius: 20, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColor.primaryLight,
                            backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                            child: photoUrl.isEmpty ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
                          ),
                          const SizedBox(height: 16),
                          AppText.customText(
                            studentName,
                            size: 22,
                            weight: FontWeight.w700,
                            color: AppColor.text,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColor.primaryLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: AppText.customText(
                              admissionNo.isNotEmpty
                                  ? 'student_profile.admission_no'.tr(
                                  namedArgs: {'number': admissionNo}
                              )
                                  : 'student_profile.not_available'.tr(),
                              size: 13,
                              weight: FontWeight.w500,
                              color: AppColor.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          AppText.customText(
                            'student_profile.class_section'.tr(
                                namedArgs: {
                                  'className': className.isNotEmpty ? className : 'student_profile.not_available'.tr(),
                                  'sectionName': sectionName.isNotEmpty ? sectionName : 'student_profile.not_available'.tr(),
                                }
                            ),
                            size: 14,
                            weight: FontWeight.w500,
                            color: AppColor.sub,
                          ),
                        ],
                      ),
                    ),

                    /// Personal Info
                    _buildInfoCard('student_profile.personal_information'.tr(), [
                      _InfoItem('student_profile.full_name'.tr(), studentName),
                      _InfoItem('student_profile.gender'.tr(), gender.isNotEmpty ? gender : 'student_profile.not_available'.tr()),
                      _InfoItem('student_profile.date_of_birth'.tr(), dob.isNotEmpty ? dob : 'student_profile.not_available'.tr()),
                      _InfoItem('student_profile.religion'.tr(), religion.isNotEmpty ? religion : 'student_profile.not_available'.tr()),
                      _InfoItem('student_profile.blood_group'.tr(), bloodGroup.isNotEmpty ? bloodGroup : 'student_profile.not_available'.tr()),
                      _InfoItem('student_profile.category'.tr(), category.isNotEmpty ? category : 'student_profile.not_available'.tr()),
                      _InfoItem('student_profile.aadhar_number'.tr(), aadharNumber.isNotEmpty ? aadharNumber : 'student_profile.not_available'.tr()),
                    ]),
                    const SizedBox(height: 16),

                    /// Academic Info
                    _buildInfoCard('student_profile.academic_information'.tr(), [
                      _InfoItem('student_profile.class'.tr(), className.isNotEmpty ? className : 'student_profile.not_available'.tr()),
                      _InfoItem('student_profile.section'.tr(), sectionName.isNotEmpty ? sectionName : 'student_profile.not_available'.tr()),
                      _InfoItem('student_profile.academic_year'.tr(), academicYear.isNotEmpty ? academicYear : 'student_profile.not_available'.tr()),
                    ]),
                    const SizedBox(height: 16),

                    /// Contact Info
                    _buildInfoCard('student_profile.contact_information'.tr(), [
                      _InfoItem('student_profile.email'.tr(), email.isNotEmpty ? email : 'student_profile.not_available'.tr()),
                      _InfoItem('student_profile.mobile_number'.tr(), mobile.isNotEmpty ? mobile : 'student_profile.not_available'.tr()),
                      _InfoItem('student_profile.address'.tr(), address.isNotEmpty ? address : 'student_profile.not_available'.tr()),
                      _InfoItem('student_profile.city'.tr(), city.isNotEmpty ? city : 'student_profile.not_available'.tr()),
                      _InfoItem('student_profile.state'.tr(), state.isNotEmpty ? state : 'student_profile.not_available'.tr()),
                      _InfoItem('student_profile.pincode'.tr(), pincode.isNotEmpty ? pincode : 'student_profile.not_available'.tr()),
                      _InfoItem('student_profile.emergency_contact'.tr(), emergencyContact.isNotEmpty ? emergencyContact : 'student_profile.not_available'.tr()),
                    ]),
                    const SizedBox(height: 16),

                    /// Guardian Info
                    _buildInfoCard('student_profile.guardian_information'.tr(), [
                      _InfoItem('student_profile.father_name'.tr(), fatherName.isNotEmpty ? fatherName : 'student_profile.not_available'.tr()),
                      _InfoItem('student_profile.father_mobile'.tr(), fatherMobile.isNotEmpty ? fatherMobile : 'student_profile.not_available'.tr()),
                      _InfoItem('student_profile.father_occupation'.tr(), fatherOccupation.isNotEmpty ? fatherOccupation : 'student_profile.not_available'.tr()),
                      _InfoItem('student_profile.mother_name'.tr(), motherName.isNotEmpty ? motherName : 'student_profile.not_available'.tr()),
                      _InfoItem('student_profile.mother_mobile'.tr(), motherMobile.isNotEmpty ? motherMobile : 'student_profile.not_available'.tr()),
                      _InfoItem('student_profile.mother_occupation'.tr(), motherOccupation.isNotEmpty ? motherOccupation : 'student_profile.not_available'.tr()),
                      _InfoItem('student_profile.guardian_name'.tr(), guardianName.isNotEmpty ? guardianName : 'student_profile.not_available'.tr()),
                    ]),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
          ],
        ),
      ),
    );
  }

  /// Reusable Info Card
  Widget _buildInfoCard(String title, List<_InfoItem> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadow,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.customText(
            title,
            size: 16,
            weight: FontWeight.w600,
            color: AppColor.text,
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                Expanded(
                  child: AppText.customText(
                    item.label,
                    size: 13,
                    weight: FontWeight.w500,
                    color: AppColor.sub,
                  ),
                ),
                Expanded(
                  child: AppText.customText(
                    item.value,
                    size: 14,
                    weight: FontWeight.w600,
                    color: AppColor.text,
                    align: TextAlign.end,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;

  _InfoItem(this.label, this.value);
}