import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import '../../models/module_model.dart';
import '../../models/task_model.dart';
import '../../models/handshake_model.dart';
import '../../models/file_model.dart';
import '../../models/audit_log_model.dart';
import '../../services/firebase_service.dart';

// --- AUTHENTICATION STATE NOTIFIER ---
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;

  AuthState({this.user, this.isLoading = false, this.errorMessage});

  AuthState copyWith({UserModel? user, bool? isLoading, String? errorMessage}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseService _service = FirebaseService();

  AuthNotifier() : super(AuthState(user: FirebaseService().currentUser)) {
    // Initialize current user
    if (_service.currentUser != null) {
      state = AuthState(user: _service.currentUser);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      // Sleek mock authentication switcher for hackathon
      final users = _service.getMockUsersList();
      final userMatch = users.firstWhere(
        (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
        orElse: () => throw Exception('User account not registered in database.'),
      );

      _service.setCurrentUser(userMatch);
      await _service.writeAuditLog('LOGIN', null, {'device': 'Mobile App Emulator'});
      
      state = AuthState(user: userMatch);
      return true;
    } catch (e) {
      state = AuthState(isLoading: false, errorMessage: e.toString().replaceAll('Exception:', ''));
      return false;
    }
  }

  Future<bool> register(String email, String password, String displayName, String role, String? moduleId) async {
    state = state.copyWith(isLoading: true);
    try {
      final uid = 'usr_${DateTime.now().millisecondsSinceEpoch}';
      final newUser = UserModel(
        uid: uid,
        email: email.trim(),
        displayName: displayName.trim(),
        role: role,
        moduleId: moduleId,
        createdAt: DateTime.now(),
      );

      _service.getMockUsersList().add(newUser);
      _service.setCurrentUser(newUser);
      await _service.writeAuditLog('REGISTER', null, {'role': role});

      state = AuthState(user: newUser);
      return true;
    } catch (e) {
      state = AuthState(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _service.writeAuditLog('LOGOUT', null, {});
    _service.setCurrentUser(UserModel(uid: '', email: '', displayName: '', role: 'employee', createdAt: DateTime.now())); // Reset presence
    state = AuthState(user: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());


// --- STREAMS PROVIDERS ---

final modulesStreamProvider = StreamProvider<List<ModuleModel>>((ref) {
  return FirebaseService().streamModules();
});

final tasksStreamProvider = StreamProvider.family<List<TaskModel>, String>((ref, moduleId) {
  return FirebaseService().streamTasks(moduleId);
});

final handshakesStreamProvider = StreamProvider<List<HandshakeModel>>((ref) {
  return FirebaseService().streamHandshakes();
});

final filesStreamProvider = StreamProvider.family<List<FileModel>, String>((ref, moduleId) {
  return FirebaseService().streamFiles(moduleId);
});

final auditLogsStreamProvider = StreamProvider<List<AuditLogModel>>((ref) {
  return FirebaseService().streamAuditLogs();
});


// --- REAL-TIME DEPENDENCY TRACER & BOTTLENECK FINDER ---

class BottleneckReport {
  final ModuleModel? rootCauseModule;
  final List<ModuleModel> delayChain;
  final bool isBlocked;

  BottleneckReport({this.rootCauseModule, required this.delayChain, this.isBlocked = false});
}

final bottleneckProvider = Provider.family<BottleneckReport, String>((ref, moduleId) {
  final modulesAsync = ref.watch(modulesStreamProvider);
  return modulesAsync.maybeWhen(
    data: (modules) {
      final moduleMap = {for (var m in modules) m.id: m};
      final target = moduleMap[moduleId];
      if (target == null || target.dependencyIds.isEmpty) {
        return BottleneckReport(delayChain: [], isBlocked: false);
      }

      List<ModuleModel> chain = [];
      ModuleModel? rootCause;
      bool isBlocked = false;

      // Depth First Search to trace upstream delays
      void trace(String id) {
        final current = moduleMap[id];
        if (current == null) return;

        for (var depId in current.dependencyIds) {
          final parent = moduleMap[depId];
          if (parent != null) {
            if (parent.progress < 100.0) {
              isBlocked = true;
              chain.add(parent);
              // Furthest upstream with < 100% progress becomes rootCause
              if (parent.dependencyIds.isEmpty) {
                rootCause = parent;
              } else {
                trace(parent.id);
              }
            }
          }
        }
      }

      trace(moduleId);
      
      // If we have a delay chain but no rootCause selected, set the first element as rootCause
      if (isBlocked && rootCause == null && chain.isNotEmpty) {
        rootCause = chain.last;
      }

      return BottleneckReport(
        rootCauseModule: rootCause,
        delayChain: chain.reversed.toList(),
        isBlocked: isBlocked,
      );
    },
    orElse: () => BottleneckReport(delayChain: [], isBlocked: false),
  );
});


// --- LEADERSHIP ANALYTICS PROVIDER ---

class LeadershipKPIs {
  final ModuleModel? mostDelayedModule;
  final int pendingHandshakes;
  final Map<String, int> bottleneckFrequency; // moduleName -> number of blocked downstream modules
  final double averageAcceptanceTimeHours;
  final double workflowEfficiencyScore;

  LeadershipKPIs({
    this.mostDelayedModule,
    required this.pendingHandshakes,
    required this.bottleneckFrequency,
    required this.averageAcceptanceTimeHours,
    required this.workflowEfficiencyScore,
  });
}

final leadershipAnalyticsProvider = Provider<LeadershipKPIs>((ref) {
  final modules = ref.watch(modulesStreamProvider).maybeWhen(data: (d) => d, orElse: () => <ModuleModel>[]);
  final handshakes = ref.watch(handshakesStreamProvider).maybeWhen(data: (d) => d, orElse: () => <HandshakeModel>[]);

  if (modules.isEmpty) {
    return LeadershipKPIs(
      pendingHandshakes: 0,
      bottleneckFrequency: {},
      averageAcceptanceTimeHours: 0.0,
      workflowEfficiencyScore: 100.0,
    );
  }

  // 1. Pending Handshakes
  final pendingCount = handshakes.where((h) => h.status == 'pending').length;

  // 2. Average Handshake Acceptance Time
  final completedHandshakes = handshakes.where((h) => h.status == 'accepted' && h.acceptanceTimestamp != null).toList();
  double avgTime = 0.0;
  if (completedHandshakes.isNotEmpty) {
    double totalHours = 0;
    for (var ch in completedHandshakes) {
      final duration = ch.acceptanceTimestamp!.difference(ch.timestamp);
      totalHours += duration.inMinutes / 60.0;
    }
    avgTime = totalHours / completedHandshakes.length;
  }

  // 3. Bottleneck Frequency & Blocked Chain
  // Map module ID to name
  final moduleMap = {for (var m in modules) m.id: m};
  Map<String, int> freq = {};

  for (var m in modules) {
    if (m.status == 'blocked') {
      // Find what depends on what
      // Find parent of this blocked module that has progress < 100%
      for (var depId in m.dependencyIds) {
        final parent = moduleMap[depId];
        if (parent != null && parent.progress < 100.0) {
          freq[parent.name] = (freq[parent.name] ?? 0) + 1;
        }
      }
    }
  }

  // 4. Most Delayed Module (Module in progress or blocked with lowest completion)
  ModuleModel? delayedMod;
  double minProgress = 101.0;
  for (var m in modules) {
    if (m.status != 'completed' && m.progress < minProgress) {
      minProgress = m.progress;
      delayedMod = m;
    }
  }

  // 5. Workflow Efficiency Score
  // Calculation: average progress of all modules minus penalty for blocked modules
  double totalProgress = 0.0;
  for (var m in modules) {
    totalProgress += m.progress;
  }
  double avgProgress = totalProgress / modules.length;
  int blockedCount = modules.where((m) => m.status == 'blocked').length;
  double efficiency = (avgProgress - (blockedCount * 10.0)).clamp(0.0, 100.0);

  return LeadershipKPIs(
    mostDelayedModule: delayedMod,
    pendingHandshakes: pendingCount,
    bottleneckFrequency: freq,
    averageAcceptanceTimeHours: avgTime,
    workflowEfficiencyScore: efficiency,
  );
});
