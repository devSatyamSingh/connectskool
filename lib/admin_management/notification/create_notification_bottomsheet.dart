import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/res/app_button.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/utils/utils.dart';
import 'package:school_pro/view_model/school_view_model/classes/all_classes_view_model.dart';
import 'package:school_pro/view_model/school_view_model/notification/create_notification_view_model.dart';
import 'package:school_pro/model/school_model/student/all_student_list_model.dart';
import 'package:school_pro/model/school_model/teacher/all_teachers_list_model.dart';
import 'package:school_pro/model/school_model/accountant/all_accountant_list_model.dart';
import 'package:school_pro/view_model/school_view_model/student/all_student_list_view_model.dart';
import 'package:school_pro/view_model/school_view_model/accountant/all_accountant_list_view_model.dart';
import '../../../model/school_model/classes/all_classes_model.dart';
import '../../model/school_model/section/all_sections_model.dart';
import '../../view_model/school_view_model/section/all_scetions_view_model.dart';
import '../../view_model/school_view_model/teacher/all_teachers_view_model.dart';

class CreateNotificationBottomSheet extends StatefulWidget {
  const CreateNotificationBottomSheet({super.key});

  @override
  State<CreateNotificationBottomSheet> createState() =>
      _CreateNotificationBottomSheetState();
}

class _CreateNotificationBottomSheetState
    extends State<CreateNotificationBottomSheet> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;
  final List<Map<String, dynamic>> selectedTargets = [];
  Data? selectedClass;
  SectionData? selectedSection;
  String selectedIndividualType = "student";
  final List<String> selectedRoles = [];
  StudentData? selectedStudent;
  AllTeacherModel? selectedTeacher;
  AccountantData? selectedAccountant;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<AllClassesViewModel>(
        context,
        listen: false,
      ).allClassesApi(context);

      Provider.of<AllStudentListVieModel>(
        context,
        listen: false,
      ).allStudentListApi(context);

      Provider.of<AllTeachersListVieModel>(
        context,
        listen: false,
      ).allTeachersListApi(context);

      Provider.of<AllAccountantListVieModel>(
        context,
        listen: false,
      ).allAccountantListApi(context);
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _sendNotification() async {
    if (titleController.text.trim().isEmpty) {
      Utils.show("Please enter notification title", context);
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      Utils.show("Please enter notification description", context);
      return;
    }

    if (selectedTargets.isEmpty) {
      Utils.show("Please add at least one target", context);
      return;
    }

    setState(() {
      isLoading = true;
    });

    final success =
        await Provider.of<CreateNotificationViewModel>(
          context,
          listen: false,
        ).createNotificationApi(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          targets: selectedTargets,
          context: context,
        );

    setState(() {
      isLoading = false;
    });

    if (success && mounted) {

      Utils.show(
        "Notification sent successfully",
        context,
      );

      titleController.clear();

      descriptionController.clear();

      selectedTargets.clear();

      selectedClass = null;
      selectedSection = null;

      selectedStudent = null;
      selectedTeacher = null;
      selectedAccountant = null;

      selectedRoles.clear();

      selectedIndividualType = "student";

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.90, // 90% screen

      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF4F6FB),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(40),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: 12),

              _buildHandle(),

              _buildHeader(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildTitleField(),

                      const SizedBox(height: 16),

                      _buildDescriptionField(),

                      const SizedBox(height: 20),

                      _buildAddTargetButton(),

                      const SizedBox(height: 20),

                      _buildSelectedTargets(),

                      const SizedBox(height: 16),

                      _buildSummaryCard(),

                      const SizedBox(height: 24),

                      AppButton(
                        title: isLoading
                            ? "Sending..."
                            : "Send Notification",
                        loading: isLoading,
                        radius: 16,
                        height: 54,
                        gradient: AppColor.primaryGradient,
                        textColor: Colors.white,
                        icon: Icons.send,
                        onTap: _sendNotification,
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildHandle() {
    return Container(
      width: 44,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(17, 13, 17, 17),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.primary.withOpacity(.12),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColor.primary.withOpacity(.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColor.primary.withOpacity(.30),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create Notification",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Send notifications to students, teachers, accountants or entire school",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColor.sub,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              splashRadius: 20,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          "Notification Title",
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: titleController,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: "Enter notification title",
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey.shade500,
              fontSize: 13,
            ),

            prefixIcon: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.primary.withOpacity(.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.title_rounded,
                color: AppColor.primary,
                size: 20,
              ),
            ),

            filled: true,
            fillColor: Colors.grey.shade50,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColor.primary,
                width: 1.5,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          "Notification Description",
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: descriptionController,
            maxLines: 5,
            minLines: 5,
            textInputAction: TextInputAction.newline,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText:
              "Write your notification message here...",
              hintStyle: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade500,
                height: 1.5,
              ),

              alignLabelWithHint: true,

              prefixIcon: Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 8,
                  top: 12,
                  bottom: 60,
                ),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColor.primary.withOpacity(.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.description_rounded,
                    color: AppColor.primary,
                    size: 20,
                  ),
                ),
              ),

              filled: true,
              fillColor: Colors.grey.shade50,

              contentPadding: const EdgeInsets.fromLTRB(
                16,
                18,
                16,
                18,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: AppColor.primary,
                  width: 1.5,
                ),
              ),

              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 6),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 14,
              color: Colors.grey.shade500,
            ),

            const SizedBox(width: 4),

            Text(
              "Keep message short and clear",
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddTargetButton() {
    return AppButton(
      height: 45,
      title: "Add Target",
      icon: Icons.add_circle_outline_rounded,
      onTap: () {
        _showAddTargetDialog();
      },
    );
  }

  Widget _buildSelectedTargets() {

    if (selectedTargets.isEmpty) {

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColor.primary.withOpacity(.08),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.03),
              blurRadius: 8,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 47,
              width: 47,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColor.primary.withOpacity(.12),
                    AppColor.primary.withOpacity(.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.groups_rounded,
                size: 24,
                color: AppColor.primary,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              "No Recipient Added",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Add one or multiple targets to receive this notification.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 11,
                height: 1.4,
                color: AppColor.sub,
              ),
            ),

          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColor.primary.withOpacity(.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.primary.withOpacity(.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.groups_rounded,
                  size: 16,
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selected Recipients",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Text(
                      "${selectedTargets.length} target(s) added",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColor.sub,
                      ),
                    ),

                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                  AppColor.primary.withOpacity(.08),
                  borderRadius:
                  BorderRadius.circular(30),
                ),
                child: Text(
                  selectedTargets.length.toString(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: AppColor.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              selectedTargets.length,
                  (index) {

                final target =
                selectedTargets[index];

                return _targetPreviewChip(
                  target,
                  index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _targetPreviewChip(Map<String, dynamic> target, int index,) {
    final type = target["target_type"];

    IconData icon;
    Color color;

    switch (type) {
      case "school_wide":
        icon = Icons.public_rounded;
        color = Colors.green;
        break;

      case "class":
        icon = Icons.school_rounded;
        color = Colors.blue;
        break;

      case "class_section":
        icon = Icons.class_rounded;
        color = Colors.orange;
        break;

      case "role_based":
        icon = Icons.groups_rounded;
        color = Colors.purple;
        break;

      case "individual":
        icon = Icons.person_rounded;
        color = Colors.redAccent;
        break;

      default:
        icon = Icons.notifications_active_rounded;
        color = AppColor.primary;
    }

    return Container(
      constraints: const BoxConstraints(
        maxWidth: 280,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(.18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: color,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              target["_display"] ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(width: 8),

          InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              setState(() {
                selectedTargets.removeAt(index);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 16,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.primary.withOpacity(.08),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColor.primary.withOpacity(.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.primary.withOpacity(.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.analytics_rounded,
                  color: AppColor.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Notification Summary",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Review before sending",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColor.sub,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  icon: Icons.groups_rounded,
                  title: "Recipients",
                  value:
                  "${selectedTargets.length}",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryItem(
                  icon:
                  Icons.notifications_active_rounded,
                  title: "Targets",
                  value:
                  "${selectedTargets.length}",
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(.08),
              borderRadius:
              BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 18,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    "Ready to send notification",
                    style:
                    GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight:
                      FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColor.primary,
            size: 15,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: AppColor.sub,
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _showAddTargetDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        String selectedType = "school_wide";

        return StatefulBuilder(
          builder: (context, setSheet) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColor.primary.withOpacity(.08),
                            Colors.white,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: AppColor.primaryGradient,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.group_add_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [

                                Text(
                                  "Add Target Audience",
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                Text(
                                  "Select who should receive this notification",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColor.sub,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _targetChip(
                          title: "School Wide",
                          selected: selectedType == "school_wide",
                          onTap: () {
                            setSheet(() {
                              selectedType = "school_wide";
                            });
                          },
                        ),

                        _targetChip(
                          title: "Class",
                          selected: selectedType == "class",
                          onTap: () {
                            setSheet(() {
                              selectedType = "class";
                            });
                          },
                        ),

                        _targetChip(
                          title: "Class + Section",
                          selected: selectedType == "class_section",
                          onTap: () {
                            setSheet(() {
                              selectedType = "class_section";
                            });
                          },
                        ),

                        _targetChip(
                          title: "Role Based",
                          selected: selectedType == "role_based",
                          onTap: () {
                            setSheet(() {
                              selectedType = "role_based";
                            });
                          },
                        ),

                        _targetChip(
                          title: "Individual",
                          selected: selectedType == "individual",
                          onTap: () {
                            setSheet(() {
                              selectedType = "individual";
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// DYNAMIC FORM
                    _buildTargetForm(selectedType, setSheet),

                    const SizedBox(height: 20),
                    AppButton(title: "Add Target",
                        height: 45,
                        onTap: (){
                      final count = selectedTargets.length;

                      _addTarget(selectedType);

                      if(selectedTargets.length > count){
                        Navigator.pop(context);
                      }
                    }),
                    SizedBox(height: 28,),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _targetChip({required String title, required bool selected, required VoidCallback onTap,}) {
    IconData icon;

    switch (title) {
      case "School Wide":
        icon = Icons.public_rounded;
        break;

      case "Class":
        icon = Icons.school_rounded;
        break;

      case "Class + Section":
        icon = Icons.class_rounded;
        break;

      case "Role Based":
        icon = Icons.groups_rounded;
        break;

      case "Individual":
        icon = Icons.person_rounded;
        break;

      default:
        icon = Icons.notifications_active_rounded;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          gradient: selected
              ? AppColor.primaryGradient
              : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? AppColor.primary.withOpacity(.25)
                  : Colors.black.withOpacity(.03),
              blurRadius: selected ? 15 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withOpacity(.20)
                    : AppColor.primary.withOpacity(.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: selected
                    ? Colors.white
                    : AppColor.primary,
              ),
            ),

            const SizedBox(width: 10),

            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected
                    ? Colors.white
                    : Colors.black87,
              ),
            ),

            if (selected) ...[
              const SizedBox(width: 8),

              const Icon(
                Icons.check_circle_rounded,
                size: 18,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTargetForm(String selectedType, StateSetter setSheet,) {
    switch (selectedType) {

      case "school_wide":

        return _formSection(
          title: "Entire School",
          subtitle: "Send notification to all users",
          icon: Icons.public_rounded,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(.12),
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.public_rounded,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    "Notification will be sent to all students, teachers, accountants and school users.",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

    /// ==========================================
    /// CLASS
    /// ==========================================

      case "class":

        return _formSection(
          title: "Class Notification",
          subtitle: "Send to all sections of a class",
          icon: Icons.school_rounded,
          child: Consumer<AllClassesViewModel>(
            builder: (_, vm, __) {

              return DropdownButtonFormField<Data>(
                value: selectedClass,
                decoration: _dropdownDecoration(
                  "Select Class",
                  Icons.school_rounded,
                ),
                items: vm.allClassesModel?.data
                    ?.map(
                      (e) => DropdownMenuItem<Data>(
                    value: e,
                    child: Text(
                      e.className ?? "",
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                )
                    .toList() ??
                    [],
                onChanged: (value) {
                  setSheet(() {
                    selectedClass = value;
                  });
                },
              );
            },
          ),
        );

    /// ==========================================
    /// CLASS + SECTION
    /// ==========================================

      case "class_section":

        return _formSection(
          title: "Class & Section",
          subtitle: "Send notification to a specific section",
          icon: Icons.class_rounded,
          child: Column(
            children: [

              Consumer<AllClassesViewModel>(
                builder: (_, vm, __) {

                  return DropdownButtonFormField<Data>(
                    value: selectedClass,
                    decoration: _dropdownDecoration(
                      "Select Class",
                      Icons.school_rounded,
                    ),
                    items: vm.allClassesModel?.data
                        ?.map(
                          (e) => DropdownMenuItem<Data>(
                        value: e,
                        child: Text(
                          e.className ?? "",
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    )
                        .toList() ??
                        [],
                    onChanged: (value) async {

                      setSheet(() {
                        selectedClass = value;
                        selectedSection = null;
                      });

                      if (value?.classId != null) {

                        await Provider.of<
                            AllSectionsViewModel>(
                          context,
                          listen: false,
                        ).allSectionsApi(
                          context,
                          value!.classId.toString(),
                        );

                        setSheet(() {});
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              Consumer<AllSectionsViewModel>(
                builder: (_, sectionVm, __) {

                  if (sectionVm.loading) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child:
                        CircularProgressIndicator(),
                      ),
                    );
                  }

                  return DropdownButtonFormField<
                      SectionData>(
                    value: selectedSection,
                    decoration: _dropdownDecoration(
                      "Select Section",
                      Icons.groups_rounded,
                    ),
                    items: sectionVm
                        .allSectionsModel?.data
                        ?.map(
                          (e) => DropdownMenuItem<
                          SectionData>(
                        value: e,
                        child: Text(
                          e.displayName ??
                              e.sectionName ??
                              "",
                          style:
                          GoogleFonts.poppins(),
                        ),
                      ),
                    )
                        .toList() ??
                        [],
                    onChanged: (value) {

                      setSheet(() {
                        selectedSection = value;
                      });

                    },
                  );
                },
              ),
            ],
          ),
        );

    /// ==========================================
    /// ROLE BASED
    /// ==========================================

      case "role_based":

        return _formSection(
          title: "Role Based Notification",
          subtitle:
          "Select one or multiple roles",
          icon: Icons.groups_rounded,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [

              _roleChoiceChip(
                label: "Students",
                value: "student",
                setSheet: setSheet,
              ),

              _roleChoiceChip(
                label: "Teachers",
                value: "teacher",
                setSheet: setSheet,
              ),

              _roleChoiceChip(
                label: "Accountants",
                value: "accountant",
                setSheet: setSheet,
              ),
            ],
          ),
        );

    /// ==========================================
    /// INDIVIDUAL
    /// ==========================================

      case "individual":

        return _formSection(
          title: "Individual User",
          subtitle:
          "Send notification to one user",
          icon: Icons.person_rounded,
          child: Column(
            children: [

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [

                  _individualTypeChip(
                    label: "Student",
                    value: "student",
                    selected:
                    selectedIndividualType,
                    setSheet: setSheet,
                  ),

                  _individualTypeChip(
                    label: "Teacher",
                    value: "teacher",
                    selected:
                    selectedIndividualType,
                    setSheet: setSheet,
                  ),

                  _individualTypeChip(
                    label: "Accountant",
                    value: "accountant",
                    selected:
                    selectedIndividualType,
                    setSheet: setSheet,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _buildIndividualDropdown(
                setSheet,
              ),
            ],
          ),
        );

      default:
        return const SizedBox();
    }
  }

  Widget _formSection({
    required String title,
    required String subtitle,
    required Widget child,
    IconData? icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor.primary.withOpacity(.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: AppColor.primary,
                  ),
                ),

              if (icon != null)
                const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColor.sub,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          child,
        ],
      ),
    );
  }

  InputDecoration _dropdownDecoration(
      String label,
      IconData icon,
      ) {
    return InputDecoration(
      labelText: label,

      labelStyle: GoogleFonts.poppins(
        color: AppColor.sub,
        fontSize: 13,
      ),

      prefixIcon: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColor.primary.withOpacity(.08),
          borderRadius:
          BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppColor.primary,
          size: 20,
        ),
      ),

      filled: true,
      fillColor: Colors.grey.shade50,

      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(18),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(18),
        borderSide: BorderSide(
          color: AppColor.primary,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _roleChoiceChip({required String label, required String value, required StateSetter setSheet,}) {

    final bool isSelected =
    selectedRoles.contains(value);

    IconData icon;

    Color chipColor;

    switch (value) {

      case "student":
        icon = Icons.school_rounded;
        chipColor = Colors.blue;
        break;

      case "teacher":
        icon = Icons.menu_book_rounded;
        chipColor = Colors.green;
        break;

      case "accountant":
        icon = Icons.account_balance_wallet_rounded;
        chipColor = Colors.orange;
        break;

      default:
        icon = Icons.person_rounded;
        chipColor = AppColor.primary;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {

        setSheet(() {

          if (isSelected) {
            selectedRoles.remove(value);
          } else {
            selectedRoles.add(value);
          }

        });

      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 250,
        ),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? chipColor.withOpacity(.10)
              : Colors.white,
          borderRadius:
          BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? chipColor
                : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? chipColor.withOpacity(.15)
                  : Colors.black.withOpacity(.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize:
          MainAxisSize.min,
          children: [

            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: isSelected
                    ? chipColor.withOpacity(.12)
                    : Colors.grey.shade100,
                borderRadius:
                BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: chipColor,
              ),
            ),

            const SizedBox(width: 10),

            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight:
                FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            if (isSelected) ...[
              const SizedBox(width: 8),

              Icon(
                Icons.check_circle_rounded,
                size: 18,
                color: chipColor,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _individualTypeChip({required String label, required String value, required String selected, required StateSetter setSheet,}) {

    final bool isSelected =
        selected == value;

    IconData icon;

    Color chipColor;

    switch (value) {

      case "student":
        icon = Icons.school_rounded;
        chipColor = Colors.blue;
        break;

      case "teacher":
        icon = Icons.menu_book_rounded;
        chipColor = Colors.green;
        break;

      case "accountant":
        icon = Icons.account_balance_wallet_rounded;
        chipColor = Colors.orange;
        break;

      default:
        icon = Icons.person_rounded;
        chipColor = AppColor.primary;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {

        setSheet(() {
          selectedIndividualType = value;
        });

      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 250,
        ),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? chipColor.withOpacity(.10)
              : Colors.white,
          borderRadius:
          BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? chipColor
                : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? chipColor.withOpacity(.15)
                  : Colors.black.withOpacity(.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize:
          MainAxisSize.min,
          children: [

            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: isSelected
                    ? chipColor.withOpacity(.12)
                    : Colors.grey.shade100,
                borderRadius:
                BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: chipColor,
              ),
            ),

            const SizedBox(width: 10),

            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight:
                FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            if (isSelected) ...[
              const SizedBox(width: 8),

              Icon(
                Icons.check_circle_rounded,
                size: 18,
                color: chipColor,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIndividualDropdown(StateSetter setSheet) {

    /// ==========================
    /// STUDENT
    /// ==========================

    if (selectedIndividualType == "student") {
      return Consumer<AllStudentListVieModel>(
        builder: (_, vm, __) {

          if (vm.loading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final students =
              vm.allStudentListModel?.data ?? [];

          if (students.isEmpty) {
            return _emptyUserCard(
              title: "No Students Found",
              icon: Icons.school_rounded,
              color: Colors.blue,
            );
          }

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey.shade200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.03),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: DropdownButtonFormField<StudentData>(
              dropdownColor: Colors.white,
              value: selectedStudent,
              isExpanded: true,

              decoration: _dropdownDecoration(
                "Select Student",
                Icons.school_rounded,
              ),

              items: students.map((e) {
                return DropdownMenuItem<StudentData>(
                  value: e,
                  child: Row(
                    children: [

                      CircleAvatar(
                        radius: 16,
                        backgroundColor:
                        Colors.blue.withOpacity(.10),
                        child: Text(
                          (e.name ?? "S")
                              .substring(0, 1)
                              .toUpperCase(),
                          style: GoogleFonts.poppins(
                            color: Colors.blue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          "${e.name ?? ''} (${e.userId ?? ''})",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),

              onChanged: (value) {
                setSheet(() {
                  selectedStudent = value;
                });
              },
            ),
          );
        },
      );
    }

    /// ==========================
    /// TEACHER
    /// ==========================

    if (selectedIndividualType == "teacher") {
      return Consumer<AllTeachersListVieModel>(
        builder: (_, vm, __) {

          if (vm.loading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final teachers =
              vm.allTeachersListModel?.data ?? [];

          if (teachers.isEmpty) {
            return _emptyUserCard(
              title: "No Teachers Found",
              icon: Icons.menu_book_rounded,
              color: Colors.green,
            );
          }

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey.shade200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.03),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: DropdownButtonFormField<AllTeacherModel>(
              dropdownColor: Colors.white,
              value: selectedTeacher,
              isExpanded: true,
              decoration: _dropdownDecoration(
                "Select Teacher",
                Icons.menu_book_rounded,
              ),

              items: teachers.map((e) {
                return DropdownMenuItem<AllTeacherModel>(
                  value: e,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor:
                        Colors.green.withOpacity(.10),
                        child: Text(
                          (e.name ?? "T")
                              .substring(0, 1)
                              .toUpperCase(),
                          style: GoogleFonts.poppins(
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          "${e.name ?? ''} (${e.userId ?? ''})",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),

              onChanged: (value) {
                setSheet(() {
                  selectedTeacher = value;
                });
              },
            ),
          );
        },
      );
    }

    /// ==========================
    /// ACCOUNTANT
    /// ==========================

    return Consumer<AllAccountantListVieModel>(
      builder: (_, vm, __) {

        if (vm.loading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final accountants =
            vm.allAccountantListModel?.data ?? [];

        if (accountants.isEmpty) {
          return _emptyUserCard(
            title: "No Accountants Found",
            icon: Icons.account_balance_wallet_rounded,
            color: Colors.orange,
          );
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonFormField<AccountantData>(
            dropdownColor: Colors.white,
            value: selectedAccountant,
            isExpanded: true,

            decoration: _dropdownDecoration(
              "Select Accountant",
              Icons.account_balance_wallet_rounded,
            ),

            items: accountants.map((e) {
              return DropdownMenuItem<AccountantData>(
                value: e,
                child: Row(
                  children: [

                    CircleAvatar(
                      radius: 16,
                      backgroundColor:
                      Colors.orange.withOpacity(.10),
                      child: Text(
                        (e.name ?? "A")
                            .substring(0, 1)
                            .toUpperCase(),
                        style: GoogleFonts.poppins(
                          color: Colors.orange,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        "${e.name ?? ''} (${e.userId ?? ''})",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            onChanged: (value) {
              setSheet(() {
                selectedAccountant = value;
              });
            },
          ),
        );
      },
    );
  }


  Widget _emptyUserCard({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(.06),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [

          Icon(
            icon,
            color: color,
            size: 32,
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  void _addTarget(String selectedType) {
    Map<String, dynamic>? target;
    if (selectedType == "school_wide") {
      final alreadyExists = selectedTargets.any(
        (e) => e["target_type"] == "school_wide",
      );

      if (alreadyExists) {
        Utils.show("School wide target already added", context);
        return;
      }

      target = {"target_type": "school_wide", "_display": "Entire School"};
    }
    /// ==========================
    /// CLASS
    /// ==========================
    else if (selectedType == "class") {
      if (selectedClass == null) {
        Utils.show("Please select class", context);
        return;
      }

      final alreadyExists = selectedTargets.any(
        (e) =>
            e["target_type"] == "class" &&
            e["class_id"] == selectedClass!.classId,
      );

      if (alreadyExists) {
        Utils.show("This class already added", context);
        return;
      }

      target = {
        "target_type": "class",
        "class_id": selectedClass!.classId,
        "_display": selectedClass!.className ?? "",
      };
    }
    /// ==========================
    /// CLASS + SECTION
    /// ==========================
    else if (selectedType == "class_section") {
      if (selectedClass == null) {
        Utils.show("Please select class", context);
        return;
      }

      if (selectedSection == null) {
        Utils.show("Please select section", context);
        return;
      }

      final alreadyExists = selectedTargets.any(
        (e) =>
            e["target_type"] == "class_section" &&
            e["class_id"] == selectedClass!.classId &&
            e["section_id"] == selectedSection!.sectionId,
      );

      if (alreadyExists) {
        Utils.show("This class section already added", context);
        return;
      }

      target = {
        "target_type": "class_section",
        "class_id": selectedClass!.classId,
        "section_id": selectedSection!.sectionId,
        "_display": "${selectedClass!.className} - ${selectedSection!.sectionName}",
      };
    }
    /// ==========================
    /// ROLE BASED
    /// ==========================
    else if (selectedType == "role_based") {
      if (selectedRoles.isEmpty) {
        Utils.show("Please select role", context);

        return;
      }

      for (final role in selectedRoles) {
        final alreadyExists = selectedTargets.any(
          (e) => e["target_type"] == "role_based" && e["role"] == role,
        );

        if (!alreadyExists) {
          selectedTargets.add({
            "target_type": "role_based",
            "role": role,
            "_display": role.toUpperCase(),
          });
        }
      }

      setState(() {});

      return;
    }
    /// ==========================
    /// INDIVIDUAL
    /// ==========================
    else if (selectedType == "individual") {
      int? userId;
      String? userName;

      if (selectedIndividualType == "student") {
        if (selectedStudent == null) {
          Utils.show("Please select student", context);

          return;
        }

        userId = selectedStudent!.userId;

        userName = selectedStudent!.name;
      } else if (selectedIndividualType == "teacher") {
        if (selectedTeacher == null) {
          Utils.show("Please select teacher", context);

          return;
        }

        userId = selectedTeacher!.userId;

        userName = selectedTeacher!.name;
      } else {
        if (selectedAccountant == null) {
          Utils.show("Please select accountant", context);

          return;
        }

        userId = selectedAccountant!.userId;

        userName = selectedAccountant!.name;
      }

      final alreadyExists = selectedTargets.any(
        (e) =>
            e["target_type"] == "individual" && e["target_user_id"] == userId,
      );

      if (alreadyExists) {
        Utils.show("User already added", context);

        return;
      }

      target = {
        "target_type": "individual",
        "target_user_id": userId,
        "_display": userName,
      };
    }

    if (target != null) {
      selectedTargets.add(target);

      // Reset selections for next target
      selectedClass = null;
      selectedSection = null;

      selectedStudent = null;
      selectedTeacher = null;
      selectedAccountant = null;

      selectedRoles.clear();

      selectedIndividualType = "student";

      setState(() {});
    }
  }
}
