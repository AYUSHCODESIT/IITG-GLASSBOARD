import 'package:cloud_firestore/cloud_firestore.dart';

class ModuleModel {
  final String id;
  final String name;
  final String description;
  final String leadId;
  final List<String> memberIds;
  final List<String> dependencyIds; // IDs of modules this module depends on
  final double progress;
  final String status; // not_started | in_progress | blocked | completed
  final DateTime createdAt;

  ModuleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.leadId,
    required this.memberIds,
    required this.dependencyIds,
    required this.progress,
    required this.status,
    required this.createdAt,
  });

  factory ModuleModel.fromMap(Map<String, dynamic> map, String id) {
    return ModuleModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      leadId: map['leadId'] ?? '',
      memberIds: List<String>.from(map['memberIds'] ?? []),
      dependencyIds: List<String>.from(map['dependencyIds'] ?? []),
      progress: (map['progress'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? 'not_started',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'leadId': leadId,
      'memberIds': memberIds,
      'dependencyIds': dependencyIds,
      'progress': progress,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  ModuleModel copyWith({
    String? name,
    String? description,
    String? leadId,
    List<String>? memberIds,
    List<String>? dependencyIds,
    double? progress,
    String? status,
  }) {
    return ModuleModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      leadId: leadId ?? this.leadId,
      memberIds: memberIds ?? this.memberIds,
      dependencyIds: dependencyIds ?? this.dependencyIds,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
