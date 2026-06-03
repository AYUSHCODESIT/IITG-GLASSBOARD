import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_colors.dart';
import '../models/module_model.dart';
import '../core/providers/state_providers.dart';
import 'glass_widgets.dart';

class DependencyGraphWidget extends ConsumerWidget {
  final List<ModuleModel> modules;
  final Function(ModuleModel) onModuleTap;

  const DependencyGraphWidget({
    Key? key,
    required this.modules,
    required this.onModuleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sort modules logically (dependencies first, or Design -> Dev -> QA -> Deploy)
    final orderedModules = _getOrderedModules();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(orderedModules.length, (index) {
            final module = orderedModules[index];
            final bottleneckReport = ref.watch(bottleneckProvider(module.id));
            final isRootCause = bottleneckReport.rootCauseModule?.id == module.id;

            return Row(
              children: [
                _buildModuleNode(context, module, isRootCause, bottleneckReport.isBlocked),
                if (index < orderedModules.length - 1) 
                  _buildConnectionArrow(context, orderedModules[index], orderedModules[index + 1]),
              ],
            );
          }),
        ),
      ),
    );
  }

  List<ModuleModel> _getOrderedModules() {
    // Standard hackathon order, or order by dependencies
    final List<ModuleModel> list = [];
    final design = modules.where((m) => m.id == 'mod_design').firstOrNull;
    final dev = modules.where((m) => m.id == 'mod_dev').firstOrNull;
    final qa = modules.where((m) => m.id == 'mod_qa').firstOrNull;
    final deploy = modules.where((m) => m.id == 'mod_deploy').firstOrNull;

    if (design != null) list.add(design);
    if (dev != null) list.add(dev);
    if (qa != null) list.add(qa);
    if (deploy != null) list.add(deploy);

    // Append any extra modules created by admins
    for (var m in modules) {
      if (!list.contains(m)) {
        list.add(m);
      }
    }
    return list;
  }

  Widget _buildModuleNode(BuildContext context, ModuleModel module, bool isRootCause, bool isBlocked) {
    Color statusColor;
    IconData statusIcon;
    Color borderColor = AppColors.darkBorder;
    
    if (isRootCause) {
      statusColor = AppColors.danger;
      statusIcon = Icons.report_problem_rounded;
      borderColor = AppColors.danger;
    } else if (module.status == 'blocked') {
      statusColor = AppColors.warning;
      statusIcon = Icons.block_flipped;
      borderColor = AppColors.warning;
    } else if (module.status == 'completed') {
      statusColor = AppColors.success;
      statusIcon = Icons.verified_rounded;
      borderColor = AppColors.success;
    } else {
      statusColor = AppColors.info;
      statusIcon = Icons.sync_rounded;
      borderColor = AppColors.primary.withOpacity(0.5);
    }

    return InkWell(
      onTap: () => onModuleTap(module),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          boxShadow: isRootCause 
              ? [
                  BoxShadow(
                    color: AppColors.danger.withOpacity(0.25),
                    blurRadius: 15,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: GlassCard(
          padding: const EdgeInsets.all(16.0),
          borderColor: borderColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title / Tag
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      module.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(statusIcon, color: statusColor, size: 20),
                ],
              ),
              const SizedBox(height: 8),
              
              // Progress Bar
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: module.progress / 100.0,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          module.status == 'completed' 
                              ? AppColors.success 
                              : AppColors.primary
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${module.progress.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Badges
              if (isRootCause)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.danger.withOpacity(0.4)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'ROOT BOTTLENECK',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                )
              else if (module.status == 'blocked')
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.warning.withOpacity(0.4)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.hourglass_empty_rounded, color: AppColors.warning, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'UPSTREAM BLOCK',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    module.status.replaceAll('_', ' ').toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionArrow(BuildContext context, ModuleModel parent, ModuleModel child) {
    final isBlocked = child.status == 'blocked';
    final color = isBlocked ? AppColors.danger.withOpacity(0.7) : AppColors.success.withOpacity(0.7);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 2,
                color: color,
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: color,
                size: 14,
              ),
            ],
          ),
          if (isBlocked)
            const Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                'BLOCKED',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: AppColors.danger,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
