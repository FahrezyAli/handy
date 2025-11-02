import 'package:hive/hive.dart';

part 'work_session.g.dart';

@HiveType(typeId: 1)
class WorkSession extends HiveObject {
  @HiveField(0)
  String taskName;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  int workDuration; // in seconds

  @HiveField(3)
  int breakDuration; // in seconds

  WorkSession({
    required this.taskName,
    required this.date,
    required this.workDuration,
    required this.breakDuration,
  });
}
