import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularProgress extends StatelessWidget {
  final int duration;
  final int initialDuration;
  final bool isWorkMode;
  final int workDuration;
  final int breakDuration;

  const CircularProgress({
    super.key,
    required this.duration,
    required this.initialDuration,
    required this.isWorkMode,
    required this.workDuration,
    required this.breakDuration,
  });

  @override
  Widget build(BuildContext context) {
    final progress = initialDuration > 0 ? duration / initialDuration : 0.0;

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(280, 280),
            painter: CircularProgressPainter(
              progress: progress,
              isWorkMode: isWorkMode,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Remaining',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              Text(
                isWorkMode ? 'Work Time:' : 'Break Time:',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                _formatDuration(duration),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final bool isWorkMode;

  CircularProgressPainter({required this.progress, required this.isWorkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 14;

    // Background circle - inverse color based on mode
    final backgroundPaint = Paint()
      ..color = isWorkMode ? const Color(0xFF666677) : const Color(0xFFE8E0B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress circle - inverse color based on mode
    final progressPaint = Paint()
      ..color = isWorkMode ? const Color(0xFFE8E0B8) : const Color(0xFF666677)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isWorkMode != isWorkMode;
  }
}
