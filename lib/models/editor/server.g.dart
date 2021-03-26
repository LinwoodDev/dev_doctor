// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServerEditorBlocAdapter extends TypeAdapter<ServerEditorBloc> {
  @override
  final int typeId = 2;

  @override
  ServerEditorBloc read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServerEditorBloc(
      note: fields[1] as String,
    )..server = fields[0] as CoursesServer;
  }

  @override
  void write(BinaryWriter writer, ServerEditorBloc obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.server)
      ..writeByte(1)
      ..write(obj.note)
      ..writeByte(2)
      ..write(obj._courses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerEditorBlocAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
