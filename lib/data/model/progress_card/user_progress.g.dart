// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProgressAdapter extends TypeAdapter<UserProgress> {
  @override
  final int typeId = 1;

  @override
  UserProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProgress(
      level: fields[0] as int,
      totalPoints: fields[1] as int,
      streakCount: fields[2] as int,
      lastLogDate: fields[3] as DateTime?,
      lastMoodLogDate: fields[4] as DateTime?,
      lastRelaxationLogDate: fields[5] as DateTime?,
      challengeProgress: (fields[6] as Map).cast<String, int>(),
      completedChallenges: (fields[7] as List).cast<String>(),
      badges: (fields[8] as List).cast<String>(),
      completedRelaxations: (fields[9] as Map).cast<String, DateTime>(),
      moodLogDates: (fields[10] as List).cast<DateTime>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserProgress obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.level)
      ..writeByte(1)
      ..write(obj.totalPoints)
      ..writeByte(2)
      ..write(obj.streakCount)
      ..writeByte(3)
      ..write(obj.lastLogDate)
      ..writeByte(4)
      ..write(obj.lastMoodLogDate)
      ..writeByte(5)
      ..write(obj.lastRelaxationLogDate)
      ..writeByte(6)
      ..write(obj.challengeProgress)
      ..writeByte(7)
      ..write(obj.completedChallenges)
      ..writeByte(8)
      ..write(obj.badges)
      ..writeByte(9)
      ..write(obj.completedRelaxations)
      ..writeByte(10)
      ..write(obj.moodLogDates);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
