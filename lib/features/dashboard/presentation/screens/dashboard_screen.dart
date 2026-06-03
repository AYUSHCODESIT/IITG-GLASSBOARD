import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/state_providers.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../models/module_model.dart';
import '../../../../models/task_model.dart';
import '../../../../models/handshake_model.dart';
import '../../../../models/file_model.dart';
import '../../../../models/user_model.dart';
import '../../../../widgets/glass_widgets.dart';
import '../../../../widgets/dependency_graph_widget.dart';
import '../../../../widgets/timeline_widget.dart';
import '../../../../widgets/dial_chart_widget.dart';
import '../../../../services/firebase_service.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentTab = 0; // 0: Dashboard, 1: Analytics, 2: Admin
  ModuleModel? _selectedModule; // For displaying module detail panel

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Unauthorized access. Log in.')));
    }

    final isLargeScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: _buildAppBar(context, user),
      body: Row(
        children: [
          if (isLargeScreen) _buildNavigationRail(context, user),
          Expanded(
            child: Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.darkBg, Color(0xFF111726)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: _selectedModule != null 
                  ? _buildModuleDetailPanel(_selectedModule!)
                  : _buildMainTabContent(user),
            ),
          ),
        ],
      ),
      bottomNavigationBar: !isLargeScreen ? _buildBottomNavBar(user) : null,
    );
  }

  AppBar _buildAppBar(BuildContext context, UserModel user) {
    return AppBar(
      title: Row(
        children: [
          const Icon(Icons.blur_linear_rounded, color: AppColors.primaryLight, size: 28),
          const SizedBox(width: 8),
          const Text(
            'GLASSBOARD',
            style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              Formatters.formatRole(user.role),
              style: const TextStyle(fontSize: 10, color: AppColors.textDarkSecondary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
          onPressed: () {
            FirebaseService().resetMockData();
            ref.invalidate(modulesStreamProvider);
            ref.invalidate(handshakesStreamProvider);
            ref.invalidate(auditLogsStreamProvider);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mock pipeline database seeded & reset!'), backgroundColor: AppColors.success),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
          onPressed: () async {
            await ref.read(authProvider.notifier).logout();
            if (mounted) Navigator.pushReplacementNamed(context, '/login');
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildNavigationRail(BuildContext context, UserModel user) {
    final isAdmin = user.role == 'admin';
    final isHead = user.role == 'org_head';

    return NavigationRail(
      selectedIndex: _currentTab,
      backgroundColor: AppColors.darkCard,
      indicatorColor: AppColors.primary.withOpacity(0.2),
      onDestinationSelected: (idx) {
        setState(() {
          _selectedModule = null;
          _currentTab = idx;
        });
      },
      labelType: NavigationRailLabelType.all,
      destinations: [
        const NavigationRailDestination(
          icon: Icon(Icons.dashboard_rounded, color: Colors.white70),
          selectedIcon: Icon(Icons.dashboard_rounded, color: AppColors.primaryLight),
          label: Text('Overview', style: TextStyle(fontSize: 11, color: Colors.white)),
        ),
        if (isAdmin || isHead)
          const NavigationRailDestination(
            icon: Icon(Icons.analytics_rounded, color: Colors.white70),
            selectedIcon: Icon(Icons.analytics_rounded, color: AppColors.primaryLight),
            label: Text('Analytics', style: TextStyle(fontSize: 11, color: Colors.white)),
          ),
        if (isAdmin)
          const NavigationRailDestination(
            icon: Icon(Icons.admin_panel_settings_rounded, color: Colors.white70),
            selectedIcon: Icon(Icons.admin_panel_settings_rounded, color: AppColors.primaryLight),
            label: Text('Admin', style: TextStyle(fontSize: 11, color: Colors.white)),
          ),
      ],
    );
  }

  Widget _buildBottomNavBar(UserModel user) {
    final isAdmin = user.role == 'admin';
    final isHead = user.role == 'org_head';

    List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Overview'),
    ];

    if (isAdmin || isHead) {
      items.add(const BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: 'Analytics'));
    }
    if (isAdmin) {
      items.add(const BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings_rounded), label: 'Admin'));
    }

    return BottomNavigationBar(
      currentIndex: _currentTab.clamp(0, items.length - 1),
      backgroundColor: AppColors.darkCard,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: Colors.white54,
      onTap: (idx) {
        setState(() {
          _selectedModule = null;
          _currentTab = idx;
        });
      },
      items: items,
    );
  }

  Widget _buildMainTabContent(UserModel user) {
    if (_currentTab == 1 && (user.role == 'admin' || user.role == 'org_head')) {
      return _buildAnalyticsTab();
    }
    if (_currentTab == 2 && user.role == 'admin') {
      return _buildAdminTab();
    }
    return _buildOverviewTab(user);
  }

  // --- OVERVIEW TAB CONTENT ---
  Widget _buildOverviewTab(UserModel user) {
    final modulesAsync = ref.watch(modulesStreamProvider);
    final handshakesAsync = ref.watch(handshakesStreamProvider);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Summary widgets
            modulesAsync.when(
              data: (modules) => _buildStatsRow(modules),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 20),

            // Delay root warning ticker
            _buildDelayWarningAlert(),

            // Dependency Flow Header
            const Row(
              children: [
                Icon(Icons.hub_rounded, color: AppColors.primaryLight, size: 22),
                SizedBox(width: 8),
                Text(
                  'Verifiable Department Handoff Chain',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            modulesAsync.when(
              data: (modules) => DependencyGraphWidget(
                modules: modules,
                onModuleTap: (mod) {
                  setState(() => _selectedModule = mod);
                },
              ),
              loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 24),

            // Personal Action center / Active checklist items
            _buildPersonalTaskSection(user),
            const SizedBox(height: 24),

            // Audit activity feed
            _buildRecentActivitySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(List<ModuleModel> modules) {
    final total = modules.length;
    final blocked = modules.where((m) => m.status == 'blocked').length;
    final completed = modules.where((m) => m.status == 'completed').length;
    final inProgress = modules.where((m) => m.status == 'in_progress').length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = (constraints.maxWidth - 24) / (constraints.maxWidth > 600 ? 4 : 2);
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildStatCard('Active Modules', total.toString(), Icons.folder_copy_rounded, AppColors.primary, width),
            _buildStatCard('In Progress', inProgress.toString(), Icons.sync_rounded, AppColors.info, width),
            _buildStatCard('Pipeline Blocks', blocked.toString(), Icons.block_flipped, AppColors.danger, width),
            _buildStatCard('Completed Gates', completed.toString(), Icons.verified_rounded, AppColors.success, width),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String val, IconData icon, Color color, double width) {
    return GlassCard(
      width: width,
      borderColor: color.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textDarkSecondary, fontWeight: FontWeight.bold)),
              Icon(icon, color: color, size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text(val, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildDelayWarningAlert() {
    final kpis = ref.watch(leadershipAnalyticsProvider);
    if (kpis.mostDelayedModule == null || kpis.mostDelayedModule!.status != 'blocked') {
      return const SizedBox.shrink();
    }

    final rootMod = kpis.mostDelayedModule!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: GlassCard(
        borderColor: AppColors.danger,
        fillColor: AppColors.danger.withOpacity(0.08),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.danger.withOpacity(0.2), shape: BoxShape.circle),
              child: const Icon(Icons.error_outline_rounded, color: AppColors.danger, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CRITICAL PIPELINE DELAY DETECTED',
                    style: TextStyle(color: AppColors.danger, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${rootMod.name} is currently delayed, causing downstream handoff locks across the organization!',
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalTaskSection(UserModel user) {
    final tasksAsync = ref.watch(tasksStreamProvider(user.moduleId ?? 'mod_dev'));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.checklist_rounded, color: AppColors.primaryLight, size: 22),
            SizedBox(width: 8),
            Text(
              'My Assigned Module Action Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 12),
        tasksAsync.when(
          data: (tasks) {
            final myTasks = tasks.where((t) => t.assignedTo == user.uid).toList();
            if (myTasks.isEmpty) {
              return const GlassCard(
                child: Center(
                  child: Text('No active checklist items assigned to your profile.', style: TextStyle(color: AppColors.textDarkSecondary)),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: myTasks.length,
              itemBuilder: (context, idx) {
                final task = myTasks[idx];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _buildChecklistTaskCard(task),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error loading tasks: $e'),
        ),
      ],
    );
  }

  Widget _buildChecklistTaskCard(TaskModel task) {
    return FutureBuilder<List<ChecklistItem>>(
      future: FirebaseService().getChecklists(task.id),
      builder: (context, snap) {
        final list = snap.data ?? [];
        return GlassCard(
          borderColor: task.isCompleted ? AppColors.success.withOpacity(0.3) : AppColors.darkBorder,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                  _buildPriorityIndicator(task.priority),
                ],
              ),
              const SizedBox(height: 6),
              Text(task.description, style: const TextStyle(fontSize: 12, color: AppColors.textDarkSecondary)),
              const SizedBox(height: 12),
              
              if (list.isEmpty)
                TextButton.icon(
                  onPressed: () => _showAddChecklistDialog(context, task.id),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add checklist sub-item', style: TextStyle(fontSize: 12)),
                )
              else
                Column(
                  children: [
                    ...list.map((item) => CheckboxListTile(
                      value: item.isCompleted,
                      title: Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 13)),
                      activeColor: AppColors.primaryLight,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      onChanged: (val) async {
                        if (val != null) {
                          await FirebaseService().toggleChecklist(item.id, val);
                          setState(() {}); // Re-trigger local draw
                        }
                      },
                    )),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => _showAddChecklistDialog(context, task.id),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add checklist sub-item', style: TextStyle(fontSize: 11)),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriorityIndicator(String priority) {
    Color color;
    switch (priority) {
      case 'high':
        color = AppColors.danger;
        break;
      case 'medium':
        color = AppColors.warning;
        break;
      case 'low':
      default:
        color = AppColors.success;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
      child: Text(priority.toUpperCase(), style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildRecentActivitySection() {
    final logsAsync = ref.watch(auditLogsStreamProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.history_toggle_off_rounded, color: AppColors.primaryLight, size: 22),
            SizedBox(width: 8),
            Text(
              'Organizational Audit Trail Feed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 12),
        logsAsync.when(
          data: (logs) {
            final recent = logs.take(6).toList();
            return GlassCard(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recent.length,
                separatorBuilder: (_, __) => Divider(color: Colors.white.withOpacity(0.06)),
                itemBuilder: (context, idx) {
                  final log = recent[idx];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          _getAuditIcon(log.action),
                          color: _getAuditColor(log.action),
                          size: 16,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(text: log.userName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12)),
                                    TextSpan(text: ' executed ', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                                    TextSpan(text: log.action.replaceAll('_', ' '), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryLight, fontSize: 12)),
                                  ],
                                ),
                              ),
                              if (log.metadata.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  log.metadata.toString().replaceAll('{', '').replaceAll('}', ''),
                                  style: TextStyle(color: AppColors.textDarkSecondary.withOpacity(0.8), fontSize: 11),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          Formatters.formatRelative(log.timestamp),
                          style: TextStyle(color: AppColors.textDarkSecondary.withOpacity(0.6), fontSize: 10),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error loading log trails: $e'),
        ),
      ],
    );
  }

  IconData _getAuditIcon(String action) {
    if (action.contains('LOGIN')) return Icons.login_rounded;
    if (action.contains('TASK')) return Icons.playlist_add_check_rounded;
    if (action.contains('HANDSHAKE')) return Icons.handshake_rounded;
    if (action.contains('FILE')) return Icons.file_present_rounded;
    return Icons.settings_rounded;
  }

  Color _getAuditColor(String action) {
    if (action.contains('LOGIN')) return AppColors.info;
    if (action.contains('TASK')) return AppColors.primaryLight;
    if (action.contains('HANDSHAKE')) return AppColors.warning;
    if (action.contains('FILE')) return AppColors.success;
    return AppColors.textDarkSecondary;
  }

  // --- ANALYTICS TAB CONTENT ---
  Widget _buildAnalyticsTab() {
    final kpis = ref.watch(leadershipAnalyticsProvider);
    final modulesAsync = ref.watch(modulesStreamProvider);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.leaderboard_rounded, color: AppColors.primaryLight, size: 22),
                SizedBox(width: 8),
                Text(
                  'Organizational Bottleneck Analytics',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Dials Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: DialChartWidget(score: kpis.workflowEfficiencyScore, label: 'Efficiency Index')),
                Expanded(child: DialChartWidget(score: (kpis.averageAcceptanceTimeHours > 0 ? (100 - (kpis.averageAcceptanceTimeHours * 2)) : 100).clamp(0, 100), label: 'Handoff Speed')),
              ],
            ),
            const SizedBox(height: 24),

            // Heatmap Bar graph representing delays
            const Text(
              'Department Bottleneck Incident Frequency',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            GlassCard(
              child: kpis.bottleneckFrequency.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No active pipeline bottlenecks detected currently.', style: TextStyle(color: AppColors.textDarkSecondary)),
                      ),
                    )
                  : Column(
                      children: kpis.bottleneckFrequency.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
                                  Text('${entry.value} blocked nodes', style: const TextStyle(color: AppColors.danger, fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: entry.value / 4.0, // Scale based on max possible departments
                                  backgroundColor: Colors.white.withOpacity(0.08),
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.danger),
                                  minHeight: 10,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),

            const SizedBox(height: 24),

            // Dynamic delay metrics
            const Text(
              'Module Performance Metrics',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            modulesAsync.when(
              data: (modules) => Column(
                children: modules.map((mod) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: GlassCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(mod.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Status: ${Formatters.formatStatus(mod.status)}', style: TextStyle(fontSize: 12, color: mod.status == 'blocked' ? AppColors.danger : AppColors.textDarkSecondary)),
                          ],
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: mod.status == 'completed' ? AppColors.success : AppColors.primary, width: 2),
                          ),
                          child: Text('${mod.progress.toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }

  // --- ADMIN CONTROL TAB CONTENT ---
  Widget _buildAdminTab() {
    final _modNameController = TextEditingController();
    final _modDescController = TextEditingController();
    final _targetUserEmailController = TextEditingController();
    String _promoteRole = 'lead';
    String? _promoteModuleId = 'mod_dev';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.admin_panel_settings_rounded, color: AppColors.primaryLight, size: 22),
                SizedBox(width: 8),
                Text(
                  'Global Administrative Suite',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Create module card
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Initialize Department Module', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _modNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Module Name'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _modDescController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 16),
                  GlassButton(
                    text: 'INITIALIZE MODULE',
                    onPressed: () async {
                      if (_modNameController.text.isNotEmpty) {
                        await FirebaseService().createModule(
                          _modNameController.text,
                          _modDescController.text,
                          'lead_dev', // Mock Lead assignment
                          ['mod_design'], // Default depend Design
                        );
                        ref.invalidate(modulesStreamProvider);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Module registered successfully.'), backgroundColor: AppColors.success),
                        );
                        _modNameController.clear();
                        _modDescController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Promote user roles
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Update User Security & Module Assignment', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _targetUserEmailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Target Email Address', hintText: 'john@glassboard.com'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _promoteRole,
                    dropdownColor: AppColors.darkCard,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Select Role'),
                    items: const [
                      DropdownMenuItem(value: 'employee', child: Text('Employee')),
                      DropdownMenuItem(value: 'lead', child: Text('Department Lead')),
                      DropdownMenuItem(value: 'org_head', child: Text('Organization Head')),
                      DropdownMenuItem(value: 'admin', child: Text('Administrator')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _promoteRole = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _promoteModuleId,
                    dropdownColor: AppColors.darkCard,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Module Assignment'),
                    items: const [
                      DropdownMenuItem(value: 'mod_design', child: Text('Design Studio')),
                      DropdownMenuItem(value: 'mod_dev', child: Text('Software Development')),
                      DropdownMenuItem(value: 'mod_qa', child: Text('Quality Assurance')),
                      DropdownMenuItem(value: 'mod_deploy', child: Text('Release Operations')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _promoteModuleId = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  GlassButton(
                    text: 'PROMOTE USER SECURITY',
                    onPressed: () async {
                      try {
                        final email = _targetUserEmailController.text.trim().toLowerCase();
                        final users = FirebaseService().getMockUsersList();
                        final target = users.firstWhere((u) => u.email.toLowerCase() == email);
                        
                        await FirebaseService().promoteUser(
                          target.uid,
                          _promoteRole,
                          _promoteModuleId,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User security clearance promoted!'), backgroundColor: AppColors.success),
                        );
                        _targetUserEmailController.clear();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Target corporate account not found.'), backgroundColor: AppColors.danger),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- NESTED SUB-PANEL MODULE DETAILS ---
  Widget _buildModuleDetailPanel(ModuleModel module) {
    final tasksAsync = ref.watch(tasksStreamProvider(module.id));
    final filesAsync = ref.watch(filesStreamProvider(module.id));
    final handshakesAsync = ref.watch(handshakesStreamProvider);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => setState(() => _selectedModule = null),
          ),
          title: Text(module.name),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Checklist'),
              Tab(text: 'Documents'),
              Tab(text: 'Handshakes'),
              Tab(text: 'Timeline'),
            ],
            labelColor: AppColors.primaryLight,
            unselectedLabelColor: Colors.white54,
            indicatorColor: AppColors.primaryLight,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.darkBg, Color(0xFF131B2B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: TabBarView(
            children: [
              // Tasks tab
              _buildModuleTasksTab(module, tasksAsync),

              // Files tab
              _buildModuleFilesTab(module, filesAsync),

              // Handshakes tab
              _buildModuleHandshakeRequestTab(module, handshakesAsync),

              // Timeline tab
              _buildModuleTimelineTab(module, handshakesAsync),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModuleTasksTab(ModuleModel module, AsyncValue<List<TaskModel>> tasksAsync) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Internal Task checklists', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ElevatedButton.icon(
                onPressed: () => _showAddTaskDialog(context, module.id),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Task', style: TextStyle(fontSize: 11)),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: tasksAsync.when(
              data: (tasks) {
                if (tasks.isEmpty) return const Center(child: Text('No active tasks inside this module.', style: TextStyle(color: AppColors.textDarkSecondary)));
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, idx) {
                    final t = tasks[idx];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: _buildChecklistTaskCard(t),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleFilesTab(ModuleModel module, AsyncValue<List<FileModel>> filesAsync) {
    final _fileNameController = TextEditingController();
    final _fileSummaryController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Shared Workspace Documents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppColors.darkCard,
                      title: const Text('Upload Document Spec', style: TextStyle(color: Colors.white)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _fileNameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(labelText: 'File Name', hintText: 'system_layout_specs.pdf'),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _fileSummaryController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(labelText: 'Change Summary', hintText: 'Initial release of specs.'),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                        ElevatedButton(
                          onPressed: () async {
                            if (_fileNameController.text.isNotEmpty) {
                              await FirebaseService().uploadFile(
                                module.id,
                                _fileNameController.text,
                                'https://storage.googleapis.com/${_fileNameController.text}',
                                _fileSummaryController.text,
                              );
                              ref.invalidate(filesStreamProvider(module.id));
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Upload'),
                        )
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.cloud_upload_rounded, size: 16),
                label: const Text('Upload Spec', style: TextStyle(fontSize: 11)),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filesAsync.when(
              data: (files) {
                if (files.isEmpty) return const Center(child: Text('No specs uploaded in this workspace.', style: TextStyle(color: AppColors.textDarkSecondary)));
                return ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, idx) {
                    final f = files[idx];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: GlassCard(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                const SizedBox(height: 4),
                                Text('Version ${f.currentVersion} | Edited by ${f.updatedByName}', style: const TextStyle(fontSize: 11, color: AppColors.textDarkSecondary)),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.history_rounded, color: AppColors.primaryLight),
                                  onPressed: () => _showFileVersionHistory(context, f),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.system_update_alt_rounded, color: AppColors.success),
                                  onPressed: () {
                                    // replace file
                                    _showReplaceFileDialog(context, f);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleHandshakeRequestTab(ModuleModel module, AsyncValue<List<HandshakeModel>> hsAsync) {
    final authState = ref.read(authProvider);
    final user = authState.user!;
    final isLead = user.role == 'lead' && user.moduleId == module.id;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Incoming & Outgoing Handshakes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              if (isLead)
                ElevatedButton.icon(
                  onPressed: () => _showCreateHandshakeDialog(context, module),
                  icon: const Icon(Icons.handshake_rounded, size: 16),
                  label: const Text('Initiate Handoff', style: TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: hsAsync.when(
              data: (hList) {
                final related = hList.where((h) => h.senderModuleId == module.id || h.receiverModuleId == module.id).toList();
                if (related.isEmpty) {
                  return const Center(child: Text('No handshakes registered for this module.', style: TextStyle(color: AppColors.textDarkSecondary)));
                }

                // Split into incoming pending (to show action items) and general list
                final incomingPending = related.where((h) => h.receiverModuleId == module.id && h.status == 'pending' && isLead).toList();
                final others = related.where((h) => !(h.receiverModuleId == module.id && h.status == 'pending' && isLead)).toList();

                return ListView(
                  children: [
                    if (incomingPending.isNotEmpty) ...[
                      const Text(
                        'HANDOFF APPROVAL ACTIONS REQUIRED',
                        style: TextStyle(fontSize: 10, color: AppColors.warning, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                      ),
                      const SizedBox(height: 8),
                      ...incomingPending.map((h) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: GlassCard(
                          borderColor: AppColors.warning,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Handoff from ${h.senderModuleId == 'mod_design' ? 'Design Studio' : 'Software Development'}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(height: 4),
                              Text(h.comments, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton(
                                    onPressed: () => _showReviewHandshakeDialog(context, h, false),
                                    style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.danger)),
                                    child: const Text('REJECT', style: TextStyle(color: AppColors.danger, fontSize: 11)),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () => _showReviewHandshakeDialog(context, h, true),
                                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                                    child: const Text('ACCEPT & AUDIT', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )),
                      const SizedBox(height: 16),
                    ],

                    if (others.isNotEmpty) ...[
                      const Text(
                        'HISTORICAL HANDSHAKE PIPELINE',
                        style: TextStyle(fontSize: 10, color: AppColors.textDarkSecondary, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                      ),
                      const SizedBox(height: 8),
                      ...others.map((h) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: GlassCard(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${h.senderModuleId == 'mod_design' ? 'Design' : 'Dev'} ➔ ${h.receiverModuleId == 'mod_dev' ? 'Dev' : 'QA'}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(Formatters.formatRelative(h.timestamp), style: const TextStyle(fontSize: 11, color: AppColors.textDarkSecondary)),
                                ],
                              ),
                              _buildMiniStatusBadge(h.status),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleTimelineTab(ModuleModel module, AsyncValue<List<HandshakeModel>> hsAsync) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Deliverable Timeline Log', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            hsAsync.when(
              data: (hList) => HandshakeTimelineWidget(
                handshakes: hList.where((h) => h.senderModuleId == module.id || h.receiverModuleId == module.id).toList(),
                modules: ref.read(modulesStreamProvider).maybeWhen(data: (d) => d, orElse: () => []),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'accepted':
        color = AppColors.success;
        break;
      case 'rejected':
        color = AppColors.danger;
        break;
      case 'pending':
      default:
        color = AppColors.warning;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
      child: Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  // --- DIALOG MODALS FOR HACKATHON INTERACTIONS ---
  void _showAddChecklistDialog(BuildContext context, String taskId) {
    final _titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: const Text('Add Checklist Requirement', style: TextStyle(color: Colors.white)),
        content: TextFormField(
          controller: _titleController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Task Requirement', hintText: 'Write unit tests'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (_titleController.text.isNotEmpty) {
                await FirebaseService().addChecklistItem(taskId, _titleController.text);
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, String moduleId) {
    final _titleController = TextEditingController();
    final _descController = TextEditingController();
    String _priority = 'medium';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: const Text('Create Module Task', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _priority,
              dropdownColor: AppColors.darkCard,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Priority'),
              items: const [
                DropdownMenuItem(value: 'low', child: Text('Low')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'high', child: Text('High')),
              ],
              onChanged: (val) {
                if (val != null) _priority = val;
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (_titleController.text.isNotEmpty) {
                await FirebaseService().createTask(
                  moduleId,
                  _titleController.text,
                  _descController.text,
                  DateTime.now().add(const Duration(days: 4)),
                  _priority,
                  FirebaseService().currentUser!.uid,
                );
                ref.invalidate(tasksStreamProvider(moduleId));
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showFileVersionHistory(BuildContext context, FileModel file) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => FutureBuilder<List<FileVersionModel>>(
        future: FirebaseService().getFileHistory(file.id),
        builder: (context, snap) {
          final history = snap.data ?? [];
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Version History: ${file.name}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: history.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, idx) {
                      final fv = history[idx];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Version ${fv.versionNumber}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryLight)),
                                Text(Formatters.formatRelative(fv.timestamp), style: const TextStyle(fontSize: 10, color: AppColors.textDarkSecondary)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(fv.changeSummary, style: const TextStyle(fontSize: 12, color: Colors.white)),
                            const SizedBox(height: 6),
                            Text('Modified by ${fv.editorName}', style: const TextStyle(fontSize: 10, color: AppColors.textDarkSecondary)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showReplaceFileDialog(BuildContext context, FileModel file) {
    final _summaryController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: const Text('Update Document Version', style: TextStyle(color: Colors.white)),
        content: TextFormField(
          controller: _summaryController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Change Summary', hintText: 'Fixed database naming discrepancies.'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (_summaryController.text.isNotEmpty) {
                await FirebaseService().replaceFileVersion(
                  file.id,
                  'https://storage.googleapis.com/${file.name}',
                  _summaryController.text,
                );
                ref.invalidate(filesStreamProvider(file.moduleId));
                Navigator.pop(context);
              }
            },
            child: const Text('Publish'),
          ),
        ],
      ),
    );
  }

  void _showCreateHandshakeDialog(BuildContext context, ModuleModel module) {
    final _proofController = TextEditingController();
    final _commentController = TextEditingController();
    String _targetModuleId = 'mod_dev';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: const Text('Create Digital Handshake', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _targetModuleId,
              dropdownColor: AppColors.darkCard,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Target Department'),
              items: const [
                DropdownMenuItem(value: 'mod_dev', child: Text('Software Development')),
                DropdownMenuItem(value: 'mod_qa', child: Text('Quality Assurance')),
                DropdownMenuItem(value: 'mod_deploy', child: Text('Release Operations')),
              ],
              onChanged: (val) {
                if (val != null) _targetModuleId = val;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _proofController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Proof URL', hintText: 'Figma specs or APK url'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _commentController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Handoff Comments'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (_proofController.text.isNotEmpty) {
                await FirebaseService().createHandshake(
                  module.id,
                  _targetModuleId,
                  ['file_design_specs'],
                  _proofController.text,
                  _commentController.text,
                );
                ref.invalidate(handshakesStreamProvider);
                Navigator.pop(context);
              }
            },
            child: const Text('Initiate'),
          ),
        ],
      ),
    );
  }

  void _showReviewHandshakeDialog(BuildContext context, HandshakeModel hs, bool isAccepted) {
    final _reasonController = TextEditingController();
    
    if (isAccepted) {
      // Direct accept
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.darkCard,
          title: const Text('Confirm Deliverable Handshake', style: TextStyle(color: Colors.white)),
          content: const Text('This creates an audit trail signing off on the transfer, making your department accountable for downstream implementation.', style: TextStyle(color: Colors.white70, fontSize: 13)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                await FirebaseService().reviewHandshake(hs.id, true, null);
                ref.invalidate(handshakesStreamProvider);
                ref.invalidate(modulesStreamProvider);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
              child: const Text('ACCEPT SIGNATURE'),
            ),
          ],
        ),
      );
    } else {
      // Need rejection reason
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.darkCard,
          title: const Text('Reject Handoff Transfer', style: TextStyle(color: Colors.white)),
          content: TextFormField(
            controller: _reasonController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Rejection Reason Commentary', hintText: 'Missing high-fidelity asset exports.'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (_reasonController.text.isNotEmpty) {
                  await FirebaseService().reviewHandshake(hs.id, false, _reasonController.text);
                  ref.invalidate(handshakesStreamProvider);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
              child: const Text('SUBMIT REJECTION'),
            ),
          ],
        ),
      );
    }
  }
}
