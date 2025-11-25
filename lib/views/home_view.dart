import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/timer_bloc.dart';
import '../bloc/timer_event.dart';
import '../bloc/timer_state.dart';
import 'set_timer_sheet.dart';
import '../widgets/circular_progress.dart';
import 'break_view.dart';


class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TimerBloc, TimerState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: ListView(
                children: [
                  Text(
                    DateFormat(
                      'MMM dd, yyyy',
                    ).format(DateTime.now()).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      letterSpacing: 1.2,
                    ),
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
                  Center(
                    child: CircularProgress(
                      duration: state.duration,
                      initialDuration: state.initialDuration,
                      isWorkMode: state.isWorkMode,
                      workDuration: state.workDuration,
                      breakDuration: state.breakDuration,
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
                            _showEditTaskDialog(context, state.taskName);
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
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const SetTimerSheet(),
                            );
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

  void _showEditTaskDialog(BuildContext context, String currentTask) {
    final controller = TextEditingController(text: currentTask);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF3D3D54),
        title: const Text(
          'Edit Task Name',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter task name',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE8E0B8)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TimerBloc>().add(UpdateTaskName(controller.text));
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
