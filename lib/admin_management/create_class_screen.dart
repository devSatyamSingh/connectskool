import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/main.dart';
import 'package:school_pro/utils/utils.dart';
import 'package:school_pro/view_model/school_view_model/create_classes_view_model.dart';
import '../res/app_button.dart';
import '../res/app_color.dart';
import '../res/app_text_field.dart';
import '../res/const_text.dart';

class CreateClassScreen extends StatefulWidget {
  const CreateClassScreen({super.key});

  @override
  State<CreateClassScreen> createState() => _CreateClassScreenState();
}

class _CreateClassScreenState extends State<CreateClassScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _orderController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _orderController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _submitClass() {
    final createClass = Provider.of<CreateClassesViewModel>(context,listen: false);

    final name = _nameController.text.trim();
    final orderText = _orderController.text.trim();
    final details = _detailsController.text.trim();

    if (name.isEmpty || orderText.isEmpty) {
      Utils.show("Please fill all required fields", context);
      return;
    }
createClass.createClassApi(name, orderText, details, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.pageBgColor,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.lightBlueColor,
                  AppColor.lightBlueColor.withOpacity(0.85),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.lightBlueColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppText.customText(
                    "Create Class",
                    size: 19,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.06,vertical: screenHeight*0.03),
              child: Column(
                children: [
                  AppTextField(
                    controller: _nameController,
                    label: "Class Name",
                  ),
                   SizedBox(height: screenHeight*0.03),
                  AppTextField(
                    controller: _orderController,
                    label: "Class Order",
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: screenHeight*0.03),
                  AppTextField(
                    controller: _detailsController,
                    label: "Class Details",
                    // maxLines: 3,
                  ),
                 Spacer(),
                  AppButton(
                    title: "Add Class",
                    onTap: _submitClass,
                  ),
                  SizedBox(height: screenHeight*0.04),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
