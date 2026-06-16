/// Business object หลักของระบบ Note
///
/// เป็น pure Dart class ไม่มี dependency กับ library ภายนอก
/// ไม่มี JSON parsing — ใช้ [NoteManagementModel] สำหรับการ serialize
///
/// การเปรียบเทียบ (`==`) ใช้ [id] เป็น key หลัก
class NoteManagementEntity {
  /// Unique identifier ของ note (UUID v4)
  final String id;

  /// ชื่อของ note
  final String name;

  /// รายละเอียดของ note
  final String description;

  /// วันเวลาที่สร้าง note (UTC)
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
