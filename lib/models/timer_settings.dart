import 'package:hive/hive.dart';

part 'timer_settings.g.dart';

@HiveType(typeId: 0)
class TimerSettings extends HiveObject {
  @HiveField(0)
  int workDuration; // in seconds

  @HiveField(1)
  int breakDuration; // in seconds

  TimerSettings({required this.workDuration, required this.breakDuration});
}
