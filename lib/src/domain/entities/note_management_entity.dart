class NoteManagementEntity {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;

  const NoteManagementEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteManagementEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
