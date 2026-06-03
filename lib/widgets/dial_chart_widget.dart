import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class DialChartWidget extends StatelessWidget {
  final double score;
  final String label;

  const DialChartWidget({
    Key? key,
    required this.score,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 180,
          height: 120,
          child: CustomPaint(
            painter: _DialPainter(score: score),
          ),
        ),
        Text(
          '${score.toStringAsFixed(0)}%',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textDarkSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _DialPainter extends CustomPainter {
  final double score;

  _DialPainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    // Draw background arc (half-circle gauge)
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 10),
      pi,
      pi,
      false,
      bgPaint,
    );

    // Draw active colored arc based on efficiency score
    final scoreFraction = (score / 100.0).clamp(0.0, 1.0);
    
    // Choose colors based on rating
    Color activeColor;
    if (scoreFraction < 0.4) {
      activeColor = AppColors.danger;
    } else if (scoreFraction < 0.7) {
      activeColor = AppColors.warning;
    } else {
      activeColor = AppColors.success;
    }

    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    // Draw glow shadow
    final shadowPaint = Paint()
      ..color = activeColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    if (scoreFraction > 0.0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 10),
        pi,
        pi * scoreFraction,
        false,
        shadowPaint,
      );

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 10),
        pi,
        pi * scoreFraction,
        false,
        activePaint,
      );
    }

    // Draw needle
    final needleAngle = pi + (pi * scoreFraction);
    final needleLength = radius - 25;
    final needleEnd = Offset(
      center.dx + needleLength * cos(needleAngle),
      center.dy + needleLength * sin(needleAngle),
    );

    final needlePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, needleEnd, needlePaint);

    // Needle hub center circle
    final hubPaint = Paint()
      ..color = AppColors.darkBg
      ..style = PaintingStyle.fill;

    final hubBorderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, 8, hubPaint);
    canvas.drawCircle(center, 8, hubBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
