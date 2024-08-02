import 'dart:convert';

import 'package:aiinterviewer/models/user_info_mode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String jobId;
  final String jobTitle;
  final String jobDescription;
  final Timestamp createdAt;
  final String createdBy;
  final List<Applicant> applicants;
  final String interviewType;
  String? firstName; // Changed to non-final
  String? lastName;  // Changed to non-final
  UserInfoModel? createdUser;  // Changed to non-final
  final String salaryRange;
  final String jobType;
  final String jobRequirements;
  final String jobBenefits;

  JobModel({
    required this.jobId,
    required this.jobTitle,
    required this.jobDescription,
    required this.createdAt,
    required this.createdBy,
    required this.applicants,
    required this.interviewType,
     this.firstName,
    this.lastName,
    this.createdUser,
    required this.salaryRange,
    required this.jobType,
    required this.jobRequirements,
    required this.jobBenefits,
  });

  factory JobModel.fromJson(Map<String, dynamic> map) {
    return JobModel(
      jobId: map['jobId'],
      jobTitle: map['jobTitle'],
      jobDescription: map['jobDescription'],
      createdAt: map['createdAt'] is Timestamp 
          ? map['createdAt'] as Timestamp 
          : Timestamp.fromDate(DateTime.parse(map['createdAt'])), 
      createdBy: map['createdBy'],
      applicants: (map['applicants'] as List<dynamic>?)?.map((i) => Applicant.fromJson(i as Map<String, dynamic>)).toList() ?? [], 
      interviewType: map['interviewType'],
      firstName: map['firstName'] as String?, // Handle new fields
      lastName: map['lastName'] as String?,  // Handle new fields
      createdUser: map['createdUser'] != null
          ? UserInfoModel.fromJson(map['createdUser'])
          : null,  // Handle potential null value
          salaryRange: map['salaryRange'],
          jobType: map['jobType'],
          jobRequirements: map['jobRequirements'],
          jobBenefits: map['jobBenefits'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'jobTitle': jobTitle,
      'jobDescription': jobDescription,
      'createdAt': createdAt.toDate().toIso8601String(),
      'createdBy': createdBy,
      'applicants': applicants.map((applicant) => applicant.toJson()).toList(),
      'interviewType': interviewType,
      'firstName': firstName, // Serialize new fields
      'lastName': lastName,   // Serialize new fields
      'createdUser': createdUser?.toJson(),  // Handle potential null value
      'salaryRange': salaryRange,
      'jobType': jobType,
      'jobRequirements': jobRequirements,
      'jobBenefits': jobBenefits,
    };
  }

  JobModel copyWith({
    String? jobId,
    String? jobTitle,
    String? jobDescription,
    Timestamp? createdAt,
    String? createdBy,
    List<Applicant>? applicants,
    String? interviewType,
    String? firstName,
    String? lastName,
    UserInfoModel? createdUser,
    String? salaryRange,
    String? jobType,
    String? jobRequirements,
    String? jobBenefits,
  }) {
    return JobModel(
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
      jobDescription: jobDescription ?? this.jobDescription,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      applicants: applicants ?? this.applicants,
      interviewType: interviewType ?? this.interviewType,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      createdUser: createdUser ?? this.createdUser,
      salaryRange: salaryRange ?? this.salaryRange,
      jobType: jobType ?? this.jobType,
      jobRequirements: jobRequirements ?? this.jobRequirements,
      jobBenefits: jobBenefits ?? this.jobBenefits,
    );
  }
}

// class Applicant {
//   final String applicantId;
//   final double average;
//   final String howManyTimes;

//   Applicant({
//     required this.applicantId,
//     required this.average,
//     required this.howManyTimes,
//   });

//   // Convert Applicant to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'applicantId': applicantId,
//       'average': average,
//       'howManyTimes': howManyTimes,
//     };
//   }

//   factory Applicant.fromJson(Map<String, dynamic> json) {
//     return Applicant(
//       applicantId: json['applicantId'] ?? '',
//       average: (json['average'] as num).toDouble(),
//       howManyTimes: json['howManyTimes'] ?? '',
//     );
//   }
// }

class Applicant {
  final String applicantId;
  final double average;
  final String howManyTimes;
  String firstName;
  String lastName;
  String profileUrl;
  String gender;
  String email;
  String currentPosition;

  Applicant({
    required this.applicantId,
    required this.average,
    required this.howManyTimes,
    this.firstName = '',
    this.lastName = '',
    this.profileUrl = '',
    this.gender = '',
    this.email = '',
    this.currentPosition = '',
  });

  // Convert Applicant to JSON
  Map<String, dynamic> toJson() {
    return {
      'applicantId': applicantId,
      'average': average,
      'howManyTimes': howManyTimes,
      'firstName': firstName,
      'lastName': lastName,
      'profileUrl': profileUrl,
      'gender': gender,
      'email': email,
      'currentPosition': currentPosition,
    };
  }

  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      applicantId: json['applicantId'] ?? '',
      average: (json['average'] as num).toDouble(),
      howManyTimes: json['howManyTimes'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profileUrl: json['profileUrl'] ?? '',
      gender: json['gender'] ?? '',
      email: json['email'] ?? '',
      currentPosition: json['currentPosition'] ?? '',
    );
  }
}
