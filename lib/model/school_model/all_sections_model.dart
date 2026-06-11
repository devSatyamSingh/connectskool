class AllSectionsModel {
  final bool? success;
  final List<SectionData>? data;

  AllSectionsModel({
    this.success,
    this.data,
  });

  factory AllSectionsModel.fromJson(Map<String, dynamic> json) {
    return AllSectionsModel(
      success: json['success'],
      data: json['data'] != null
          ? List<SectionData>.from(
          json['data'].map((x) => SectionData.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": data?.map((x) => x.toJson()).toList(),
    };
  }
}

class SectionData {
  final int? sectionId;
  final int? classId;
  final String? sectionName;
  final int? capacity;
  final int? currentStudents;
  final String? displayName;
  final int? full;

  SectionData({
    this.sectionId,
    this.classId,
    this.sectionName,
    this.capacity,
    this.currentStudents,
    this.displayName,
    this.full,
  });

  factory SectionData.fromJson(Map<String, dynamic> json) {
    return SectionData(
      sectionId: json['section_id'],
      classId: json['class_id'],
      sectionName: json['section_name'],
      capacity: json['capacity'],
      currentStudents: json['current_students'],
      displayName: json['display_name'],
      full: json['full'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "section_id": sectionId,
      "class_id": classId,
      "section_name": sectionName,
      "capacity": capacity,
      "current_students": currentStudents,
      "display_name": displayName,
      "full": full,
    };
  }
}