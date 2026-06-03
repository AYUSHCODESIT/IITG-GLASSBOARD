import 'package:cloud_firestore/cloud_firestore.dart';

class AuditLogModel {
  final String id;
  final String action;
  final String userId;
  final String userName;
  final DateTime timestamp;
  final String? moduleId;
  final Map<String, dynamic> metadata;

  AuditLogModel({
    required this.id,
    required this.action,
    required this.userId,
    required this.userName,
    required this.timestamp,
    this.moduleId,
    required this.metadata,
  });

  factory AuditLogModel.fromMap(Map<String, dynamic> map, String id) {
    return AuditLogModel(
      id: id,
      action: map['action'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      moduleId: map['moduleId'],
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'userId': userId,
      'userName': userName,
      'timestamp': Timestamp.fromDate(timestamp),
      'moduleId': moduleId,
      'metadata': metadata,
    };
  }
}
