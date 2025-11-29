import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/timer_bloc.dart';
import '../bloc/timer_state.dart';
import '../widgets/videocard.dart';

class BreakView extends StatelessWidget {
  const BreakView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D44),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: BlocBuilder<TimerBloc, TimerState>(
          builder: (context, state) {
            // Show timer status in app bar if in break mode
            if (!state.isWorkMode && state.status == TimerStatus.running) {
              return Text(
                'Break: ${_formatDuration(state.duration)}',
                style: const TextStyle(
                  color: Color(0xFFE8E0B8),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              );
            }
            return const Text(
              'Break Time',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMM dd, yyyy').format(DateTime.now()).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Break \nTime',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              // Timer status indicator
              BlocBuilder<TimerBloc, TimerState>(
                builder: (context, state) {
                  if (!state.isWorkMode && state.status == TimerStatus.running) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF666677),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Break Timer Active',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _formatDuration(state.duration),
                                style: const TextStyle(
                                  color: Color(0xFFE8E0B8),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.timer,
                            color: Color(0xFFE8E0B8),
                            size: 32,
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  children: [
                    const SizedBox(height: 24),
                    VideoCard(
                      title: 'Tendon Glides',
                      description: '30 - 60 seconds each',
                      videoPath: 'assets/break_vids/break_vid1.mp4',
                    ),
                    const SizedBox(height: 16),
                    VideoCard(
                      title: 'Nerve Glides',
                      description: '30 - 60 seconds each',
                      videoPath: 'assets/break_vids/break_vid2.mp4',
                    ),
                    const SizedBox(height: 16),
                    VideoCard(
                      title: 'Thoracic Rotation',
                      description: '1 - 2 sets; 10 - 12 reps each side',
                      videoPath: 'assets/break_vids/break_vid3.mp4',
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
