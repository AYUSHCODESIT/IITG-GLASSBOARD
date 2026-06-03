import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/handshake_model.dart';
import '../models/module_model.dart';
import '../core/utils/formatters.dart';
import 'glass_widgets.dart';

class HandshakeTimelineWidget extends StatelessWidget {
  final List<HandshakeModel> handshakes;
  final List<ModuleModel> modules;
  final Function(HandshakeModel)? onHandshakeTap;

  const HandshakeTimelineWidget({
    Key? key,
    required this.handshakes,
    required this.modules,
    this.onHandshakeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (handshakes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'No Handshake events found.',
            style: TextStyle(color: AppColors.textDarkSecondary),
          ),
        ),
      );
    }

    final moduleMap = {for (var m in modules) m.id: m.name};
    // Sort in reverse chronological order
    final sorted = List<HandshakeModel>.from(handshakes)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final hs = sorted[index];
        final senderName = moduleMap[hs.senderModuleId] ?? hs.senderModuleId;
        final receiverName = moduleMap[hs.receiverModuleId] ?? hs.receiverModuleId;
        
        return InkWell(
          onTap: onHandshakeTap != null ? () => onHandshakeTap!(hs) : null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimelineIndicator(context, hs.status, index == sorted.length - 1),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0, left: 16.0, right: 8.0),
                  child: GlassCard(
                    padding: const EdgeInsets.all(16.0),
                    borderColor: _getStatusBorderColor(hs.status),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$senderName ➔ $receiverName',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            _buildMiniStatusBadge(hs.status),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Timestamp
                        Text(
                          Formatters.formatRelative(hs.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textDarkSecondary.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Comments
                        Text(
                          hs.comments,
                          style: const TextStyle(fontSize: 13, color: Colors.white),
                        ),

                        // Rejection Reason
                        if (hs.status == 'rejected' && hs.rejectionReason != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.danger.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.danger.withOpacity(0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.gpp_bad_rounded, color: AppColors.danger, size: 16),
                                    SizedBox(width: 6),
                                    Text(
                                      'REJECTION COMMENTARY',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.danger,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  hs.rejectionReason!,
                                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Attachments count
                        if (hs.attachedFileIds.isNotEmpty || hs.proofUrls.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.attachment_rounded, color: AppColors.primaryLight, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${hs.attachedFileIds.length} files attached | ${hs.proofUrls.length} proofs provided',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.primaryLight,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimelineIndicator(BuildContext context, String status, bool isLast) {
    Color color;
    IconData icon;

    switch (status) {
      case 'accepted':
        color = AppColors.success;
        icon = Icons.check_circle_rounded;
        break;
      case 'rejected':
        color = AppColors.danger;
        icon = Icons.cancel_rounded;
        break;
      case 'pending':
      default:
        color = AppColors.warning;
        icon = Icons.pending_rounded;
        break;
    }

    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        if (!isLast)
          Container(
            width: 2,
            height: 140, // Height to span downstream card spacing
            color: Colors.white.withOpacity(0.1),
          ),
      ],
    );
  }

  Color _getStatusBorderColor(String status) {
    switch (status) {
      case 'accepted':
        return AppColors.success.withOpacity(0.4);
      case 'rejected':
        return AppColors.danger.withOpacity(0.4);
      case 'pending':
      default:
        return AppColors.warning.withOpacity(0.4);
    }
  }

  Widget _buildMiniStatusBadge(String status) {
    Color color;
    String text;

    switch (status) {
      case 'accepted':
        color = AppColors.success;
        text = 'ACCEPTED';
        break;
      case 'rejected':
        color = AppColors.danger;
        text = 'REJECTED';
        break;
      case 'pending':
      default:
        color = AppColors.warning;
        text = 'PENDING';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
