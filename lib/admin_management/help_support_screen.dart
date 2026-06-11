import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../res/app_color.dart';
import '../../res/const_text.dart';
import '../../utils/utils.dart';
import '../../view_model/school_view_model/help_support_viewmodel.dart';
import '../res/app_button.dart';
import '../res/app_text_field.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _formKey = GlobalKey<FormState>();

  bool ticketSubmitted = false;

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitTicket() async {
    final title = _titleController.text.trim();

    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      Utils.show("Please enter issue title", context, type: "warning");
      return;
    }

    if (description.isEmpty) {
      Utils.show("Please enter description", context, type: "warning");
      return;
    }

    if (description.length < 10) {
      Utils.show("Description is too short", context, type: "warning");
      return;
    }

    final vm = context.read<SupportTicketViewModel>();

    final success = await vm.createSupportTicket(
      context: context,
      title: title,
      description: description,
    );

    if (success) {
      _titleController.clear();
      _descriptionController.clear();

      setState(() {
        ticketSubmitted = true;
      });

      Utils.show(
        "Support ticket submitted successfully",
        context,
        type: "success",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SupportTicketViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: AppColor.bg,

          body: Column(
            children: [
              /// HEADER
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  10,
                  MediaQuery.of(context).padding.top + 12,
                  10,
                  20,
                ),
                decoration: const BoxDecoration(
                  gradient: AppColor.primaryGradient,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                        SizedBox(width: 13),
                        AppText.customText(
                          "Help & Support",
                          color: Colors.white,
                          size: 16,
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(.15),
                      ),
                      child: const Icon(
                        Icons.support_agent_rounded,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 13),
                    AppText.customText(
                      "Need Help?",
                      color: Colors.white,
                      size: 20,
                      weight: FontWeight.w500,
                    ),
                    const SizedBox(height: 8),
                    AppText.customText(
                      "Facing an issue?\nCreate a ticket and our team will assist you.",
                      color: Colors.white70,
                      size: 12,
                      align: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: ticketSubmitted
                      ? _successWidget(vm)
                      : Column(
                    children: [
                      /// FORM CARD
                      Transform.translate(
                        offset: const Offset(0, -2),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.lightBlueColor.withOpacity(.08),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [

                              AppTextField(
                                controller: _titleController,
                                label: "Issue Title",
                                hint: "e.g. Attendance not updating",
                                prefix: const Icon(Icons.title_rounded),
                              ),

                              const SizedBox(height: 18),

                              AppTextField(
                                controller: _descriptionController,
                                label: "Description",
                                hint: "Please describe your issue in detail...",
                                minLines: 5,
                                prefix: const Padding(
                                  padding: EdgeInsets.only(bottom: 95),
                                  child: Icon(Icons.description_outlined),
                                ),
                              ),

                              const SizedBox(height: 20),

                              AppButton(
                                title: "Submit Ticket",
                                icon: Icons.send_rounded,
                                loading: vm.loading,
                                onTap: _submitTicket,
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColor.border,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.schedule_rounded,
                                color:
                                Colors.orange.shade700,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [

                                  AppText.customText(
                                    "Response Time",
                                    weight:
                                    FontWeight.w600,
                                    size: 14,
                                  ),

                                  const SizedBox(height: 4),

                                  AppText.customText(
                                    "Most support requests are resolved within 24 business hours.",
                                    size: 12,
                                    color:
                                    AppColor.textGrey,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _successWidget(
      SupportTicketViewModel vm,
      ) {
    return Container(
      margin: const EdgeInsets.only(
        top: 25,
      ),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [

          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
              Colors.green.withOpacity(.08),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 60,
            ),
          ),

          const SizedBox(height: 25),

          Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius:
              BorderRadius.circular(12),
            ),
            child: AppText.customText(
              "Ticket ID #${vm.ticketModel?.data?.supportTicketId ?? ''}",
              color: Colors.green,
              weight: FontWeight.w600,
              size: 14,
            ),
          ),

          const SizedBox(height: 20),

          AppText.customText(
            "Thank You!",
            size: 28,
            weight: FontWeight.bold,
            align: TextAlign.center,
          ),

          const SizedBox(height: 14),

          AppText.customText(
            "Your support ticket has been created successfully.\n\nOur support team will review your issue and get back to you within 24 business hours.",
            align: TextAlign.center,
            size: 14,
            color: AppColor.textGrey,
          ),

          const SizedBox(height: 30),

          AppButton(
            title: "Submit Another Ticket",
            icon: Icons.refresh_rounded,
            onTap: () {
              setState(() {
                ticketSubmitted = false;
              });

              _titleController.clear();
              _descriptionController.clear();
            },
          ),
        ],
      ),
    );
  }
}
