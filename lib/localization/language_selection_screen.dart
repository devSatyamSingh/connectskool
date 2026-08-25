import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../res/app_color.dart';
import 'app_locals.dart';
import 'lanaguge_model.dart';
import 'language_provider.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final languageProvider = context.watch<LanguageProvider>();
    final currentCode = languageProvider.locale.languageCode;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        backgroundColor: AppColor.lightBlueColor,
        elevation: 0,
        title: Text(
          'common.select_language'.tr(),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.02,
          ),
          itemCount: AppLocales.languages.length,
          separatorBuilder: (_, __) => SizedBox(height: size.height * 0.015),
          itemBuilder: (context, index) {
            final LanguageModel lang = AppLocales.languages[index];
            final bool isSelected = lang.code == currentCode;

            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                await context.read<LanguageProvider>().changeLanguage(
                  context,
                  Locale(lang.code),
                );
                if (context.mounted) Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.045,
                  vertical: size.height * 0.018,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColor.lightBlueColor
                        : Colors.grey.shade300,
                    width: isSelected ? 1.4 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang.nativeName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lang.name,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      color: isSelected
                          ? AppColor.lightBlueColor
                          : Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}