import 'package:architecture_management_data/src/domain/entities/entities.dart';

/// Data model สำหรับ serialize/deserialize [NoteManagementEntity]
///
/// extends [NoteManagementEntity] เพื่อใช้แทนกันได้ใน Repository
/// แต่เพิ่ม [fromJson], [toJson], [fromEntity] สำหรับ data mapping
class NoteManagementModel extends NoteManagementEntity {
  const NoteManagementModel({
    required super.id,
    required super.name,
    required super.description,
    required super.createdAt,
  });

  factory NoteManagementModel.fromJson(Map<String, dynamic> json) {
    return NoteManagementModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory NoteManagementModel.fromEntity(NoteManagementEntity entity) {
    return NoteManagementModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      createdAt: entity.createdAt,
    );
  }
}
