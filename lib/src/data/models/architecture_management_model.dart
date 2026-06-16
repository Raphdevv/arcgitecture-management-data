import '../../domain/entities/architecture_management_entity.dart';

class ArchitectureManagementModel extends ArchitectureManagementEntity {
  const ArchitectureManagementModel({
    required super.id,
    required super.name,
    required super.description,
    required super.createdAt,
  });

  factory ArchitectureManagementModel.fromJson(Map<String, dynamic> json) {
    return ArchitectureManagementModel(
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

  factory ArchitectureManagementModel.fromEntity(
    ArchitectureManagementEntity entity,
  ) {
    return ArchitectureManagementModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      createdAt: entity.createdAt,
    );
  }
}
