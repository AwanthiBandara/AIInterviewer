import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String userType;
  final Timestamp birthday;
  final String profileUrl;
  final String gender;
  final String currentPosition;
  final String companyLogoUrl;
  final String companyName;
  final String companyLocation;
  final String companySize;
  final String aboutCompany;

  UserInfoModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.userType,
    required this.birthday,
    required this.profileUrl,
    required this.gender,
    required this.currentPosition,
    required this.companyLogoUrl,
    required this.companyName,
    required this.companyLocation,
    required this.companySize,
    required this.aboutCompany,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      userType: json['userType'] as String,
      birthday: json['birthday'] is Timestamp 
          ? json['birthday'] as Timestamp 
          : Timestamp.fromDate(DateTime.parse(json['birthday'])), // Handle both Timestamp and ISO8601
      profileUrl: json['profileUrl'] as String,
      gender: json['gender'] as String,
      currentPosition: json['currentPosition'] as String,
      companyLogoUrl: json['companyLogoUrl'] as String,
      companyName: json['companyName'] as String,
      companyLocation: json['companyLocation'] as String,
      companySize: json['companySize'] as String,
      aboutCompany: json['aboutCompany'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'userType': userType,
      'birthday': birthday.toDate().toIso8601String(), // Convert Timestamp to ISO 8601 string
      'profileUrl': profileUrl,
      'gender': gender,
      'currentPosition': currentPosition,
      'companyLogoUrl': companyLogoUrl,
      'companyName': companyName,
      'companyLocation': companyLocation,
      'companySize': companySize,
      'aboutCompany': aboutCompany,
    };
  }

  UserInfoModel copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
    String? userType,
    Timestamp? birthday,
    String? profileUrl,
    String? gender,
    String? currentPosition,
    String? companyLogoUrl,
    String? companyName,
    String? companyLocation,
    String? companySize,
    String? aboutCompany,
  }) {
    return UserInfoModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userType: userType ?? this.userType,
      birthday: birthday ?? this.birthday,
      profileUrl: profileUrl ?? this.profileUrl,
      gender: gender ?? this.gender,
      currentPosition: currentPosition ?? this.currentPosition,
      companyLogoUrl: companyLogoUrl ?? this.companyLogoUrl,
      companyName: companyName ?? this.companyName,
      companyLocation: companyLocation ?? this.companyLocation,
      companySize: companySize ?? this.companySize,
      aboutCompany: aboutCompany ?? this.aboutCompany,
    );
  }
}
