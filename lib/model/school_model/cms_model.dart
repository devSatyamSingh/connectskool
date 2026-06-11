class CmsModel {
  bool? success;
  String? message;
  CmsData? data;

  CmsModel({
    this.success,
    this.message,
    this.data,
  });

  CmsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];

    data = json['data'] != null
        ? CmsData.fromJson(json['data'])
        : null;
  }
}

class CmsData {
  int? total;
  List<CmsPage>? pages;

  CmsData({
    this.total,
    this.pages,
  });

  CmsData.fromJson(Map<String, dynamic> json) {
    total = json['total'];

    if (json['pages'] != null) {
      pages = <CmsPage>[];

      json['pages'].forEach((v) {
        pages!.add(CmsPage.fromJson(v));
      });
    }
  }
}

class CmsPage {
  int? cmsPageId;
  String? pageType;
  String? title;
  String? content;
  int? status;
  String? createdAt;
  String? updatedAt;

  CmsPage({
    this.cmsPageId,
    this.pageType,
    this.title,
    this.content,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  CmsPage.fromJson(Map<String, dynamic> json) {
    cmsPageId = json['cms_page_id'];
    pageType = json['page_type'];
    title = json['title'];
    content = json['content'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}