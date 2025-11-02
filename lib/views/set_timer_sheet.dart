import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/timer_bloc.dart';
import '../bloc/timer_event.dart';
import '../bloc/timer_state.dart';

class SetTimerSheet extends StatefulWidget {
  const SetTimerSheet({super.key});

  @override
  State<SetTimerSheet> createState() => _SetTimerSheetState();
}

class _SetTimerSheetState extends State<SetTimerSheet> {
  bool isWorkMode = true;
  int workHours = 2;
  int workMinutes = 0;
  int workSeconds = 0;
  int breakHours = 0;
  int breakMinutes = 15;
  int breakSeconds = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFD4E7E5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D44).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Set Timer',
                    style: TextStyle(
                      color: Color(0xFF2D2D44),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFBBCBCA),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isWorkMode = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: isWorkMode
                                    ? const Color(0xFF2D2D44)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Text(
                                'Work',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isWorkMode
                                      ? Colors.white
                                      : const Color(0xFF2D2D44),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isWorkMode = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: !isWorkMode
                                    ? const Color(0xFF2D2D44)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Text(
                                'Break',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: !isWorkMode
                                      ? Colors.white
                                      : const Color(0xFF2D2D44),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTimePicker(
                          isWorkMode ? workHours : breakHours,
                          'Hours',
                          24,
                          (value) {
                            setState(() {
                              if (isWorkMode) {
                                workHours = value;
                              } else {
                                breakHours = value;
                              }
                            });
                          },
                        ),
                        _buildTimePicker(
                          isWorkMode ? workMinutes : breakMinutes,
                          'Min',
                          60,
                          (value) {
                            setState(() {
                              if (isWorkMode) {
                                workMinutes = value;
                              } else {
                                breakMinutes = value;
                              }
                            });
                          },
                        ),
                        _buildTimePicker(
                          isWorkMode ? workSeconds : breakSeconds,
                          'Sec',
                          60,
                          (value) {
                            setState(() {
                              if (isWorkMode) {
                                workSeconds = value;
                              } else {
                                breakSeconds = value;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF2D2D44),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final workDuration =
                                workHours * 3600 +
                                workMinutes * 60 +
                                workSeconds;
                            final breakDuration =
                                breakHours * 3600 +
                                breakMinutes * 60 +
                                breakSeconds;

                            context.read<TimerBloc>().add(
                              UpdateSettings(
                                workDuration: workDuration,
                                breakDuration: breakDuration,
                              ),
                            );
                            context.read<TimerBloc>().add(
                              const StartTimer(true),
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D2D44),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimePicker(
    int value,
    String label,
    int maxValue,
    Function(int) onChanged,
  ) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListWheelScrollView.useDelegate(
              controller: FixedExtentScrollController(initialItem: value),
              itemExtent: 40,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: onChanged,
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  if (index < 0 || index >= maxValue) return null;
                  return Center(
                    child: Text(
                      index.toString(),
                      style: TextStyle(
                        color: index == value
                            ? const Color(0xFF2D2D44)
                            : const Color(0xFF2D2D44).withOpacity(0.3),
                        fontSize: index == value ? 28 : 20,
                        fontWeight: index == value
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                },
                childCount: maxValue,
              ),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF2D2D44),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
