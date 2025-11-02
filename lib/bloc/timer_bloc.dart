import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'timer_event.dart';
import 'timer_state.dart';
import '../models/timer_settings.dart';
import '../models/work_session.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  Timer? _timer;
  final Box<TimerSettings> _settingsBox = Hive.box<TimerSettings>('settings');
  final Box<WorkSession> _sessionsBox = Hive.box<WorkSession>('sessions');

  TimerBloc() : super(TimerState.initial()) {
    _loadSettings();

    on<StartTimer>(_onStartTimer);
    on<PauseTimer>(_onPauseTimer);
    on<ResumeTimer>(_onResumeTimer);
    on<ResetTimer>(_onResetTimer);
    on<TimerTick>(_onTimerTick);
    on<UpdateSettings>(_onUpdateSettings);
    on<UpdateTaskName>(_onUpdateTaskName);
  }

  void _loadSettings() {
    if (_settingsBox.isNotEmpty) {
      final settings = _settingsBox.getAt(0);
      if (settings != null) {
        add(
          UpdateSettings(
            workDuration: settings.workDuration,
            breakDuration: settings.breakDuration,
          ),
        );
      }
    }
  }

  void _onStartTimer(StartTimer event, Emitter<TimerState> emit) {
    _timer?.cancel();
    final duration = event.isWorkMode
        ? state.workDuration
        : state.breakDuration;

    emit(
      state.copyWith(
        duration: duration,
        initialDuration: duration,
        status: TimerStatus.running,
        isWorkMode: event.isWorkMode,
      ),
    );

    _startTicking();
  }

  void _onPauseTimer(PauseTimer event, Emitter<TimerState> emit) {
    _timer?.cancel();
    emit(state.copyWith(status: TimerStatus.paused));
  }

  void _onResumeTimer(ResumeTimer event, Emitter<TimerState> emit) {
    emit(state.copyWith(status: TimerStatus.running));
    _startTicking();
  }

  void _onResetTimer(ResetTimer event, Emitter<TimerState> emit) {
    _timer?.cancel();
    emit(
      TimerState.initial().copyWith(
        workDuration: state.workDuration,
        breakDuration: state.breakDuration,
        taskName: state.taskName,
      ),
    );
  }

  void _onTimerTick(TimerTick event, Emitter<TimerState> emit) {
    if (event.duration > 0) {
      emit(state.copyWith(duration: event.duration));
    } else {
      _timer?.cancel();
      emit(state.copyWith(status: TimerStatus.completed, duration: 0));
      _saveSession();
    }
  }

  void _onUpdateSettings(UpdateSettings event, Emitter<TimerState> emit) {
    final settings = TimerSettings(
      workDuration: event.workDuration,
      breakDuration: event.breakDuration,
    );

    _settingsBox.clear();
    _settingsBox.add(settings);

    emit(
      state.copyWith(
        workDuration: event.workDuration,
        breakDuration: event.breakDuration,
        duration: state.isWorkMode ? event.workDuration : event.breakDuration,
        initialDuration: state.isWorkMode
            ? event.workDuration
            : event.breakDuration,
      ),
    );
  }

  void _onUpdateTaskName(UpdateTaskName event, Emitter<TimerState> emit) {
    emit(state.copyWith(taskName: event.taskName));
  }

  void _startTicking() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(TimerTick(state.duration - 1));
    });
  }

  void _saveSession() {
    final session = WorkSession(
      taskName: state.taskName,
      date: DateTime.now(),
      workDuration: state.isWorkMode
          ? state.initialDuration - state.duration
          : 0,
      breakDuration: !state.isWorkMode
          ? state.initialDuration - state.duration
          : 0,
    );
    _sessionsBox.add(session);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
