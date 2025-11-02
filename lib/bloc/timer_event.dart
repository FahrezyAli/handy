import 'package:equatable/equatable.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object?> get props => [];
}

class StartTimer extends TimerEvent {
  final bool isWorkMode;
  const StartTimer(this.isWorkMode);

  @override
  List<Object?> get props => [isWorkMode];
}

class PauseTimer extends TimerEvent {}

class ResumeTimer extends TimerEvent {}

class ResetTimer extends TimerEvent {}

class TimerTick extends TimerEvent {
  final int duration;
  const TimerTick(this.duration);

  @override
  List<Object?> get props => [duration];
}

class UpdateSettings extends TimerEvent {
  final int workDuration;
  final int breakDuration;

  const UpdateSettings({
    required this.workDuration,
    required this.breakDuration,
  });

  @override
  List<Object?> get props => [workDuration, breakDuration];
}

class UpdateTaskName extends TimerEvent {
  final String taskName;
  const UpdateTaskName(this.taskName);

  @override
  List<Object?> get props => [taskName];
}
