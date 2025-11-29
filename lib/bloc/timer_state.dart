import 'package:equatable/equatable.dart';

enum TimerStatus { initial, running, paused, completed }

class TimerState extends Equatable {
  final int duration;
  final int initialDuration;
  final TimerStatus status;
  final bool isWorkMode;
  final int workDuration;
  final int breakDuration;
  final String taskName;
  final bool postureCheckShown;

  const TimerState({
    required this.duration,
    required this.initialDuration,
    required this.status,
    required this.isWorkMode,
    required this.workDuration,
    required this.breakDuration,
    required this.taskName,
    this.postureCheckShown = false,
  });

  factory TimerState.initial() {
    return const TimerState(
      duration: 7200, // 2 hours
      initialDuration: 7200,
      status: TimerStatus.initial,
      isWorkMode: true,
      workDuration: 7200,
      breakDuration: 900, // 15 minutes
      taskName: 'Making 3D Design',
      postureCheckShown: false,
    );
  }

  TimerState copyWith({
    int? duration,
    int? initialDuration,
    TimerStatus? status,
    bool? isWorkMode,
    int? workDuration,
    int? breakDuration,
    String? taskName,
    bool? postureCheckShown,
  }) {
    return TimerState(
      duration: duration ?? this.duration,
      initialDuration: initialDuration ?? this.initialDuration,
      status: status ?? this.status,
      isWorkMode: isWorkMode ?? this.isWorkMode,
      workDuration: workDuration ?? this.workDuration,
      breakDuration: breakDuration ?? this.breakDuration,
      taskName: taskName ?? this.taskName,
      postureCheckShown: postureCheckShown ?? this.postureCheckShown,
    );
  }

  @override
  List<Object?> get props => [
    duration,
    initialDuration,
    status,
    isWorkMode,
    workDuration,
    breakDuration,
    taskName,
    postureCheckShown,
  ];
}
