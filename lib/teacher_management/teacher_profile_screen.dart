// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:school_pro/main.dart';
// import 'package:school_pro/view_model/student_view_model/student_profile_view_model.dart';
// import 'package:school_pro/view_model/teacher_view_model/teacher_profile_view_model.dart';
// import '../../res/app_color.dart';
// import '../../res/const_text.dart';
//
// class TeacherProfileScreen extends StatefulWidget {
//   const TeacherProfileScreen({super.key});
//
//   @override
//   State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
// }
//
// class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<TeacherProfileViewModel>(context, listen: false)
//           .teacherProfileApi(context);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final profileVM = Provider.of<TeacherProfileViewModel>(context);
//     final profile = profileVM.teacherProfileModel;
//
//     if (profileVM.loading || profile == null) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     final data = profile.data;
//
//     final studentName = data?.name?.toString() ?? "";
//     final studentId = data?.teacherId?.toString() ?? "";
//     final admissionNo = data?.employeeId?.toString() ?? "";
//     final email = data?.userEmail?.toString() ?? "";
//     final mobile = data?.mobileNumber?.toString() ?? "";
//     final gender = data?.gender?.toString() ?? "";
//     final fatherName = data?.fatherName?.toString() ?? "";
//     final motherName = data?.motherName?.toString() ?? "";
//     final address = data?.address?.toString() ?? "";
//     final photoUrl = data?.teacherPhotoUrl?.toString() ?? "";
//
//     // ✅ NEW
//     final bloodGroup = data?.b?.toString() ?? "";
//     final category = data?.category?.toString() ?? "";
//     final aadharNumber = data?.aadharNumber?.toString() ?? "";
//     final academicYear = data?.academicYear?.toString() ?? "";
//     final fatherOccupation = data?.fatherOccupation?.toString() ?? "";
//     final fatherMobile = data?.fatherMobile?.toString() ?? "";
//     final motherOccupation = data?.motherOccupation?.toString() ?? "";
//     final motherMobile = data?.motherMobile?.toString() ?? "";
//     final guardianName = data?.guardianName?.toString() ?? "";
//     final emergencyContact = data?.emergencyContactNumber?.toString() ?? "";
//     final city = data?.city?.toString() ?? "";
//     final state = data?.state?.toString() ?? "";
//     final pincode = data?.pincode?.toString() ?? "";
//
//     String dob = "";
//     try {
//       if (data?.dob != null) {
//         final date = DateTime.parse(data!.dob.toString());
//         dob = "${date.day}-${date.month}-${date.year}";
//       }
//     } catch (_) {}
//
//     return Scaffold(
//       backgroundColor: AppColor.bg,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//
//           /// 🔹 Header
//           Container(
//             padding: const EdgeInsets.fromLTRB(12, 50, 20, 22),
//             decoration: BoxDecoration(
//               gradient: AppColor.primaryGradient,
//               borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
//               boxShadow: [BoxShadow(color: AppColor.blueShadow, blurRadius: 18, offset: const Offset(0, 10))],
//             ),
//             child: Row(
//               children: [
//                 InkWell(
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(color: AppColor.glassWhite, shape: BoxShape.circle),
//                     child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: AppText.customText("Student Profile", size: 19, weight: FontWeight.bold, color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//
//           /// 🔹 Body
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//
//                   /// Profile Card
//                   Container(
//                     margin: const EdgeInsets.all(16),
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: AppColor.card,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [BoxShadow(color: AppColor.cardShadow, blurRadius: 20, offset: const Offset(0, 4))],
//                     ),
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 50,
//                           backgroundColor: AppColor.primaryLight,
//                           backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
//                           child: photoUrl.isEmpty ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
//                         ),
//                         const SizedBox(height: 16),
//                         AppText.customText(studentName, size: 22, weight: FontWeight.w700, color: AppColor.text),
//                         const SizedBox(height: 6),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//                           decoration: BoxDecoration(color: AppColor.primaryLight, borderRadius: BorderRadius.circular(20)),
//                           child: AppText.customText("Admission No: $admissionNo", size: 13, weight: FontWeight.w500, color: AppColor.primary),
//                         ),
//                         const SizedBox(height: 8),
//                         AppText.customText("Class $classId • Section $sectionId", size: 14, weight: FontWeight.w500, color: AppColor.sub),
//                       ],
//                     ),
//                   ),
//
//                   /// Personal Info
//                   _buildInfoCard("Personal Information", [
//                     _InfoItem("Full Name", studentName),
//                     _InfoItem("Gender", gender),
//                     _InfoItem("Date of Birth", dob),
//                     _InfoItem("Religion", religion),
//                     _InfoItem("Blood Group", bloodGroup),       // ✅ NEW
//                     _InfoItem("Category", category),             // ✅ NEW
//                     _InfoItem("Aadhar Number", aadharNumber),   // ✅ NEW
//                   ]),
//                   const SizedBox(height: 16),
//
//                   /// Academic Info
//                   _buildInfoCard("Academic Information", [
//                     _InfoItem("Student ID", studentId),
//                     _InfoItem("Class ID", classId),
//                     _InfoItem("Section ID", sectionId),
//                     _InfoItem("Academic Year", academicYear),   // ✅ NEW
//                   ]),
//                   const SizedBox(height: 16),
//
//                   /// Contact Info
//                   _buildInfoCard("Contact Information", [
//                     _InfoItem("Email", email),
//                     _InfoItem("Mobile Number", mobile),
//                     _InfoItem("Address", address),
//                     _InfoItem("City", city),                           // ✅ NEW
//                     _InfoItem("State", state),                         // ✅ NEW
//                     _InfoItem("Pincode", pincode),                     // ✅ NEW
//                     _InfoItem("Emergency Contact", emergencyContact),  // ✅ NEW
//                   ]),
//                   const SizedBox(height: 16),
//
//                   /// Guardian Info
//                   _buildInfoCard("Guardian Information", [
//                     _InfoItem("Father Name", fatherName),
//                     _InfoItem("Father Mobile", fatherMobile),         // ✅ NEW
//                     _InfoItem("Father Occupation", fatherOccupation), // ✅ NEW
//                     _InfoItem("Mother Name", motherName),
//                     _InfoItem("Mother Mobile", motherMobile),         // ✅ NEW
//                     _InfoItem("Mother Occupation", motherOccupation), // ✅ NEW
//                     _InfoItem("Guardian Name", guardianName),         // ✅ NEW
//                   ]),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: screenHeight * 0.04),
//         ],
//       ),
//     );
//   }
//   /// 🔹 Reusable Info Card
//   Widget _buildInfoCard(String title, List<_InfoItem> items) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: AppColor.card,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: AppColor.cardShadow,
//             blurRadius: 20,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           AppText.customText(
//             title,
//             size: 16,
//             weight: FontWeight.w600,
//             color: AppColor.text,
//           ),
//
//           const SizedBox(height: 16),
//
//           ...items.map((item) => Padding(
//             padding: const EdgeInsets.only(bottom: 14),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: AppText.customText(
//                     item.label,
//                     size: 13,
//                     weight: FontWeight.w500,
//                     color: AppColor.sub,
//                   ),
//                 ),
//                 Expanded(
//                   child: AppText.customText(
//                     item.value,
//                     size: 14,
//                     weight: FontWeight.w600,
//                     color: AppColor.text,
//                     align: TextAlign.end,
//                   ),
//                 ),
//               ],
//             ),
//           )),
//         ],
//       ),
//     );
//   }
// }
//
// class _InfoItem {
//   final String label;
//   final String value;
//
//   _InfoItem(this.label, this.value);
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../res/app_color.dart';
import '../../res/const_text.dart';
import '../../view_model/teacher_view_model/teacher_profile_view_model.dart';
import '../utils/permission_extensions.dart';
import '../utils/permission_keys.dart';
import '../utils/utils.dart';

class TeacherProfileScreen extends StatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      if(
      !PermissionExtensions.canAccess(
        PermissionKeys.viewOneTeacherProfile,
      )
      ){

        Utils.show(
          "Your profile access has been disabled by administrator.",
          context,
          type: "warning",
        );

        Navigator.pop(context);
        return;
      }

      Provider.of<TeacherProfileViewModel>(
        context,
        listen: false,
      ).teacherProfileApi(context);
    });
  }
  String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) => word.isEmpty ? word : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
  @override
  @override
  Widget build(BuildContext context) {
    final profileVM = Provider.of<TeacherProfileViewModel>(context);
    final profile = profileVM.teacherProfileModel;
    final data = profile?.data;

    // ── Basic fields ──────────────────────────────────────────────
    final name         = capitalizeWords(data?.name?.toString() ?? "");
    final fatherName   = capitalizeWords(data?.fatherName?.toString() ?? "");
    final motherName   = capitalizeWords(data?.motherName?.toString() ?? "");
    final designation  = capitalizeWords(data?.designation?.toString() ?? "");
    final qualification= capitalizeWords(data?.qualification?.toString() ?? "");
    final employmentType = capitalizeWords(data?.employmentType?.toString() ?? "");
    final gender       = capitalizeWords(data?.gender?.toString() ?? "");
    final address      = capitalizeWords(data?.address?.toString() ?? "");
    final employeeId      = data?.employeeId?.toString()      ?? "";
    final email           = data?.userEmail?.toString()       ?? "";
    final mobile          = data?.mobileNumber?.toString()    ?? "";
    final experienceYears = data?.experienceYears?.toString() ?? "";
    final photoUrl        = data?.teacherPhotoUrl?.toString() ?? "";

    String formatDate(dynamic raw) {
      try {
        if (raw == null) return "";
        final date = DateTime.parse(raw.toString()).toLocal();
        return "${date.day}-${date.month}-${date.year}";
      } catch (_) {
        return "";
      }
    }

    final dob         = formatDate(data?.dob);
    final joiningDate = formatDate(data?.joiningDate);



    return Scaffold(
      backgroundColor: AppColor.bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

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
                  child: AppText.customText("Teacher Profile", size: 19, weight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),

          // ── Body: loader ya content ───────────────────────────
          Expanded(
            child: profileVM.loading || profile == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              child: Column(
                children: [

                  // Profile Card
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
                          child: photoUrl.isEmpty
                              ? const Icon(Icons.person, size: 50, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(height: 16),
                        AppText.customText(name, size: 22, weight: FontWeight.w700, color: AppColor.text),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(color: AppColor.primaryLight, borderRadius: BorderRadius.circular(20)),
                          child: AppText.customText("Emp ID: $employeeId", size: 13, weight: FontWeight.w500, color: AppColor.primary),
                        ),
                        const SizedBox(height: 8),
                        AppText.customText(designation, size: 14, weight: FontWeight.w500, color: AppColor.sub),
                      ],
                    ),
                  ),

                  // Personal Information
                  _buildInfoCard("Personal Information", [
                    _InfoItem("Full Name",     name),
                    _InfoItem("Gender",        gender),
                    _InfoItem("Date of Birth", dob),
                    _InfoItem("Father Name",   fatherName),
                    _InfoItem("Mother Name",   motherName),
                  ]),
                  const SizedBox(height: 16),

                  // Professional Information
                  _buildInfoCard("Professional Information", [
                    _InfoItem("Employee ID",      employeeId),
                    _InfoItem("Designation",      designation),
                    _InfoItem("Qualification",    qualification),
                    _InfoItem("Employment Type",  employmentType),
                    _InfoItem("Experience (yrs)", experienceYears),
                    _InfoItem("Joining Date",     joiningDate),
                  ]),
                  const SizedBox(height: 16),

                  // Contact Information
                  _buildInfoCard("Contact Information", [
                    _InfoItem("Email",   email),
                    _InfoItem("Mobile",  mobile),
                    _InfoItem("Address", address),
                  ]),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildInfoCard(String title, List<_InfoItem> items) {
    // Filter out empty values — no point showing blank rows
    final filled = items.where((e) => e.value.isNotEmpty).toList();
    if (filled.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColor.cardShadow, blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.customText(title, size: 16, weight: FontWeight.w600, color: AppColor.text),
          const SizedBox(height: 16),
          ...filled.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                Expanded(
                  child: AppText.customText(item.label, size: 13, weight: FontWeight.w500, color: AppColor.sub),
                ),
                Expanded(
                  child: AppText.customText(item.value, size: 14, weight: FontWeight.w600, color: AppColor.text, align: TextAlign.end),
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