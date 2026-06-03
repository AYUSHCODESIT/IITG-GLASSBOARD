import 'package:cloud_firestore/cloud_firestore.dart';

class ChecklistItem {
  final String id;
  final String taskId;
  final String title;
  final bool isCompleted;

  ChecklistItem({
    required this.id,
    required this.taskId,
    required this.title,
    required this.isCompleted,
  });

  factory ChecklistItem.fromMap(Map<String, dynamic> map, String id) {
    return ChecklistItem(
      id: id,
      taskId: map['taskId'] ?? '',
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  ChecklistItem copyWith({
    bool? isCompleted,
    String? title,
  }) {
    return ChecklistItem(
      id: id,
      taskId: taskId,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class TaskModel {
  final String id;
  final String moduleId;
  final String title;
  final String description;
  final DateTime dueDate;
  final String priority; // low | medium | high
  final String assignedTo; // uid of user
  final bool isCompleted;
  final double progress; // percentage completion based on checklists
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.assignedTo,
    required this.isCompleted,
    required this.progress,
    required this.createdAt,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map, String id) {
    return TaskModel(
      id: id,
      moduleId: map['moduleId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: (map['dueDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      priority: map['priority'] ?? 'medium',
      assignedTo: map['assignedTo'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      progress: (map['progress'] as num?)?.toDouble() ?? 0.0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'moduleId': moduleId,
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'priority': priority,
      'assignedTo': assignedTo,
      'isCompleted': isCompleted,
      'progress': progress,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  TaskModel copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    String? priority,
    String? assignedTo,
    bool? isCompleted,
    double? progress,
  }) {
    return TaskModel(
      id: id,
      moduleId: moduleId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      assignedTo: assignedTo ?? this.assignedTo,
      isCompleted: isCompleted ?? this.isCompleted,
      progress: progress ?? this.progress,
      createdAt: createdAt,
    );
  }
}
