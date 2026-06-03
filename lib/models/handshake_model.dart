import 'package:cloud_firestore/cloud_firestore.dart';

class HandshakeModel {
  final String id;
  final String senderModuleId;
  final String receiverModuleId;
  final DateTime timestamp;
  final List<String> attachedFileIds;
  final List<String> proofUrls; // Mock urls or firebase storage urls
  final String status; // pending | accepted | rejected
  final String comments;
  final String? rejectionReason;
  final DateTime? acceptanceTimestamp;

  HandshakeModel({
    required this.id,
    required this.senderModuleId,
    required this.receiverModuleId,
    required this.timestamp,
    required this.attachedFileIds,
    required this.proofUrls,
    required this.status,
    required this.comments,
    this.rejectionReason,
    this.acceptanceTimestamp,
  });

  factory HandshakeModel.fromMap(Map<String, dynamic> map, String id) {
    return HandshakeModel(
      id: id,
      senderModuleId: map['senderModuleId'] ?? '',
      receiverModuleId: map['receiverModuleId'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      attachedFileIds: List<String>.from(map['attachedFileIds'] ?? []),
      proofUrls: List<String>.from(map['proofUrls'] ?? []),
      status: map['status'] ?? 'pending',
      comments: map['comments'] ?? '',
      rejectionReason: map['rejectionReason'],
      acceptanceTimestamp: (map['acceptanceTimestamp'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderModuleId': senderModuleId,
      'receiverModuleId': receiverModuleId,
      'timestamp': Timestamp.fromDate(timestamp),
      'attachedFileIds': attachedFileIds,
      'proofUrls': proofUrls,
      'status': status,
      'comments': comments,
      'rejectionReason': rejectionReason,
      'acceptanceTimestamp': acceptanceTimestamp != null ? Timestamp.fromDate(acceptanceTimestamp!) : null,
    };
  }

  HandshakeModel copyWith({
    String? status,
    String? comments,
    String? rejectionReason,
    DateTime? acceptanceTimestamp,
  }) {
    return HandshakeModel(
      id: id,
      senderModuleId: senderModuleId,
      receiverModuleId: receiverModuleId,
      timestamp: timestamp,
      attachedFileIds: attachedFileIds,
      proofUrls: proofUrls,
      status: status ?? this.status,
      comments: comments ?? this.comments,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      acceptanceTimestamp: acceptanceTimestamp ?? this.acceptanceTimestamp,
    );
  }
}
