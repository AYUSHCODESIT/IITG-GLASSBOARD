import 'package:cloud_firestore/cloud_firestore.dart';

class FileVersionModel {
  final String id;
  final String fileId;
  final int versionNumber;
  final String url;
  final String editorId;
  final String editorName;
  final DateTime timestamp;
  final String changeSummary;

  FileVersionModel({
    required this.id,
    required this.fileId,
    required this.versionNumber,
    required this.url,
    required this.editorId,
    required this.editorName,
    required this.timestamp,
    required this.changeSummary,
  });

  factory FileVersionModel.fromMap(Map<String, dynamic> map, String id) {
    return FileVersionModel(
      id: id,
      fileId: map['fileId'] ?? '',
      versionNumber: map['versionNumber'] ?? 1,
      url: map['url'] ?? '',
      editorId: map['editorId'] ?? '',
      editorName: map['editorName'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      changeSummary: map['changeSummary'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fileId': fileId,
      'versionNumber': versionNumber,
      'url': url,
      'editorId': editorId,
      'editorName': editorName,
      'timestamp': Timestamp.fromDate(timestamp),
      'changeSummary': changeSummary,
    };
  }
}

class FileModel {
  final String id;
  final String moduleId;
  final String name;
  final int currentVersion;
  final DateTime updatedAt;
  final String updatedBy;
  final String updatedByName;

  FileModel({
    required this.id,
    required this.moduleId,
    required this.name,
    required this.currentVersion,
    required this.updatedAt,
    required this.updatedBy,
    required this.updatedByName,
  });

  factory FileModel.fromMap(Map<String, dynamic> map, String id) {
    return FileModel(
      id: id,
      moduleId: map['moduleId'] ?? '',
      name: map['name'] ?? '',
      currentVersion: map['currentVersion'] ?? 1,
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedBy: map['updatedBy'] ?? '',
      updatedByName: map['updatedByName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'moduleId': moduleId,
      'name': name,
      'currentVersion': currentVersion,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'updatedBy': updatedBy,
      'updatedByName': updatedByName,
    };
  }

  FileModel copyWith({
    int? currentVersion,
    DateTime? updatedAt,
    String? updatedBy,
    String? updatedByName,
  }) {
    return FileModel(
      id: id,
      moduleId: moduleId,
      name: name,
      currentVersion: currentVersion ?? this.currentVersion,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedByName: updatedByName ?? this.updatedByName,
    );
  }
}
