import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/view_model/student_view_model/student_profile_view_model.dart';
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

    final studentName = data?.name?.toString() ?? "";
    final studentId = data?.studentId?.toString() ?? "";
    final admissionNo = data?.admissionNo?.toString() ?? "";
    final classId = data?.classId?.toString() ?? "";
    final sectionId = data?.sectionId?.toString() ?? "N/A";
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
    // ✅ NEW
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

            /// 🔹 Header
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
                    child: AppText.customText("Student Profile", size: 19, weight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),

            /// 🔹 Body
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
                          AppText.customText(studentName, size: 22, weight: FontWeight.w700, color: AppColor.text),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(color: AppColor.primaryLight, borderRadius: BorderRadius.circular(20)),
                            child: AppText.customText("Admission No: $admissionNo", size: 13, weight: FontWeight.w500, color: AppColor.primary),
                          ),
                          const SizedBox(height: 8),
                          AppText.customText(
                            "$className * Section $sectionName",
                            size: 14,
                            weight: FontWeight.w500,
                            color: AppColor.sub,
                          ),
                          // AppText.customText("Class $classId • Section $sectionId", size: 14, weight: FontWeight.w500, color: AppColor.sub),
                        ],
                      ),
                    ),

                    /// Personal Info
                    _buildInfoCard("Personal Information", [
                      _InfoItem("Full Name", studentName),
                      _InfoItem("Gender", gender),
                      _InfoItem("Date of Birth", dob),
                      _InfoItem("Religion", religion),
                      _InfoItem("Blood Group", bloodGroup),       // ✅ NEW
                      _InfoItem("Category", category),             // ✅ NEW
                      _InfoItem("Aadhar Number", aadharNumber),   // ✅ NEW
                    ]),
                    const SizedBox(height: 16),

                    /// Academic Info
                    _buildInfoCard("Academic Information", [
                      // _InfoItem("Student ID", studentId),
                      _InfoItem("Class", className),
                      _InfoItem("Section", sectionName),
                      _InfoItem("Academic Year", academicYear),   // ✅ NEW
                    ]),
                    const SizedBox(height: 16),

                    /// Contact Info
                    _buildInfoCard("Contact Information", [
                      _InfoItem("Email", email),
                      _InfoItem("Mobile Number", mobile),
                      _InfoItem("Address", address),
                      _InfoItem("City", city),                           // ✅ NEW
                      _InfoItem("State", state),                         // ✅ NEW
                      _InfoItem("Pincode", pincode),                     // ✅ NEW
                      _InfoItem("Emergency Contact", emergencyContact),  // ✅ NEW
                    ]),
                    const SizedBox(height: 16),

                    /// Guardian Info
                    _buildInfoCard("Guardian Information", [
                      _InfoItem("Father Name", fatherName),
                      _InfoItem("Father Mobile", fatherMobile),         // ✅ NEW
                      _InfoItem("Father Occupation", fatherOccupation), // ✅ NEW
                      _InfoItem("Mother Name", motherName),
                      _InfoItem("Mother Mobile", motherMobile),
                      _InfoItem("Mother Occupation", motherOccupation),
                      _InfoItem("Guardian Name", guardianName),
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
  /// 🔹 Reusable Info Card
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
