import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/module_model.dart';
import '../models/task_model.dart';
import '../models/handshake_model.dart';
import '../models/file_model.dart';
import '../models/audit_log_model.dart';
import '../models/notification_model.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  bool _isFirebaseInitialized = false;
  bool get isFirebaseInitialized => _isFirebaseInitialized;

  // Local Memory Storage for Standalone/Hackathon Demo Mode
  final List<UserModel> _mockUsers = [];
  final List<ModuleModel> _mockModules = [];
  final List<TaskModel> _mockTasks = [];
  final List<ChecklistItem> _mockChecklists = [];
  final List<HandshakeModel> _mockHandshakes = [];
  final List<FileModel> _mockFiles = [];
  final List<FileVersionModel> _mockFileVersions = [];
  final List<AuditLogModel> _mockAuditLogs = [];
  final List<NotificationModel> _mockNotifications = [];

  // Broadcast Controllers for Live Progress Sync
  final _moduleStreamController = StreamController<List<ModuleModel>>.broadcast();
  final _taskStreamController = StreamController<List<TaskModel>>.broadcast();
  final _handshakeStreamController = StreamController<List<HandshakeModel>>.broadcast();
  final _fileStreamController = StreamController<List<FileModel>>.broadcast();
  final _auditLogStreamController = StreamController<List<AuditLogModel>>.broadcast();

  // Active presence mapping (Realtime Database alternative for Mock Mode)
  final Map<String, bool> _presence = {};
  UserModel? _currentUser;

  Future<void> initialize() async {
    try {
      if (kIsWeb || defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS) {
        await Firebase.initializeApp();
        _isFirebaseInitialized = true;
        debugPrint('Firebase initialized successfully.');
      } else {
        _isFirebaseInitialized = false;
        debugPrint('Running on unsupported platform for Firebase Core. Using Mock Mode.');
        _seedMockData();
      }
    } catch (e) {
      _isFirebaseInitialized = false;
      debugPrint('Firebase Core initialization failed: $e. Falling back to Standalone Mock Engine.');
      _seedMockData();
    }
  }

  UserModel? get currentUser => _currentUser;
  void setCurrentUser(UserModel user) {
    _currentUser = user;
    _presence[user.uid] = true;
  }

  void _seedMockData() {
    // Seed Users
    _mockUsers.addAll([
      UserModel(uid: 'admin_1', email: 'admin@glassboard.com', displayName: 'Elena Rostova', role: 'admin', createdAt: DateTime.now().subtract(const Duration(days: 30))),
      UserModel(uid: 'head_1', email: 'director@glassboard.com', displayName: 'Dr. Arthur Vance', role: 'org_head', createdAt: DateTime.now().subtract(const Duration(days: 30))),
      UserModel(uid: 'lead_design', email: 'sarah@glassboard.com', displayName: 'Sarah Chen', role: 'lead', moduleId: 'mod_design', createdAt: DateTime.now().subtract(const Duration(days: 20))),
      UserModel(uid: 'lead_dev', email: 'ayush@glassboard.com', displayName: 'Ayush Kumar', role: 'lead', moduleId: 'mod_dev', createdAt: DateTime.now().subtract(const Duration(days: 20))),
      UserModel(uid: 'lead_qa', email: 'clara@glassboard.com', displayName: 'Clara Oswald', role: 'lead', moduleId: 'mod_qa', createdAt: DateTime.now().subtract(const Duration(days: 20))),
      UserModel(uid: 'lead_deploy', email: 'diana@glassboard.com', displayName: 'Diana Prince', role: 'lead', moduleId: 'mod_deploy', createdAt: DateTime.now().subtract(const Duration(days: 20))),
      UserModel(uid: 'emp_dev_1', email: 'john@glassboard.com', displayName: 'John Doe', role: 'employee', moduleId: 'mod_dev', createdAt: DateTime.now().subtract(const Duration(days: 15))),
      UserModel(uid: 'emp_design_1', email: 'lily@glassboard.com', displayName: 'Lily Evans', role: 'employee', moduleId: 'mod_design', createdAt: DateTime.now().subtract(const Duration(days: 15))),
    ]);

    // Seed Modules (Design -> Dev -> QA -> Deploy)
    _mockModules.addAll([
      ModuleModel(id: 'mod_design', name: 'Design Studio', description: 'User interfaces, UX maps, design systems, assets.', leadId: 'lead_design', memberIds: ['lead_design', 'emp_design_1'], dependencyIds: [], progress: 100.0, status: 'completed', createdAt: DateTime.now().subtract(const Duration(days: 25))),
      ModuleModel(id: 'mod_dev', name: 'Software Development', description: 'Flutter frontend implementation and backend API services.', leadId: 'lead_dev', memberIds: ['lead_dev', 'emp_dev_1'], dependencyIds: ['mod_design'], progress: 66.0, status: 'in_progress', createdAt: DateTime.now().subtract(const Duration(days: 25))),
      ModuleModel(id: 'mod_qa', name: 'Quality Assurance', description: 'Integration tests, usability reviews, build checks.', leadId: 'lead_qa', memberIds: ['lead_qa'], dependencyIds: ['mod_dev'], progress: 0.0, status: 'blocked', createdAt: DateTime.now().subtract(const Duration(days: 25))),
      ModuleModel(id: 'mod_deploy', name: 'Release Operations', description: 'App Stores release pipelines, CI/CD configs.', leadId: 'lead_deploy', memberIds: ['lead_deploy'], dependencyIds: ['mod_qa'], progress: 0.0, status: 'blocked', createdAt: DateTime.now().subtract(const Duration(days: 25))),
    ]);

    // Seed Tasks & Checklists
    // Design Tasks
    _mockTasks.addAll([
      TaskModel(id: 'task_des_1', moduleId: 'mod_design', title: 'High-Fidelity Wireframes', description: 'Create full mockups of organizational bottleneck charts.', dueDate: DateTime.now().subtract(const Duration(days: 5)), priority: 'high', assignedTo: 'emp_design_1', isCompleted: true, progress: 100.0, createdAt: DateTime.now().subtract(const Duration(days: 12))),
      TaskModel(id: 'task_des_2', moduleId: 'mod_design', title: 'Asset Exports', description: 'Export SVG assets and HSL color hex profiles.', dueDate: DateTime.now().subtract(const Duration(days: 2)), priority: 'low', assignedTo: 'lead_design', isCompleted: true, progress: 100.0, createdAt: DateTime.now().subtract(const Duration(days: 10))),
    ]);
    
    // Dev Tasks
    _mockTasks.addAll([
      TaskModel(id: 'task_dev_1', moduleId: 'mod_dev', title: 'Riverpod Implementation', description: 'Create states and controllers for digital handshakes.', dueDate: DateTime.now().subtract(const Duration(days: 1)), priority: 'high', assignedTo: 'lead_dev', isCompleted: true, progress: 100.0, createdAt: DateTime.now().subtract(const Duration(days: 8))),
      TaskModel(id: 'task_dev_2', moduleId: 'mod_dev', title: 'Firebase Authentication API', description: 'Connect Splash, Login, and User promotion databases.', dueDate: DateTime.now().add(const Duration(days: 2)), priority: 'medium', assignedTo: 'emp_dev_1', isCompleted: false, progress: 33.0, createdAt: DateTime.now().subtract(const Duration(days: 7))),
      TaskModel(id: 'task_dev_3', moduleId: 'mod_dev', title: 'Interactive Delay Engine UI', description: 'Render the node-link graph mapping out bottleneck hubs.', dueDate: DateTime.now().add(const Duration(days: 5)), priority: 'high', assignedTo: 'lead_dev', isCompleted: false, progress: 0.0, createdAt: DateTime.now().subtract(const Duration(days: 6))),
    ]);
    
    // QA Tasks
    _mockTasks.addAll([
      TaskModel(id: 'task_qa_1', moduleId: 'mod_qa', title: 'Integration Test Suite', description: 'Write integration test drivers.', dueDate: DateTime.now().add(const Duration(days: 8)), priority: 'medium', assignedTo: 'lead_qa', isCompleted: false, progress: 0.0, createdAt: DateTime.now().subtract(const Duration(days: 5))),
    ]);

    // Checklists
    _mockChecklists.addAll([
      ChecklistItem(id: 'chk_des_1', taskId: 'task_des_1', title: 'User Dashboards Wireframe', isCompleted: true),
      ChecklistItem(id: 'chk_des_2', taskId: 'task_des_1', title: 'Audit Ticker Panel Mock', isCompleted: true),
      ChecklistItem(id: 'chk_dev_2_1', taskId: 'task_dev_2', title: 'Sign-in Forms with Email Validation', isCompleted: true),
      ChecklistItem(id: 'chk_dev_2_2', taskId: 'task_dev_2', title: 'OAuth Google Login Hook', isCompleted: false),
      ChecklistItem(id: 'chk_dev_2_3', taskId: 'task_dev_2', title: 'Persistent Login Storage Session', isCompleted: false),
    ]);

    // Seed Handshakes
    _mockHandshakes.add(HandshakeModel(
      id: 'hs_design_dev',
      senderModuleId: 'mod_design',
      receiverModuleId: 'mod_dev',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      attachedFileIds: ['file_design_specs'],
      proofUrls: ['https://figma.com/file/glassboard_specs_mock_url'],
      status: 'accepted',
      comments: 'Design deliverables finalized. UX specs and SVG files uploaded.',
      acceptanceTimestamp: DateTime.now().subtract(const Duration(days: 1, hours: 18)),
    ));

    // Seed Files & Versions
    _mockFiles.add(FileModel(id: 'file_design_specs', moduleId: 'mod_design', name: 'glassboard_design_specs.pdf', currentVersion: 2, updatedAt: DateTime.now().subtract(const Duration(days: 2)), updatedBy: 'lead_design', updatedByName: 'Sarah Chen'));
    _mockFileVersions.addAll([
      FileVersionModel(id: 'fv_specs_v1', fileId: 'file_design_specs', versionNumber: 1, url: 'https://storage.googleapis.com/v1_pdf', editorId: 'lead_design', editorName: 'Sarah Chen', timestamp: DateTime.now().subtract(const Duration(days: 5)), changeSummary: 'Initial draft of layout schematics.'),
      FileVersionModel(id: 'fv_specs_v2', fileId: 'file_design_specs', versionNumber: 2, url: 'https://storage.googleapis.com/v2_pdf', editorId: 'emp_design_1', editorName: 'Lily Evans', timestamp: DateTime.now().subtract(const Duration(days: 2)), changeSummary: 'Updated color profiles with Material 3 hex codes.'),
    ]);

    // Seed Audit Logs
    _mockAuditLogs.addAll([
      AuditLogModel(id: 'log_1', action: 'LOGIN', userId: 'lead_design', userName: 'Sarah Chen', timestamp: DateTime.now().subtract(const Duration(days: 4)), moduleId: 'mod_design', metadata: {'device': 'Android SDK Emulator'}),
      AuditLogModel(id: 'log_2', action: 'FILE_UPLOAD', userId: 'lead_design', userName: 'Sarah Chen', timestamp: DateTime.now().subtract(const Duration(days: 4)), moduleId: 'mod_design', metadata: {'fileName': 'glassboard_design_specs.pdf', 'version': 1}),
      AuditLogModel(id: 'log_3', action: 'HANDSHAKE_CREATE', userId: 'lead_design', userName: 'Sarah Chen', timestamp: DateTime.now().subtract(const Duration(days: 2)), moduleId: 'mod_design', metadata: {'target': 'Software Development'}),
      AuditLogModel(id: 'log_4', action: 'HANDSHAKE_ACCEPT', userId: 'lead_dev', userName: 'Ayush Kumar', timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 18)), moduleId: 'mod_dev', metadata: {'source': 'Design Studio'}),
    ]);

    // Seed Notifications
    _mockNotifications.addAll([
      NotificationModel(id: 'not_1', userId: 'lead_dev', title: 'Design Handover Available', body: 'Sarah Chen has created a Handshake Transfer request for Design Studio.', type: 'handshake', isRead: true, timestamp: DateTime.now().subtract(const Duration(days: 2))),
      NotificationModel(id: 'not_2', userId: 'lead_qa', title: 'Quality Assurance is Blocked', body: 'Software Development is delayed, blocking your downstream pipeline.', type: 'delay', isRead: false, timestamp: DateTime.now().subtract(const Duration(hours: 4))),
    ]);

    _currentUser = _mockUsers[3]; // Default to Ayush Kumar (Dev Lead) for easy hackathon visualization!
  }

  // --- API OPERATIONS (Adapts automatically between Mock and live Firebase) ---

  Stream<List<ModuleModel>> streamModules() {
    if (_isFirebaseInitialized) {
      return FirebaseFirestore.instance.collection('modules').snapshots().map(
        (snap) => snap.docs.map((doc) => ModuleModel.fromMap(doc.data(), doc.id)).toList()
      );
    } else {
      // Return mock stream
      Timer.periodic(const Duration(seconds: 2), (_) {
        if (!_moduleStreamController.isClosed) {
          _moduleStreamController.add(List<ModuleModel>.from(_mockModules));
        }
      });
      return _moduleStreamController.stream;
    }
  }

  Stream<List<TaskModel>> streamTasks(String moduleId) {
    if (_isFirebaseInitialized) {
      return FirebaseFirestore.instance.collection('tasks').where('moduleId', isEqualTo: moduleId).snapshots().map(
        (snap) => snap.docs.map((doc) => TaskModel.fromMap(doc.data(), doc.id)).toList()
      );
    } else {
      Timer.periodic(const Duration(seconds: 2), (_) {
        if (!_taskStreamController.isClosed) {
          final filtered = _mockTasks.where((t) => t.moduleId == moduleId).toList();
          _taskStreamController.add(filtered);
        }
      });
      return _taskStreamController.stream;
    }
  }

  Stream<List<HandshakeModel>> streamHandshakes() {
    if (_isFirebaseInitialized) {
      return FirebaseFirestore.instance.collection('handshakes').snapshots().map(
        (snap) => snap.docs.map((doc) => HandshakeModel.fromMap(doc.data(), doc.id)).toList()
      );
    } else {
      Timer.periodic(const Duration(seconds: 2), (_) {
        if (!_handshakeStreamController.isClosed) {
          _handshakeStreamController.add(List<HandshakeModel>.from(_mockHandshakes));
        }
      });
      return _handshakeStreamController.stream;
    }
  }

  Stream<List<FileModel>> streamFiles(String moduleId) {
    if (_isFirebaseInitialized) {
      return FirebaseFirestore.instance.collection('files').where('moduleId', isEqualTo: moduleId).snapshots().map(
        (snap) => snap.docs.map((doc) => FileModel.fromMap(doc.data(), doc.id)).toList()
      );
    } else {
      Timer.periodic(const Duration(seconds: 2), (_) {
        if (!_fileStreamController.isClosed) {
          final filtered = _mockFiles.where((f) => f.moduleId == moduleId).toList();
          _fileStreamController.add(filtered);
        }
      });
      return _fileStreamController.stream;
    }
  }

  Stream<List<AuditLogModel>> streamAuditLogs() {
    if (_isFirebaseInitialized) {
      return FirebaseFirestore.instance.collection('audit_logs').orderBy('timestamp', descending: true).snapshots().map(
        (snap) => snap.docs.map((doc) => AuditLogModel.fromMap(doc.data(), doc.id)).toList()
      );
    } else {
      Timer.periodic(const Duration(seconds: 2), (_) {
        if (!_auditLogStreamController.isClosed) {
          _auditLogStreamController.add(List<AuditLogModel>.from(_mockAuditLogs));
        }
      });
      return _auditLogStreamController.stream;
    }
  }

  // Fetch Checklists for a Task
  Future<List<ChecklistItem>> getChecklists(String taskId) async {
    if (_isFirebaseInitialized) {
      final snap = await FirebaseFirestore.instance.collection('checklists').where('taskId', isEqualTo: taskId).get();
      return snap.docs.map((doc) => ChecklistItem.fromMap(doc.data(), doc.id)).toList();
    } else {
      return _mockChecklists.where((c) => c.taskId == taskId).toList();
    }
  }

  // Toggle Checklist status and update parent task & module progress
  Future<void> toggleChecklist(String checklistId, bool isCompleted) async {
    if (_isFirebaseInitialized) {
      final db = FirebaseFirestore.instance;
      await db.collection('checklists').doc(checklistId).update({'isCompleted': isCompleted});
      
      // Calculate Task progress
      final checklistDoc = await db.collection('checklists').doc(checklistId).get();
      final taskId = checklistDoc.data()?['taskId'];
      
      if (taskId != null) {
        final checklistsSnap = await db.collection('checklists').where('taskId', isEqualTo: taskId).get();
        final list = checklistsSnap.docs;
        final completedCount = list.where((d) => d.data()['isCompleted'] == true).length;
        final total = list.length;
        final newProgress = total > 0 ? (completedCount / total) * 100.0 : 0.0;
        final taskCompleted = completedCount == total && total > 0;
        
        await db.collection('tasks').doc(taskId).update({
          'progress': newProgress,
          'isCompleted': taskCompleted,
        });

        // Recalculate module progress
        final taskDoc = await db.collection('tasks').doc(taskId).get();
        final moduleId = taskDoc.data()?['moduleId'];
        if (moduleId != null) {
          await _rebuildModuleProgress(moduleId);
        }
      }
    } else {
      final idx = _mockChecklists.indexWhere((c) => c.id == checklistId);
      if (idx != -1) {
        final item = _mockChecklists[idx];
        _mockChecklists[idx] = item.copyWith(isCompleted: isCompleted);
        
        // Calculate task progress
        final taskId = item.taskId;
        final sublist = _mockChecklists.where((c) => c.taskId == taskId).toList();
        final completedCount = sublist.where((c) => c.isCompleted).length;
        final total = sublist.length;
        final newProgress = total > 0 ? (completedCount / total) * 100.0 : 0.0;
        final taskCompleted = completedCount == total && total > 0;

        final tIdx = _mockTasks.indexWhere((t) => t.id == taskId);
        if (tIdx != -1) {
          final t = _mockTasks[tIdx];
          _mockTasks[tIdx] = t.copyWith(progress: newProgress, isCompleted: taskCompleted);
          _rebuildModuleProgressMock(t.moduleId);
        }
      }
    }
  }

  // Create standard Checklist items
  Future<void> addChecklistItem(String taskId, String title) async {
    final id = 'chk_${DateTime.now().millisecondsSinceEpoch}';
    final newItem = ChecklistItem(id: id, taskId: taskId, title: title, isCompleted: false);
    if (_isFirebaseInitialized) {
      await FirebaseFirestore.instance.collection('checklists').doc(id).set(newItem.toMap());
      // Re-trigger progress calculations
      await toggleChecklist(id, false);
    } else {
      _mockChecklists.add(newItem);
      // Trigger progress recalculation for mock task
      final tIdx = _mockTasks.indexWhere((t) => t.id == taskId);
      if (tIdx != -1) {
        final t = _mockTasks[tIdx];
        final sublist = _mockChecklists.where((c) => c.taskId == taskId).toList();
        final completedCount = sublist.where((c) => c.isCompleted).length;
        final total = sublist.length;
        final newProgress = total > 0 ? (completedCount / total) * 100.0 : 0.0;
        _mockTasks[tIdx] = t.copyWith(progress: newProgress, isCompleted: false);
        _rebuildModuleProgressMock(t.moduleId);
      }
    }
  }

  // Create tasks
  Future<void> createTask(String moduleId, String title, String description, DateTime dueDate, String priority, String assignedTo) async {
    final id = 'task_${DateTime.now().millisecondsSinceEpoch}';
    final newTask = TaskModel(
      id: id,
      moduleId: moduleId,
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      assignedTo: assignedTo,
      isCompleted: false,
      progress: 0.0,
      createdAt: DateTime.now(),
    );

    if (_isFirebaseInitialized) {
      await FirebaseFirestore.instance.collection('tasks').doc(id).set(newTask.toMap());
      await _rebuildModuleProgress(moduleId);
    } else {
      _mockTasks.add(newTask);
      _rebuildModuleProgressMock(moduleId);
      writeAuditLog('TASK_CREATE', moduleId, {'taskTitle': title});
    }
  }

  Future<void> _rebuildModuleProgress(String moduleId) async {
    final db = FirebaseFirestore.instance;
    final tasksSnap = await db.collection('tasks').where('moduleId', isEqualTo: moduleId).get();
    final tasksList = tasksSnap.docs;
    if (tasksList.isEmpty) return;

    final completedTasks = tasksList.where((d) => d.data()['isCompleted'] == true).length;
    final total = tasksList.length;
    final progress = (completedTasks / total) * 100.0;
    final status = progress == 100.0 ? 'completed' : (progress > 0.0 ? 'in_progress' : 'not_started');

    await db.collection('modules').doc(moduleId).update({
      'progress': progress,
      'status': status,
    });
  }

  void _rebuildModuleProgressMock(String moduleId) {
    final subtasks = _mockTasks.where((t) => t.moduleId == moduleId).toList();
    if (subtasks.isEmpty) return;

    final completedCount = subtasks.where((t) => t.isCompleted).length;
    final total = subtasks.length;
    final progress = (completedCount / total) * 100.0;
    
    final modIdx = _mockModules.indexWhere((m) => m.id == moduleId);
    if (modIdx != -1) {
      final m = _mockModules[modIdx];
      // Mark completed or set status
      final status = progress == 100.0 ? 'completed' : 'in_progress';
      _mockModules[modIdx] = m.copyWith(progress: progress, status: status);
      
      // Update downstream blocks if progress is changed
      _recalculateBlocksMock();
    }
  }

  void _recalculateBlocksMock() {
    // If a parent module has progress < 100%, any module that depends on it is Blocked
    for (int i = 0; i < _mockModules.length; i++) {
      final m = _mockModules[i];
      if (m.dependencyIds.isNotEmpty) {
        bool isBlocked = false;
        for (var depId in m.dependencyIds) {
          final parent = _mockModules.firstWhere((mod) => mod.id == depId);
          if (parent.progress < 100.0) {
            isBlocked = true;
            break;
          }
        }
        if (isBlocked && m.status != 'completed') {
          _mockModules[i] = m.copyWith(status: 'blocked');
        } else if (!isBlocked && m.status == 'blocked') {
          _mockModules[i] = m.copyWith(status: m.progress > 0 ? 'in_progress' : 'not_started');
        }
      }
    }
  }

  // Digital Handshake triggers
  Future<void> createHandshake(String senderModuleId, String receiverModuleId, List<String> fileIds, String proofUrl, String comments) async {
    final id = 'hs_${DateTime.now().millisecondsSinceEpoch}';
    final handshake = HandshakeModel(
      id: id,
      senderModuleId: senderModuleId,
      receiverModuleId: receiverModuleId,
      timestamp: DateTime.now(),
      attachedFileIds: fileIds,
      proofUrls: [proofUrl],
      status: 'pending',
      comments: comments,
    );

    if (_isFirebaseInitialized) {
      await FirebaseFirestore.instance.collection('handshakes').doc(id).set(handshake.toMap());
    } else {
      _mockHandshakes.add(handshake);
      // Trigger user notifications for Lead of the receiver module
      final recLead = _mockModules.firstWhere((mod) => mod.id == receiverModuleId).leadId;
      _mockNotifications.add(NotificationModel(
        id: 'not_${DateTime.now().millisecondsSinceEpoch}',
        userId: recLead,
        title: 'Incoming Handshake Handoff',
        body: 'A digital handshake has been initiated by ${_mockModules.firstWhere((mod) => mod.id == senderModuleId).name}.',
        type: 'handshake',
        isCompleted: false,
        isRead: false,
        timestamp: DateTime.now(),
      ));

      writeAuditLog('HANDSHAKE_CREATE', senderModuleId, {
        'handshakeId': id,
        'receiver': _mockModules.firstWhere((mod) => mod.id == receiverModuleId).name,
      });
    }
  }

  // Accept / Reject handshakes
  Future<void> reviewHandshake(String handshakeId, bool isAccepted, String? rejectionReason) async {
    if (_isFirebaseInitialized) {
      final db = FirebaseFirestore.instance;
      if (isAccepted) {
        await db.collection('handshakes').doc(handshakeId).update({
          'status': 'accepted',
          'rejectionReason': null,
          'acceptanceTimestamp': Timestamp.fromDate(DateTime.now()),
        });
      } else {
        await db.collection('handshakes').doc(handshakeId).update({
          'status': 'rejected',
          'rejectionReason': rejectionReason,
          'acceptanceTimestamp': null,
        });
      }
    } else {
      final idx = _mockHandshakes.indexWhere((h) => h.id == handshakeId);
      if (idx != -1) {
        final hs = _mockHandshakes[idx];
        if (isAccepted) {
          _mockHandshakes[idx] = hs.copyWith(
            status: 'accepted',
            rejectionReason: null,
            acceptanceTimestamp: DateTime.now(),
          );
          
          // Unblock receiver module dependencies if parent is 100% completed
          _recalculateBlocksMock();
          
          writeAuditLog('HANDSHAKE_ACCEPT', hs.receiverModuleId, {
            'source': _mockModules.firstWhere((mod) => mod.id == hs.senderModuleId).name,
          });
        } else {
          _mockHandshakes[idx] = hs.copyWith(
            status: 'rejected',
            rejectionReason: rejectionReason,
          );

          writeAuditLog('HANDSHAKE_REJECT', hs.receiverModuleId, {
            'source': _mockModules.firstWhere((mod) => mod.id == hs.senderModuleId).name,
            'reason': rejectionReason ?? '',
          });
        }
      }
    }
  }

  // File Sharing workspace
  Future<List<FileVersionModel>> getFileHistory(String fileId) async {
    if (_isFirebaseInitialized) {
      final snap = await FirebaseFirestore.instance.collection('file_versions').where('fileId', isEqualTo: fileId).orderBy('versionNumber', descending: true).get();
      return snap.docs.map((doc) => FileVersionModel.fromMap(doc.data(), doc.id)).toList();
    } else {
      return _mockFileVersions.where((fv) => fv.fileId == fileId).toList()
        ..sort((a, b) => b.versionNumber.compareTo(a.versionNumber));
    }
  }

  Future<void> uploadFile(String moduleId, String name, String url, String changeSummary) async {
    final fileId = 'file_${DateTime.now().millisecondsSinceEpoch}';
    final user = _currentUser ?? _mockUsers[0];

    final newFile = FileModel(
      id: fileId,
      moduleId: moduleId,
      name: name,
      currentVersion: 1,
      updatedAt: DateTime.now(),
      updatedBy: user.uid,
      updatedByName: user.displayName,
    );

    final newVersion = FileVersionModel(
      id: 'fv_${DateTime.now().millisecondsSinceEpoch}',
      fileId: fileId,
      versionNumber: 1,
      url: url,
      editorId: user.uid,
      editorName: user.displayName,
      timestamp: DateTime.now(),
      changeSummary: changeSummary,
    );

    if (_isFirebaseInitialized) {
      final db = FirebaseFirestore.instance;
      await db.collection('files').doc(fileId).set(newFile.toMap());
      await db.collection('file_versions').doc(newVersion.id).set(newVersion.toMap());
    } else {
      _mockFiles.add(newFile);
      _mockFileVersions.add(newVersion);
      writeAuditLog('FILE_UPLOAD', moduleId, {
        'fileName': name,
        'version': 1,
      });
    }
  }

  Future<void> replaceFileVersion(String fileId, String url, String changeSummary) async {
    final user = _currentUser ?? _mockUsers[0];

    if (_isFirebaseInitialized) {
      final db = FirebaseFirestore.instance;
      final fileDoc = await db.collection('files').doc(fileId).get();
      if (fileDoc.exists) {
        final currentVer = fileDoc.data()?['currentVersion'] ?? 1;
        final nextVer = currentVer + 1;

        await db.collection('files').doc(fileId).update({
          'currentVersion': nextVer,
          'updatedAt': Timestamp.fromDate(DateTime.now()),
          'updatedBy': user.uid,
          'updatedByName': user.displayName,
        });

        final verId = 'fv_${DateTime.now().millisecondsSinceEpoch}';
        final newVersion = FileVersionModel(
          id: verId,
          fileId: fileId,
          versionNumber: nextVer,
          url: url,
          editorId: user.uid,
          editorName: user.displayName,
          timestamp: DateTime.now(),
          changeSummary: changeSummary,
        );
        await db.collection('file_versions').doc(verId).set(newVersion.toMap());
      }
    } else {
      final idx = _mockFiles.indexWhere((f) => f.id == fileId);
      if (idx != -1) {
        final file = _mockFiles[idx];
        final nextVer = file.currentVersion + 1;
        _mockFiles[idx] = file.copyWith(
          currentVersion: nextVer,
          updatedAt: DateTime.now(),
          updatedBy: user.uid,
          updatedByName: user.displayName,
        );

        final newVersion = FileVersionModel(
          id: 'fv_${DateTime.now().millisecondsSinceEpoch}',
          fileId: fileId,
          versionNumber: nextVer,
          url: url,
          editorId: user.uid,
          editorName: user.displayName,
          timestamp: DateTime.now(),
          changeSummary: changeSummary,
        );
        _mockFileVersions.add(newVersion);

        writeAuditLog('FILE_MODIFY', file.moduleId, {
          'fileName': file.name,
          'version': nextVer,
        });
      }
    }
  }

  // Immutable writing of Audit logs
  Future<void> writeAuditLog(String action, String? moduleId, Map<String, dynamic> metadata) async {
    final user = _currentUser ?? _mockUsers[0];
    final id = 'log_${DateTime.now().millisecondsSinceEpoch}';
    final log = AuditLogModel(
      id: id,
      action: action,
      userId: user.uid,
      userName: user.displayName,
      timestamp: DateTime.now(),
      moduleId: moduleId,
      metadata: metadata,
    );

    if (_isFirebaseInitialized) {
      await FirebaseFirestore.instance.collection('audit_logs').doc(id).set(log.toMap());
    } else {
      _mockAuditLogs.insert(0, log); // Insert at beginning so order remains descending
    }
  }

  // Seed / Reset Mock DB
  void resetMockData() {
    _mockUsers.clear();
    _mockModules.clear();
    _mockTasks.clear();
    _mockChecklists.clear();
    _mockHandshakes.clear();
    _mockFiles.clear();
    _mockFileVersions.clear();
    _mockAuditLogs.clear();
    _mockNotifications.clear();
    _seedMockData();
  }

  // Module admin overrides
  Future<void> createModule(String name, String description, String leadId, List<String> dependencyIds) async {
    final id = 'mod_${DateTime.now().millisecondsSinceEpoch}';
    final newMod = ModuleModel(
      id: id,
      name: name,
      description: description,
      leadId: leadId,
      memberIds: [leadId],
      dependencyIds: dependencyIds,
      progress: 0.0,
      status: 'not_started',
      createdAt: DateTime.now(),
    );

    if (_isFirebaseInitialized) {
      await FirebaseFirestore.instance.collection('modules').doc(id).set(newMod.toMap());
    } else {
      _mockModules.add(newMod);
      _recalculateBlocksMock();
      writeAuditLog('MODULE_CREATE', id, {'moduleName': name});
    }
  }

  Future<void> promoteUser(String userId, String role, String? moduleId) async {
    if (_isFirebaseInitialized) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'role': role,
        'moduleId': moduleId,
      });
    } else {
      final idx = _mockUsers.indexWhere((u) => u.uid == userId);
      if (idx != -1) {
        final u = _mockUsers[idx];
        _mockUsers[idx] = u.copyWith(role: role, moduleId: moduleId);
        writeAuditLog('USER_PROMOTE', null, {'targetUser': u.displayName, 'newRole': role});
      }
    }
  }

  List<UserModel> getMockUsersList() => _mockUsers;
}

// Helper addition for compilation compatibility in mock model
extension NotificationModelExtension on NotificationModel {
  bool get isCompleted => false;
}
