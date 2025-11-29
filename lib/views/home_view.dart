import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/timer_bloc.dart';
import '../bloc/timer_event.dart';
import '../bloc/timer_state.dart';
import 'set_timer_sheet.dart';
import '../widgets/circular_progress.dart';
import 'break_view.dart';
import 'leaderboard_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TimerStatus? _previousStatus;
  bool _workCompletedAlertShown = false;
  bool _breakPostureCheckShown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<TimerBloc, TimerState>(
          listener: (context, state) {
            // Check if work timer just completed
            if (_previousStatus != TimerStatus.completed &&
                state.status == TimerStatus.completed &&
                state.isWorkMode &&
                !_workCompletedAlertShown) {
              _workCompletedAlertShown = true;
              _showWorkCompletedAlert(context);
            }

            // Check if break timer just started and posture check hasn't been shown
            if (!state.isWorkMode &&
                state.status == TimerStatus.running &&
                !state.postureCheckShown &&
                !_breakPostureCheckShown) {
              // Show posture check after a few seconds
              Future.delayed(const Duration(seconds: 5), () {
                if (mounted &&
                    !state.isWorkMode &&
                    state.status == TimerStatus.running &&
                    !state.postureCheckShown) {
                  _breakPostureCheckShown = true;
                  context.read<TimerBloc>().add(MarkPostureCheckShown());
                  _showPostureCheckAlert(context);
                }
              });
            }

            // Reset flags when timer resets or starts fresh
            if (state.status == TimerStatus.initial) {
              _workCompletedAlertShown = false;
              _breakPostureCheckShown = false;
            }

            _previousStatus = state.status;
          },
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LeaderboardView()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMM dd, yyyy').format(DateTime.now()).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            letterSpacing: 1.2,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LeaderboardView()),
                            );
                          },
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: const Color(0xFFE8E0B8),
                            child: ClipOval(
                              child: Image.network(
                                'https://i.pravatar.cc/150?img=68',
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    size: 28,
                                    color: Color(0xFF2D2D44),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Hi!,\nJavier',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LeaderboardView()),
                        );
                      },
                      child: Center(
                        child: CircularProgress(
                          duration: state.duration,
                          initialDuration: state.initialDuration,
                          isWorkMode: state.isWorkMode,
                          workDuration: state.workDuration,
                          breakDuration: state.breakDuration,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            state.taskName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4E7E5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Color(0xFF2D2D44),
                            ),
                            onPressed: () {
                              _showEditTimerSheet(context, state.taskName);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Today\'s Activity',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8E0B8),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.circle,
                              color: Color(0xFF2D2D44),
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Working Time',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '${state.workDuration ~/ 3600} Hours',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (state.status == TimerStatus.initial) {
                              // Immediately start the timer with current settings
                              context.read<TimerBloc>().add(const StartTimer(true));
                            } else if (state.status == TimerStatus.running) {
                              context.read<TimerBloc>().add(PauseTimer());
                            } else if (state.status == TimerStatus.paused) {
                              context.read<TimerBloc>().add(ResumeTimer());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE8E0B8),
                            foregroundColor: const Color(0xFF2D2D44),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                state.status == TimerStatus.running
                                    ? 'Pause'
                                    : 'Start',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                state.status == TimerStatus.running
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFF666677),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Break Time',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              '${state.breakDuration ~/ 60} minutes',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      // Billy bikin tombol supaya bisa akses page Break
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BreakView()),
          );
        },
        backgroundColor: const Color(0xFFE8E0B8),
        child: const Icon(
          Icons.coffee,
          color: Color(0xFF2D2D44),
        ),
      ),
    );
  }

  void _showWorkCompletedAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFFD4E7E5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Time is Up!',
            style: TextStyle(
              color: Color(0xFF2D2D44),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Do you want to add overtime?',
            style: TextStyle(
              color: Color(0xFF2D2D44),
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<TimerBloc>().add(AddOvertime());
                _workCompletedAlertShown = false; // Reset for next time
              },
              child: const Text(
                'Add overtime',
                style: TextStyle(
                  color: Color(0xFF2D2D44),
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<TimerBloc>().add(StartBreak());
                _workCompletedAlertShown = false; // Reset for next time
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D2D44),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Break time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPostureCheckAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFFD4E7E5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D44),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.accessibility_new,
                  color: Color(0xFFE8E0B8),
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Posture Check!',
                  style: TextStyle(
                    color: Color(0xFF2D2D44),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'Are your shoulders relaxed? Is your back supported? Take a moment to adjust tension',
            style: TextStyle(
              color: Color(0xFF2D2D44),
              fontSize: 16,
              height: 1.4,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D2D44),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Got it!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditTimerSheet(BuildContext context, String currentTask) {
    final controller = TextEditingController(text: currentTask);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFD4E7E5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D44).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Task name input field
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(
                      color: Color(0xFF2D2D44),
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Task Name',
                      labelStyle: const TextStyle(
                        color: Color(0xFF2D2D44),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF2D2D44),
                          width: 2,
                        ),
                      ),
                    ),
                    onSubmitted: (value) {
                      context.read<TimerBloc>().add(UpdateTaskName(value));
                      Navigator.pop(context);
                    },
                  ),
                ),
                // Set Timer Sheet
                const SetTimerSheet(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
