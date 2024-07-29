import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String jobId;
  final String jobTitle;
  final String jobDescription;
  final Timestamp createdAt;
  final String createdBy;
  final List<Applicant> applicants;
  final String interviewType;

  JobModel({
    required this.jobId,
    required this.jobTitle,
    required this.jobDescription,
    required this.createdAt,
    required this.createdBy,
    required this.applicants,
    required this.interviewType,
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
    };
  }
}

class Applicant {
  final String applicantId;
  final double average;
  final String howManyTimes;

  Applicant({
    required this.applicantId,
    required this.average,
    required this.howManyTimes,
  });

  // Convert Applicant to JSON
  Map<String, dynamic> toJson() {
    return {
      'applicantId': applicantId,
      'average': average,
      'howManyTimes': howManyTimes,
    };
  }

  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      applicantId: json['applicantId'] ?? '',
      average: (json['average'] as num).toDouble(),
      howManyTimes: json['howManyTimes'] ?? '',
    );
  }
}