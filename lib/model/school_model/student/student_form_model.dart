import 'dart:io';

/// Holds all form data for Add / Edit student.
/// Kept separate from API response models.
class StudentFormModel {
  final String name;
  final String email;
  final String password; // empty string = keep existing (edit mode)
  final String classId;
  final String sectionId;
  final String admissionNo;
  final String gender;
  final String academicYear;
  final String rollNo;
  final String dob;
  final String mobileNumber;
  final String fatherName;
  final String motherName;
  final String address;
  final String religion;
  final String passedOut;
  final String transfer;
  final String bloodGroup;
  final String category;
  final String aadharNumber;
  final String fatherOccupation;
  final String fatherMobile;
  final String motherOccupation;
  final String motherMobile;
  final String guardianName;
  final String emergencyContactNumber;
  final String city;
  final String state;
  final String pincode;

  // Only used on Add — read-only on Edit
  final List<String> selectedFeeHeadIds;

  // Optional file uploads
  final File? studentPhoto;
  final File? aadharCard;
  final File? fatherPhoto;
  final File? motherPhoto;

  const StudentFormModel({
    required this.name,
    required this.email,
    required this.password,
    required this.classId,
    required this.sectionId,
    required this.admissionNo,
    required this.gender,
    required this.academicYear,
    required this.rollNo,
    required this.dob,
    required this.mobileNumber,
    required this.fatherName,
    required this.motherName,
    required this.address,
    required this.religion,
    required this.passedOut,
    required this.transfer,
    required this.bloodGroup,
    required this.category,
    required this.aadharNumber,
    required this.fatherOccupation,
    required this.fatherMobile,
    required this.motherOccupation,
    required this.motherMobile,
    required this.guardianName,
    required this.emergencyContactNumber,
    required this.city,
    required this.state,
    required this.pincode,
    this.selectedFeeHeadIds = const [],
    this.studentPhoto,
    this.aadharCard,
    this.fatherPhoto,
    this.motherPhoto,
  });
}