import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../../../res/app_color.dart';
import '../../../res/const_text.dart';
import '../../model/school_model/settings/cms_model.dart';
import '../../utils/permission_extensions.dart';
import '../../utils/permission_keys.dart';
import '../../view_model/school_view_model/settings/cms_viewmodel.dart';

class CmsScreen extends StatefulWidget {
  final String title;
  final String pageType;

  const CmsScreen({super.key, required this.title, required this.pageType});

  @override
  State<CmsScreen> createState() => _CmsScreenState();
}

class _CmsScreenState extends State<CmsScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<CmsViewModel>(context, listen: false);
      if (vm.cmsModel == null) {
        vm.getCmsPages();
      }
    });
  }

  String cleanHtml(String html) {
    html = html.replaceAll(
      RegExp(r'<style[^>]*>.*?</style>', dotAll: true),
      '',
    );
    html = html.replaceAll(RegExp(r'<head[^>]*>.*?</head>', dotAll: true), '');
    return html;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Consumer<CmsViewModel>(
      builder: (context, vm, child) {
        final CmsPage? page = vm.getPageByType(widget.pageType);

        // ✅ Permission check pehle
        if (!PermissionExtensions.canAccess(PermissionKeys.manageSchoolSettings)) {
          return Scaffold(
            body: Center(
              child: AppText.customText('cms.you_dont_have_permission'.tr()),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColor.bg,
          body: Column(
            children: [
              /// HEADER
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: media.padding.top + 10,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                decoration: const BoxDecoration(
                  gradient: AppColor.primaryGradient,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppText.customText(
                        widget.title,
                        color: Colors.white,
                        size: 18,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              /// BODY
              Expanded(
                child: vm.loading
                    ? const _CmsLoadingView()
                    : page == null
                    ? _buildEmpty()
                    : _buildContent(page),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.article_outlined, size: 52, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          AppText.customText(
            'cms.content_not_available'.tr(),
            size: 15,
            color: AppColor.textGrey,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(CmsPage page) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          /// LAST UPDATED CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.03),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColor.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.schedule, color: AppColor.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.customText(
                        'cms.last_updated'.tr(),
                        size: 12,
                        color: AppColor.textGrey,
                      ),
                      AppText.customText(
                        page.updatedAt ?? "",
                        size: 13,
                        weight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// CONTENT CARD
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.04),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Html(
                  data: cleanHtml(page.content ?? ""),
                  style: {
                    "html": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
                    "body": Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      fontSize: FontSize(14),
                      lineHeight: LineHeight(1.8),
                    ),
                    "header": Style(display: Display.none),
                    "footer": Style(display: Display.none),
                    "style": Style(display: Display.none),
                    "h1": Style(
                      color: AppColor.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize(22),
                    ),
                    "h2": Style(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: FontSize(18),
                    ),
                    "h3": Style(
                      fontWeight: FontWeight.w600,
                      fontSize: FontSize(16),
                    ),
                    "p": Style(
                      fontSize: FontSize(14),
                      lineHeight: LineHeight(1.8),
                      color: Colors.black87,
                    ),
                    "ul": Style(padding: HtmlPaddings.only(left: 18)),
                    "li": Style(
                      lineHeight: LineHeight(1.8),
                      margin: Margins.only(bottom: 8),
                    ),
                    "a": Style(
                      color: AppColor.primary,
                      textDecoration: TextDecoration.underline,
                    ),
                    "strong": Style(fontWeight: FontWeight.bold),
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _CmsLoadingView extends StatelessWidget {
  const _CmsLoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.03), blurRadius: 10),
            ],
          ),
        );
      },
    );
  }
}