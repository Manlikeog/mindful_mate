// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relaxation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RelaxationAdapter extends TypeAdapter<Relaxation> {
  @override
  final int typeId = 4;

  @override
  Relaxation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Relaxation(
      id: fields[0] as String,
      title: fields[1] as String,
      level: fields[2] as int,
      duration: fields[3] as int,
      description: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Relaxation obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelaxationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
