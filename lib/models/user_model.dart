import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String role; // employee | lead | org_head | admin
  final String? moduleId;
  final String? profilePicUrl;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    this.moduleId,
    this.profilePicUrl,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      role: map['role'] ?? 'employee',
      moduleId: map['moduleId'],
      profilePicUrl: map['profilePicUrl'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'role': role,
      'moduleId': moduleId,
      'profilePicUrl': profilePicUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserModel copyWith({
    String? displayName,
    String? role,
    String? moduleId,
    String? profilePicUrl,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      moduleId: moduleId ?? this.moduleId,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      createdAt: createdAt,
    );
  }
}
