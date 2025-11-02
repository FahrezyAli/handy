// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimerSettingsAdapter extends TypeAdapter<TimerSettings> {
  @override
  final int typeId = 0;

  @override
  TimerSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimerSettings(
      workDuration: fields[0] as int,
      breakDuration: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TimerSettings obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.workDuration)
      ..writeByte(1)
      ..write(obj.breakDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
